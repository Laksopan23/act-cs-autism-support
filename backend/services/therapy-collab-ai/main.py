import os
import shutil
from datetime import datetime
from typing import Any, Dict, List

import librosa
import torch
from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from transformers import pipeline

from treatment_recommender import load_treatment_model, predict_treatment_suggestions

UPLOAD_DIR = os.path.join(os.path.dirname(__file__), "uploads")
os.makedirs(UPLOAD_DIR, exist_ok=True)

SERVICE_DIR = os.path.dirname(__file__)
MODEL_ISSUE_DIR = os.getenv(
    "MODEL_ISSUE_DIR",
    os.path.join(SERVICE_DIR, "models", "issue_classifier_roberta")
)
MODEL_URGENCY_DIR = os.getenv(
    "MODEL_URGENCY_DIR",
    os.path.join(SERVICE_DIR, "models", "urgency_classifier", "checkpoints", "checkpoint-876")
)
MODEL_SUMM_DIR = os.getenv("MODEL_SUMM_DIR", "facebook/bart-large-cnn")
WHISPER_MODEL = os.getenv("WHISPER_MODEL", "openai/whisper-small")
MODEL_TREATMENT_DIR = os.getenv(
    "MODEL_TREATMENT_DIR",
    os.path.join(SERVICE_DIR, "models", "treatment_recommender")
)

try:
    import cv2
    import numpy as np
    import tensorflow as tf
    from PIL import Image
    from tensorflow.keras.applications.densenet import preprocess_input

    TF_AVAILABLE = True
except Exception:
    TF_AVAILABLE = False

MODEL_EMOTION_PATH = os.path.join(
    SERVICE_DIR,
    "emotion_engine",
    "models",
    "densenet121_emotion_recognition_correct.keras"
)
EMOTION_LABELS = ["Natural", "anger", "fear", "joy", "sadness", "surprise"]
emotion_model = None

