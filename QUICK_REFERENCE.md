# 🚀 QUICK REFERENCE - START YOUR APP IN 30 SECONDS

## ONE-CLICK STARTUP (Easiest)

```
Double-click: START_ALL.bat
```

That's it! Everything starts automatically.

---

## MANUAL STARTUP (3 Terminal Windows)

### Window 1 - FastAPI Backend

```bash
cd ai-service
.\.venv\Scripts\python.exe -m uvicorn main:app --port 8000
```

**Wait for:** `Application startup complete`

### Window 2 - Express Server

```bash
cd server
npm start
```

**Wait for:** `Server running on port 5000`

### Window 3 - React Frontend

```bash
cd client
npm start
```

**Wait for:** Browser opens to `http://localhost:3000`

---

## ✅ VERIFY ALL RUNNING

- FastAPI: http://localhost:8000 ✓
- Express: http://localhost:5000 ✓
- Frontend: http://localhost:3000 ✓

---

## 📱 HOW TO USE

1. **Open browser:** http://localhost:3000
2. **Record/Upload audio:**
   - 🎙️ Click "Start Recording" → Speak into mic
   - OR 📁 Click "Upload Audio File" → Select file
3. **Analyze:** Click "📤 Analyze Audio"
4. **Wait:** 30-60 seconds
5. **View Results:** Transcript, issue, urgency, summary

---

## 🛠️ TROUBLESHOOTING

### "Port already in use"

```powershell
netstat -ano | findstr ":8000"  # Find process
taskkill /PID <PID> /F           # Kill it
```

### "Connection refused"

- Check all 3 services are running
- Check ports 3000, 5000, 8000 are free
- Wait a few seconds for services to start

### "Empty transcript"

- Audio may have no recognizable speech
- Try with clearer audio
- Check microphone is not muted

---

## 📚 DOCUMENTATION

| File                 | Purpose                |
| -------------------- | ---------------------- |
| README.md            | Complete documentation |
| QUICK_START.md       | 5-minute setup guide   |
| FRONTEND_COMPLETE.md | Frontend details       |
| BUILD_COMPLETE.txt   | This session summary   |

---

## 🎯 ARCHITECTURE

```
Browser (Port 3000)
    ↓
React App
    ↓ (axios POST)
Express Server (Port 5000)
    ↓ (forward)
FastAPI (Port 8000)
    ↓ (4 ML models)
Whisper + RoBERTa + DistilBERT + BART
    ↓
Results
```

---

## 📊 FEATURES AT A GLANCE

✓ Audio Recording with timer
✓ File Upload (MP3, WAV, etc.)
✓ Speech-to-Text (Whisper)
✓ Issue Classification (13 categories)
✓ Urgency Assessment (Low/Medium/High)
✓ AI Summarization
✓ Smart Recommendations
✓ Beautiful UI (Responsive)
✓ Professional Styling

---

## 🧠 DETECTED ISSUES

Aggression • Anxiety/Meltdown • Daily Progress • Feeding •
Health • Social Regression • Speech Regression • Repetitive •
Routine Change • School • Self-Injury • Sensory Overload • Sleep

---

## 💡 TIPS

- First run loads models (may take 1-2 min)
- Subsequent runs are faster (30-60 sec)
- Clear audio = better results
- Check browser console (F12) for errors
- All 3 services must be running

---

## 🎉 READY TO GO!

Your autism support application is complete and ready to use.

**Start it:** `START_ALL.bat`  
**Access it:** `http://localhost:3000`  
**API Docs:** `http://localhost:8000/docs`

Good luck! 🚀
