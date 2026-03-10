@echo off
REM Autism Support Application - Multi-Service Startup Script
REM This batch file starts all three services in separate terminal windows

echo.
echo ================================================
echo   AUTISM SUPPORT APPLICATION STARTUP
echo ================================================
echo.
echo Starting 3 services:
echo   1. FastAPI Backend (Port 8000)
echo   2. Node Backend (Port 5000)
echo   3. React Frontend (Port 3000)
echo.
echo Each will open in a separate window...
echo.

REM Change to project root
cd /d "%~dp0"

REM Start FastAPI Backend
echo Starting FastAPI Backend...
start "FastAPI Backend (8000)" cmd /k ^
    cd ai-service && ^
    .\.venv\Scripts\python.exe -m uvicorn main:app --port 8000

REM Wait a moment before starting backend
timeout /t 3 /nobreak

REM Start Node Backend
echo Starting Node Backend...
start "Node Backend (5000)" cmd /k ^
    cd backend && ^
    npm start

REM Wait a moment before starting React
timeout /t 3 /nobreak

REM Start React Frontend
echo Starting React Frontend...
start "React Frontend (3000)" cmd /k ^
    cd frontend && ^
    npm start

echo.
echo ================================================
echo   All services are starting...
echo.
echo FastAPI:  http://localhost:8000
echo Backend:  http://localhost:5000
echo Frontend: http://localhost:3000
echo.
echo Swagger API Docs: http://localhost:8000/docs
echo.
echo The frontend should open automatically in your browser!
echo ================================================
echo.

timeout /t 15 /nobreak
