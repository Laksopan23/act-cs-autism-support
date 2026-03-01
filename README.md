# AutismCare - AI-Powered Autism Therapy & Support Platform

A comprehensive healthcare platform for autism support, combining clinical management with advanced AI-powered emotional analytics, voice analysis, and personalized activity recommendations.

![Node.js](https://img.shields.io/badge/Node.js-18+-green)
![React](https://img.shields.io/badge/React-18-blue)
![Python](https://img.shields.io/badge/Python-3.10+-yellow)
![MongoDB](https://img.shields.io/badge/MongoDB-6+-green)

---

## 📋 Table of Contents

- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Prerequisites](#-prerequisites)
- [Installation](#-installation)
- [Running the Application](#-running-the-application)
- [Project Structure](#-project-structure)
- [API Endpoints](#-api-endpoints)
- [Default Credentials](#-default-credentials)
- [Troubleshooting](#-troubleshooting)

---

## ✨ Features

### 🏥 Clinical Management
- **Multi-Role Portal**: Secure authentication for Parents and Doctors
- **Child Profile Management**: Diagnosis tracking, severity assessment, specialist assignment
- **Real-time Chat**: Text and voice messaging between parents and doctors
- **Notification System**: Severity-based alerts (High/Medium/Low) for urgent updates

### 🧠 AI Diagnostic Suite
- **Emotion Recognition**: Real-time facial expression analysis using DenseNet-121
- **Voice Analysis**: Speech-to-text transcription with Whisper AI
- **Issue Classification**: Automated detection of behavioral issues (Meltdowns, Aggression, etc.)
- **Urgency Detection**: AI-powered triaging of communications
- **Smart Summarization**: Concise summaries of therapy sessions

### 🧩 Personalized Therapy System
- **Activity Recommendations**: Multi-factor scoring based on emotion, social status, severity
- **Progress Tracking**: Visual analytics with charts and trends
- **Therapy Dashboard**: Unified view of emotional wellness history

---

## 🛠 Tech Stack

| Component | Technology |
|-----------|------------|
| Frontend | React 18, Tailwind CSS, Recharts |
| Backend | Node.js, Express.js, MongoDB |
| AI Service | Python, FastAPI, TensorFlow |
| ML Models | DenseNet-121, Whisper, RoBERTa |
| Database | MongoDB |
| Auth | JWT (JSON Web Tokens) |

---

## 📦 Prerequisites

Before installation, ensure you have the following installed:

### Required Software

| Software | Version | Download |
|----------|---------|----------|
| Node.js | 18.x or higher | [nodejs.org](https://nodejs.org/) |
| Python | 3.10 or higher | [python.org](https://python.org/) |
| MongoDB | 6.x or higher | [mongodb.com](https://www.mongodb.com/try/download/community) |
| Git | Latest | [git-scm.com](https://git-scm.com/) |

### Verify Installation

```bash
node --version    # Should be v18.x.x or higher
npm --version     # Should be 9.x.x or higher
python --version  # Should be 3.10.x or higher
mongod --version  # Should be 6.x.x or higher
```

---

## 🚀 Installation

### Step 1: Clone the Repository

```bash
git clone https://github.com/Laksopan23/act-cs-autism-support.git
cd act-cs-autism-support
```

### Step 2: Install Node.js Dependencies

```bash
# Install root dependencies
npm install

# Install client dependencies
cd client
npm install
cd ..

# Install server dependencies
cd server
npm install
cd ..
```

### Step 3: Set Up Python Virtual Environment

```bash
cd ai-service

# Create virtual environment
python -m venv .venv

# Activate virtual environment
# Windows:
.venv\Scripts\activate
# macOS/Linux:
source .venv/bin/activate

# Install Python dependencies
pip install -r requirements.txt

cd ..
```

### Step 4: Configure Environment Variables

Create `.env` files in the following directories:

**server/.env**
```env
PORT=5000
MONGODB_URI=mongodb://localhost:27017/autism_support
JWT_SECRET=your_jwt_secret_key_here
AI_SERVICE_URL=http://localhost:9000
```

**ai-service/.env**
```env
PORT=9000
MODEL_PATH=./emotion_engine/models/densenet121_emotion_recognition_correct.keras
```

### Step 5: Start MongoDB

```bash
# Windows (if installed as service)
net start MongoDB

# Or run manually
mongod --dbpath /path/to/data/db
```

### Step 6: Seed the Database

```bash
cd server
node seed_activities.js
cd ..
```

---

## ▶️ Running the Application

### Option 1: Run All Services (Recommended)

Open 3 separate terminals:

**Terminal 1 - Backend Server:**
```bash
cd server
npm start
# Runs on http://localhost:5000
```

**Terminal 2 - Frontend Client:**
```bash
cd client
npm start
# Runs on http://localhost:3000
```

**Terminal 3 - AI Service:**
```bash
cd ai-service
.venv\Scripts\activate  # Windows
# source .venv/bin/activate  # macOS/Linux
python main.py
# Runs on http://localhost:9000
```

### Option 2: Use Windows Batch Script

```bash
START_ALL.bat
```

### Access the Application

| Service | URL |
|---------|-----|
| Frontend | http://localhost:3000 |
| Backend API | http://localhost:5000 |
| AI Service | http://localhost:9000 |

---

## 📁 Project Structure

```
act-cs-autism-support/
├── client/                 # React Frontend
│   ├── src/
│   │   ├── components/     # Reusable UI components
│   │   ├── pages/          # Page components (doctor/, parent/)
│   │   ├── contexts/       # React context providers
│   │   └── App.js          # Main app component
│   └── public/             # Static assets
│
├── server/                 # Node.js Backend
│   ├── models/             # MongoDB schemas
│   ├── routes/             # API route handlers
│   ├── middleware/         # Auth middleware
│   └── index.js            # Server entry point
│
├── ai-service/             # Python AI Service
│   ├── emotion_engine/     # Emotion recognition module
│   │   ├── models/         # ML model files
│   │   └── app.py          # FastAPI emotion service
│   ├── main.py             # Main FastAPI application
│   └── requirements.txt    # Python dependencies
│
├── models/                 # Pre-trained ML Models
│   ├── emotion_recognition/
│   ├── issue_classifier_roberta/
│   ├── summarization_t5/
│   └── urgency_classifier/
│
├── ai-research/            # Jupyter notebooks for training
├── legacy/                 # Original project backups
└── docs/                   # Documentation
```

---

## 🔌 API Endpoints

### Authentication
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/register` | Register new user |
| POST | `/api/auth/login` | User login |
| GET | `/api/auth/me` | Get current user |

### Parent Routes
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/parent/children` | Get all children |
| POST | `/api/parent/children` | Add new child |
| GET | `/api/parent/children/:id` | Get child details |

### Doctor Routes
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/doctor/patients` | Get assigned patients |
| GET | `/api/doctor/patients/:id` | Get patient details |
| POST | `/api/doctor/analyze` | Submit voice analysis |

### AI Service
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/analyze` | Analyze voice recording |
| POST | `/predict` | Predict emotion from image |
| GET | `/health` | Service health check |

---

## 🔐 Default Credentials

After running the seed script, use these test accounts:

| Role | Email | Password |
|------|-------|----------|
| Parent | parent@example.com | password123 |
| Doctor | doctor@example.com | password123 |

---

## 🔧 Troubleshooting

### Common Issues

**1. MongoDB Connection Error**
```
Error: connect ECONNREFUSED 127.0.0.1:27017
```
**Solution:** Ensure MongoDB is running:
```bash
# Windows
net start MongoDB
# macOS
brew services start mongodb-community
```

**2. Python Module Not Found**
```
ModuleNotFoundError: No module named 'tensorflow'
```
**Solution:** Activate virtual environment and install dependencies:
```bash
cd ai-service
.venv\Scripts\activate
pip install -r requirements.txt
```

**3. Port Already in Use**
```
Error: listen EADDRINUSE: address already in use :::5000
```
**Solution:** Kill the process using the port:
```bash
# Windows
netstat -ano | findstr :5000
taskkill /PID <PID> /F

# macOS/Linux
lsof -i :5000
kill -9 <PID>
```

**4. CORS Error in Browser**
**Solution:** Ensure backend is running and CORS is configured in `server/index.js`

**5. AI Service Not Responding**
**Solution:** Check if the AI service is running on port 9000:
```bash
curl http://localhost:9000/health
```

---

## 👥 Contributors

- **Laksopan23** - Full Stack Development & AI Integration

---

## 📄 License

This project is developed for educational purposes as part of the ACT-CS Autism Support initiative.

---

## 🙏 Acknowledgments

- TensorFlow team for DenseNet-121
- OpenAI for Whisper speech recognition
- Hugging Face for transformer models
