@echo off
echo ================================================
echo   AUTISMCARE UNIFIED SETUP SCRIPT
echo ================================================
echo.

REM Install Node dependencies
echo [1/3] Installing Backend dependencies...
cd backend && npm install && cd ..

echo [2/3] Installing Frontend dependencies...
cd frontend && npm install && cd ..

echo [3/3] Setting up AI Service (Python)...
cd ai-service
if not exist .venv (
    echo Creating virtual environment...
    python -m venv .venv
)
echo Installing Python requirements...
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
cd ..

echo.
echo ================================================
echo   SETUP COMPLETE!
echo   To start the project, run: START_ALL.bat
echo ================================================
pause
