@echo off
echo ================================================
echo   FINAL PRODUCT SETUP
echo ================================================
echo.

echo [1/5] Installing frontend dependencies...
cd /d "%~dp0frontend"
call npm install

echo [2/5] Installing gateway dependencies...
cd /d "%~dp0backend\gateway"
call npm install

echo [3/5] Installing emotional activity recommender dependencies...
cd /d "%~dp0backend\services\emotional-activity-recommender"
call npm install

echo [4/5] Installing therapy-collab dependencies...
cd /d "%~dp0backend\services\therapy-collab"
call npm install

echo [5/5] Setting up therapy-collab AI environment...
cd /d "%~dp0backend\services\therapy-collab-ai"
if not exist .venv (
    python -m venv .venv
)
.\.venv\Scripts\python.exe -m pip install -r requirements.txt

cd /d "%~dp0"
echo.
echo Setup complete.
echo Remaining Python services are initialized automatically by backend\scripts\START_SERVICES.bat on first run.
echo.
pause
