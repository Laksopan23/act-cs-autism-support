# AutismCare - Unified Autism Therapy & Support Platform

The definitive, AI-integrated platform combining the comprehensive clinical management of **ACAS** with the advanced emotional analytics and activity recommendations of **PATSS**.

---

## 🌟 Core Modules

### 1. 🏥 Clinical Management (ACAS)
- **Multi-Role Portal**: Secure access for Parents and Doctors.
- **Child Care System**: Detailed diagnosis tracking, milestone management, and specialist assignment.
- **Intelligent Communication**: Text and voice messaging with persistent history.
- **Notification Engine**: Severity-based alerts (High/Medium/Low) for urgent behavioral updates.

### 2. 🧠 AI Diagnostic Suite
- **Emotion Recognition (NEW)**: Real-time image-based facial expression analysis using DenseNet-121.
- **Voice Analysis**: Automated speech-to-text with issue classification (Meltdowns, Aggression, etc.).
- **Urgency Detection**: Automated triaging of therapist-parent communications.
- **AI Summarization**: Concise BART-powered summaries of therapeutic sessions.

### 3. 🧩 Personalized Therapy (PATSS)
- **Recommendation Engine**: Multi-factor scoring (Emotion, Social Status, Finance, Severity, Interests).
- **Activity Library**: 15+ specialized activities curated for social, behavioral, and emotional growth.
- **Therapy Dashboard**: A unified view for Parents including:
    - **Emotion Analytics**: Distribution and confidence trends.
    - **Progress Path**: Historical timeline of emotional wellness.

---

## 🚀 One-Click Quick Start

### Prerequisites
- Node.js & npm
- Python 3.10+
- MongoDB (Running on `localhost:27017`)

### Installation
From the project root:
```bash
npm run install:all
```

### Initialization
Seed the database with test users and activities:
```bash
npm run seed
```

### Launch
Start the frontend, backend, and AI service simultaneously:
```bash
npm start
```

---

## 🏗️ Project Structure
- `/client`: React Frontend (Tailwind + Recharts)
- `/server`: Express.js Backend (MongoDB/Mongoose)
- `/ai-service`: FastAPI Python Service (TensorFlow + Transformers)
- `/models`: Pre-trained ML weights (DenseNet, RoBERTa, Whisper)
- `/ai-research`: Original notebooks and training scripts
- `/legacy`: Backup of original individual project files

---

## 🧪 Default Test Credentials
Run `npm run seed` to initialize:
- **Parent**: `parent@example.com` / `password123`
- **Doctor**: `doctor@example.com` / `password123`

---
*This project represents the successful merger of ACT-CS-AUTISM-SUPPORT and PATSS into a single, cohesive ecosystem.*
