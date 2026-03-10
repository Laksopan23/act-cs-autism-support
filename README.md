# AutismCare

AutismCare is a clinical autism support platform with parent and doctor portals, AI-assisted voice/text analysis, doctor-reviewed treatment plans, care tracking, and downloadable reports.

## Features

- Parent and doctor authentication
- Child profiles and assigned specialists
- AI voice and text analysis
- Issue classification and urgency detection
- AI treatment suggestions with doctor review
- Ongoing care-plan tracking and downloadable reports
- Parent-doctor messaging and notifications

## Stack

- Frontend: React 18, Tailwind CSS
- Backend: Node.js, Express, MongoDB
- AI service: FastAPI, Transformers, scikit-learn
- Models: Whisper, RoBERTa, treatment recommender

## Prerequisites

- Node.js 18+
- Python 3.10+
- MongoDB 6+

## Setup

### 1. Install dependencies

```bash
npm install
npm install --prefix frontend
npm install --prefix backend

cd ai-service
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
cd ..
```

### 2. Configure environment files

`backend/.env`

```env
PORT=5000
MONGO_URI=mongodb://localhost:27017/autism_support
JWT_SECRET=your_jwt_secret_key_here
AI_URL=http://localhost:8000/analyze-voice
AI_TEXT_URL=http://localhost:8000/analyze-text
```

`ai-service/.env`

```env
PORT=8000
```

### 3. Seed data

```bash
npm run seed --prefix backend
npm run seed:demo --prefix backend
```

`seed:demo` adds sample users, children, analyses, and reviewed care plans without wiping existing data.

## Run

Open 3 terminals:

```bash
npm start --prefix frontend
node backend/index.js
cd ai-service
.venv\Scripts\python.exe -m uvicorn main:app --host 127.0.0.1 --port 8000
```

Services:

- Frontend: `http://localhost:3000`
- Backend: `http://localhost:5000`
- AI service: `http://localhost:8000`

## Main Paths

- Parent dashboard: `/parent/dashboard`
- Parent child profile: `/parent/children/:id`
- Doctor dashboard: `/doctor/dashboard`
- Doctor patient profile: `/doctor/patients/:id`

## API Overview

### Auth

- `POST /api/auth/register`
- `POST /api/auth/login`
- `GET /api/auth/me`

### Parent

- `GET /api/parent/children`
- `POST /api/parent/children`
- `GET /api/parent/children/:id`
- `GET /api/parent/children/:id/analyses`
- `POST /api/parent/children/:id/analyses`
- `GET /api/parent/analyses/:analysisId/report`

### Doctor

- `GET /api/doctor/patients`
- `GET /api/doctor/patients/:id`
- `GET /api/doctor/patients/:id/analyses`
- `POST /api/doctor/patients/:id/analyses`
- `PUT /api/doctor/analyses/:analysisId/review`
- `GET /api/doctor/analyses/:analysisId/report`

### AI service

- `POST /analyze-voice`
- `POST /analyze-text`
- `GET /health`

## Default Demo Credentials

- Parent: `parent@example.com / password123`
- Doctor: `doctor@example.com / password123`

## Notes

- The old legacy activity and image-emotion stack has been removed from the active runtime.
- Existing care-plan and analysis workflows remain active.