app = FastAPI(title="ACT-CS AI Service", version="1.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

device = 0 if torch.cuda.is_available() else -1

asr = None
issue_clf = None
urgency_clf = None
summarizer = None
treatment_model = None
treatment_metadata = None


def top_k(scores: List[Dict[str, Any]], k=3):
    scores_sorted = sorted(scores, key=lambda item: item["score"], reverse=True)
    return [{"label": item["label"], "score": float(item["score"])} for item in scores_sorted[:k]]


def clean_text(text: str) -> str:
    return " ".join(str(text).strip().split())


def format_label(label: str) -> str:
    return " ".join(part.capitalize() for part in str(label or "unknown").split("_") if part) or "Unknown"


def build_result_summary(issue_label: str, urgency_label: str, summary: str) -> str:
    issue = format_label(issue_label)
    urgency = format_label(urgency_label).lower()
    clean_summary = clean_text(summary or "")

    if not clean_summary:
        return f"{issue} was identified with {urgency} urgency."
    return f"{issue} was identified with {urgency} urgency. {clean_summary}"


@app.on_event("startup")
def load_models():
    global asr, issue_clf, urgency_clf, summarizer, treatment_model, treatment_metadata, emotion_model

    try:
        print("Loading ASR model...")
        asr = pipeline("automatic-speech-recognition", model=WHISPER_MODEL, device=device)
        print("[OK] ASR model loaded")
    except Exception as exc:
        print(f"Error loading ASR: {exc}")
        asr = None

    try:
        print("Loading issue classifier...")
        issue_clf = pipeline(
            "text-classification",
            model=MODEL_ISSUE_DIR,
            tokenizer=MODEL_ISSUE_DIR,
            top_k=None,
            device=device,
        )
        print("[OK] Issue classifier loaded")
    except Exception as exc:
        print(f"Error loading issue classifier: {exc}")
        issue_clf = None

    try:
        print("Loading urgency classifier...")
        urgency_clf = pipeline(
            "text-classification",
            model=MODEL_URGENCY_DIR,
            tokenizer=MODEL_URGENCY_DIR,
            top_k=None,
            device=device,
        )
        print("[OK] Urgency classifier loaded")
    except Exception as exc:
        print(f"Error loading urgency classifier: {exc}")
        urgency_clf = None

    try:
        print("Loading summarizer...")
        summarizer = pipeline(
            "summarization",
            model=MODEL_SUMM_DIR,
            tokenizer=MODEL_SUMM_DIR,
            framework="pt",
            device=device,
        )
        print("[OK] Summarizer loaded")
    except Exception as exc:
        print(f"Error loading summarizer: {exc}")
        summarizer = None

    try:
        treatment_model, treatment_metadata = load_treatment_model(MODEL_TREATMENT_DIR)
        if treatment_model is not None:
            print(f"[OK] Treatment recommender loaded from {MODEL_TREATMENT_DIR}")
        else:
            print("Treatment recommender not found. Using rule fallback.")
    except Exception as exc:
        print(f"Error loading treatment recommender: {exc}")
        treatment_model = None
        treatment_metadata = None

    if TF_AVAILABLE and os.path.exists(MODEL_EMOTION_PATH):
        try:
            print(f"Loading emotion model from {MODEL_EMOTION_PATH}...")
            emotion_model = tf.keras.models.load_model(MODEL_EMOTION_PATH)
            print("[OK] Emotion model loaded")
        except Exception as exc:
            print(f"Error loading emotion model: {exc}")
            emotion_model = None
    else:
        print(f"Emotion model not found or TF not available. TF: {TF_AVAILABLE}")


@app.post("/analyze-voice")
async def analyze_voice(file: UploadFile = File(...)):
    try:
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        filename = f"{timestamp}_{file.filename}"
        audio_path = os.path.join(UPLOAD_DIR, filename)

        with open(audio_path, "wb") as handle:
            shutil.copyfileobj(file.file, handle)

        audio_data, sample_rate = librosa.load(audio_path, sr=16000)
        print(f"Audio loaded: shape={audio_data.shape}, sr={sample_rate}, duration={len(audio_data) / sample_rate:.2f}s")

        transcript = ""
        try:
            if asr:
                transcribed = asr(audio_data)
                transcript = clean_text(transcribed.get("text", ""))
        except Exception as exc:
            print(f"ASR Error: {exc}")
            transcript = ""

        issue_top3 = []
        issue_label = "UNKNOWN"
        try:
            if transcript and issue_clf:
                issue_scores = issue_clf(transcript)[0]
                issue_top3 = top_k(issue_scores, k=3)
                issue_label = issue_top3[0]["label"] if issue_top3 else "UNKNOWN"
        except Exception as exc:
            print(f"Issue classification error: {exc}")

        urgency_top3 = []
        urgency_label = "UNKNOWN"
        try:
            if transcript and urgency_clf:
                urgency_scores = urgency_clf(transcript)[0]
                urgency_top3 = top_k(urgency_scores, k=3)
                urgency_label = urgency_top3[0]["label"] if urgency_top3 else "UNKNOWN"
        except Exception as exc:
            print(f"Urgency classification error: {exc}")

        summary = transcript or "No transcript available"
        try:
            if transcript and summarizer and len(transcript.split()) > 20:
                summary = summarizer(transcript, max_length=48, min_length=18, do_sample=False)[0]["summary_text"]
        except Exception as exc:
            print(f"Summarization error: {exc}")

        result_summary = build_result_summary(issue_label, urgency_label, summary)
        treatment_result = predict_treatment_suggestions(
            treatment_model,
            treatment_metadata,
            transcript,
            issue_label,
            urgency_label
        )

        try:
            os.remove(audio_path)
        except OSError:
            pass

        return {
            "audio_filename": filename,
            "transcript": transcript,
            "issue_label": issue_label,
            "issue_top3": issue_top3,
            "urgency_label": urgency_label,
            "urgency_top3": urgency_top3,
            "summary": summary,
            "result_summary": result_summary,
            "treatment_suggestions": treatment_result["treatment_suggestions"],
            "treatment_profile": treatment_result["treatment_profile"],
            "treatment_model_used": treatment_result["treatment_model_used"],
            "treatment_model_confidence": treatment_result["treatment_model_confidence"],
            "treatment_training_mode": treatment_result["treatment_training_mode"],
        }
    except Exception as exc:
        print(f"Analyze voice error: {exc}")
        import traceback
        traceback.print_exc()
        return {
            "error": str(exc),
            "message": "Failed to analyze audio file"
        }


class TextRequest(BaseModel):
    text: str


@app.post("/analyze-text")
async def analyze_text(request: TextRequest):
    try:
        transcript = clean_text(request.text)

        issue_top3 = []
        issue_label = "UNKNOWN"
        try:
            if transcript and issue_clf:
                issue_scores = issue_clf(transcript)[0]
                issue_top3 = top_k(issue_scores, k=3)
                issue_label = issue_top3[0]["label"] if issue_top3 else "UNKNOWN"
        except Exception as exc:
            print(f"Issue classification error: {exc}")

        urgency_top3 = []
        urgency_label = "UNKNOWN"
        try:
            if transcript and urgency_clf:
                urgency_scores = urgency_clf(transcript)[0]
                urgency_top3 = top_k(urgency_scores, k=3)
                urgency_label = urgency_top3[0]["label"] if urgency_top3 else "UNKNOWN"
        except Exception as exc:
            print(f"Urgency classification error: {exc}")

        summary = transcript or "No transcript available"
        try:
            if transcript and summarizer and len(transcript.split()) > 20:
                summary = summarizer(transcript, max_length=48, min_length=18, do_sample=False)[0]["summary_text"]
        except Exception as exc:
            print(f"Summarization error: {exc}")

        result_summary = build_result_summary(issue_label, urgency_label, summary)
        treatment_result = predict_treatment_suggestions(
            treatment_model,
            treatment_metadata,
            transcript,
            issue_label,
            urgency_label
        )

        return {
            "transcript": transcript,
            "issue_label": issue_label,
            "issue_top3": issue_top3,
            "urgency_label": urgency_label,
            "urgency_top3": urgency_top3,
            "summary": summary,
            "result_summary": result_summary,
            "treatment_suggestions": treatment_result["treatment_suggestions"],
            "treatment_profile": treatment_result["treatment_profile"],
            "treatment_model_used": treatment_result["treatment_model_used"],
            "treatment_model_confidence": treatment_result["treatment_model_confidence"],
            "treatment_training_mode": treatment_result["treatment_training_mode"],
        }
    except Exception as exc:
        print(f"Analyze text error: {exc}")
        import traceback
        traceback.print_exc()
        return {
            "error": str(exc),
            "message": "Failed to analyze text"
        }


@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    if not TF_AVAILABLE or emotion_model is None:
        return {"error": "Emotion model not loaded or TF not available", "emotion": "Neutral", "confidence": 0.0}

    try:
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        save_path = os.path.join(UPLOAD_DIR, f"{timestamp}_{file.filename}")
        with open(save_path, "wb") as handle:
            shutil.copyfileobj(file.file, handle)

        image = Image.open(save_path).convert("RGB")
        image = image.resize((224, 224))
        features = np.array(image).astype("float32")
        features = preprocess_input(features)
        features = np.expand_dims(features, 0)

        probabilities = emotion_model.predict(features, verbose=0)[0]
        top_index = int(np.argmax(probabilities))
        predicted = EMOTION_LABELS[top_index]
        probability_map = {EMOTION_LABELS[index]: float(probabilities[index]) for index in range(len(EMOTION_LABELS))}

        os.remove(save_path)

        return {
            "emotion": predicted,
            "confidence": float(probabilities[top_index]),
            "allPredictions": probability_map,
        }
    except Exception as exc:
        print(f"Emotion prediction error: {exc}")
        return {"error": str(exc), "emotion": "Neutral", "confidence": 0.0}


if __name__ == "__main__":
    import uvicorn

    uvicorn.run("main:app", host="0.0.0.0", port=int(os.environ.get("PORT", 7005)), reload=True)
