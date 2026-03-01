# Quick Start Guide - Complete Application

This guide will help you run all three components of the autism support application.

## Prerequisites

- **Node.js** 16+ installed (for both server and client)
- **Python** 3.8+ installed (for AI service)
- **Git** (optional, for version control)

## Step 1: Install Dependencies

### AI Service (FastAPI)

Already installed during previous setup. Virtual environment exists at `ai-service/.venv`

### Express Server (Port 5000)

```bash
cd server
npm install
```

### React Frontend (Port 3000)

```bash
cd client
npm install
```

## Step 2: Start All Services

Open **3 terminal windows** and run these commands:

### Terminal 1 - FastAPI Backend (Port 8000)

```bash
cd ai-service
.\.venv\Scripts\python.exe -m uvicorn main:app --port 8000
```

Expected output:

```
INFO:     Uvicorn running on http://127.0.0.1:8000
INFO:     Application startup complete
```

### Terminal 2 - Express Server (Port 5000)

```bash
cd server
npm start
```

Expected output:

```
Server running on port 5000
```

### Terminal 3 - React Frontend (Port 3000)

```bash
cd client
npm start
```

Expected output:

```
webpack compiled successfully
Compiled successfully!
```

Browser will automatically open at: http://localhost:3000

## Step 3: Using the Application

1. **Open** http://localhost:3000 in your browser
2. **Choose input method:**
   - 🎙️ Click "Start Recording" to record from your microphone
   - 📁 Click "Upload Audio File" to select an audio file (MP3, WAV, etc.)
3. **Analyze:** Click "📤 Analyze Audio" button
4. **Wait** for analysis (usually 30-60 seconds depending on audio length)
5. **Review** results:
   - Transcript of what was said
   - Identified issue with confidence scores
   - Urgency level (Low, Medium, High)
   - AI-generated summary
   - Recommended actions

## API Endpoints

### FastAPI (Port 8000)

- `POST /analyze-voice` - Main analysis endpoint
- `GET /docs` - Swagger API documentation

### Express Server (Port 5000)

- `GET /health` - Health check
- `POST /api/analyze` - Proxy to FastAPI (used by frontend)

### React Frontend (Port 3000)

- All UI accessible through web browser

## Troubleshooting

### "Port already in use" error

If port 8000, 5000, or 3000 is in use:

**Windows:**

```powershell
# Find process using port
netstat -ano | findstr ":8000"

# Kill process
taskkill /PID <PID> /F
```

**Mac/Linux:**

```bash
# Find and kill process
lsof -ti:8000 | xargs kill -9
```

### "Connection refused" error

Ensure all three services are running. Check:

1. Is FastAPI running on 8000? ✓
2. Is Express running on 5000? ✓
3. Is React running on 3000? ✓

### Audio not recording

- Check browser microphone permissions
- Try a different browser (Chrome recommended)
- Ensure you allow microphone access

### Empty transcript

- Audio file may not contain recognizable speech
- Try with clearer audio
- Check audio file format is supported

## Logs & Debugging

### View FastAPI logs

Terminal 1 will show detailed logs of model inference

### View Express logs

Terminal 2 will show API requests from frontend

### View Frontend logs

Check browser console (F12 → Console tab)

## API Integration Flow

```
User uploads audio in browser
        ↓
React frontend sends to Express API
        ↓
Express forwards to FastAPI
        ↓
FastAPI runs 4 ML models:
  - Whisper (Speech-to-Text)
  - RoBERTa (Issue Classification)
  - DistilBERT (Urgency Classification)
  - BART (Summarization)
        ↓
Results returned to Express
        ↓
Express returns to React
        ↓
React displays results in browser
```

## File Locations

```
d:\Akka\act-cs-autism-support\
├── ai-service/              # FastAPI backend
│   ├── main.py             # Main application
│   ├── .env                # Configuration
│   └── .venv/              # Python virtual environment
├── server/                  # Express middleware
│   ├── index.js            # Express server
│   └── package.json        # Dependencies
├── client/                  # React frontend
│   ├── src/
│   │   ├── App.js
│   │   └── components/
│   └── package.json        # Dependencies
└── models/                  # Pre-trained ML models
```

## Development Mode

### Hot Reload

- **Frontend:** React automatically reloads on file changes
- **Backend:** Uvicorn with `--reload` flag (not enabled in startup command)
- **Express:** Install nodemon for auto-reload

```bash
# In server/ folder
npm install --save-dev nodemon
# Then use: nodemon index.js
```

## Production Deployment

### Build Frontend

```bash
cd client
npm run build
```

Creates optimized `build/` folder ready for deployment.

### Deploy to Azure/Cloud

See deployment guide in [DEPLOYMENT.md](./DEPLOYMENT.md) (coming soon)

## Support

For issues or questions:

1. Check browser console (F12)
2. Check terminal logs for errors
3. Verify all services are running
4. Ensure ports 3000, 5000, 8000 are free

---

**Version:** 1.0.0  
**Last Updated:** January 7, 2026
