@echo off
REM Run all backend services (backend\services\*)
REM Script lives at backend\scripts\ -> repo root is ..\..

set "SCRIPT_DIR=%~dp0"
set "REPO_ROOT=%SCRIPT_DIR%..\.."
set "SERVICES=%REPO_ROOT%\backend\services"
set "GATEWAY=%REPO_ROOT%\backend\gateway"

echo.
echo ================================================
echo   BACKEND SERVICES STARTUP
echo ================================================
echo   Repo root: %REPO_ROOT%
echo   Services:  %SERVICES%
echo.
echo   Starting:
echo     1. autism-profile-builder            (Flask, port 7001)
echo     2. cognitive-activity-recommender    (FastAPI, port 7002)
echo     3. emotional-activity-recommender    (Node, port 7003)
echo     4. emotional-activity-recommender-ml (FastAPI, port 7004)
echo     5. therapy-collab-ai                 (FastAPI, port 7005)
echo     6. therapy-collab                    (Node, port 7006)
echo     7. gateway                           (Express, port 7777)
echo.

REM 1. Autism Profile Builder (Flask)
if exist "%SERVICES%\autism-profile-builder" (
  if not exist "%SERVICES%\autism-profile-builder\.venv\Scripts\python.exe" (
    echo   Creating venv in autism-profile-builder...
    cd /d "%SERVICES%\autism-profile-builder"
    python -m venv .venv
    cd /d "%SCRIPT_DIR%"
  )
  echo   Installing/updating Python requirements in autism-profile-builder...
  if exist "%SERVICES%\autism-profile-builder\.venv\Scripts\pip.exe" (
    "%SERVICES%\autism-profile-builder\.venv\Scripts\pip.exe" install -r "%SERVICES%\autism-profile-builder\requirements.txt"
  ) else (
    cd /d "%SERVICES%\autism-profile-builder"
    pip install -r requirements.txt
    cd /d "%SCRIPT_DIR%"
  )
  if errorlevel 1 echo   WARNING: pip install failed for autism-profile-builder
  echo Starting autism-profile-builder...
  if exist "%SERVICES%\autism-profile-builder\.venv\Scripts\python.exe" (
    start "autism-profile-builder (7001)" cmd /k "cd /d "%SERVICES%\autism-profile-builder" && set PORT=7001 && "%SERVICES%\autism-profile-builder\.venv\Scripts\python.exe" app.py"
  ) else (
    start "autism-profile-builder (7001)" cmd /k "cd /d "%SERVICES%\autism-profile-builder" && set PORT=7001 && python app.py"
  )
  timeout /t 3 /nobreak >nul
)

REM 2. Cognitive Activity Recommender (FastAPI)
if exist "%SERVICES%\cognitive-activity-recommender" (
  if not exist "%SERVICES%\cognitive-activity-recommender\.venv\Scripts\python.exe" (
    echo   Creating venv in cognitive-activity-recommender...
    cd /d "%SERVICES%\cognitive-activity-recommender"
    python -m venv .venv
    cd /d "%SCRIPT_DIR%"
  )
  echo   Installing/updating Python requirements in cognitive-activity-recommender...
  if exist "%SERVICES%\cognitive-activity-recommender\.venv\Scripts\pip.exe" (
    "%SERVICES%\cognitive-activity-recommender\.venv\Scripts\pip.exe" install -r "%SERVICES%\cognitive-activity-recommender\requirements.txt"
  ) else (
    cd /d "%SERVICES%\cognitive-activity-recommender"
    pip install -r requirements.txt
    cd /d "%SCRIPT_DIR%"
  )
  if errorlevel 1 echo   WARNING: pip install failed for cognitive-activity-recommender
  echo Starting cognitive-activity-recommender...
  if exist "%SERVICES%\cognitive-activity-recommender\.venv\Scripts\python.exe" (
    start "cognitive-activity-recommender (7002)" cmd /k "cd /d "%SERVICES%\cognitive-activity-recommender" && "%SERVICES%\cognitive-activity-recommender\.venv\Scripts\python.exe" -m uvicorn app.main:app --host 0.0.0.0 --port 7002"
  ) else (
    start "cognitive-activity-recommender (7002)" cmd /k "cd /d "%SERVICES%\cognitive-activity-recommender" && python -m uvicorn app.main:app --host 0.0.0.0 --port 7002"
  )
  timeout /t 3 /nobreak >nul
)

REM 3. Emotional Activity Recommender (Node)
if exist "%SERVICES%\emotional-activity-recommender" (
  echo   Installing/updating npm dependencies in emotional-activity-recommender...
  cd /d "%SERVICES%\emotional-activity-recommender"
  call npm install
  cd /d "%SCRIPT_DIR%"
  echo Starting emotional-activity-recommender...
  start "emotional-activity-recommender (7003)" cmd /k "cd /d "%SERVICES%\emotional-activity-recommender" && set PORT=7003 && npm start"
  timeout /t 3 /nobreak >nul
)

REM 4. Emotional Activity Recommender ML (FastAPI)
if exist "%SERVICES%\emotional-activity-recommender-ml" (
  if not exist "%SERVICES%\emotional-activity-recommender-ml\.venv\Scripts\python.exe" (
    echo   Creating venv in emotional-activity-recommender-ml...
    cd /d "%SERVICES%\emotional-activity-recommender-ml"
    python -m venv .venv
    cd /d "%SCRIPT_DIR%"
  )
  echo   Installing/updating Python requirements in emotional-activity-recommender-ml...
  if exist "%SERVICES%\emotional-activity-recommender-ml\.venv\Scripts\pip.exe" (
    "%SERVICES%\emotional-activity-recommender-ml\.venv\Scripts\pip.exe" install -r "%SERVICES%\emotional-activity-recommender-ml\requirements.txt"
  ) else (
    cd /d "%SERVICES%\emotional-activity-recommender-ml"
    pip install -r requirements.txt
    cd /d "%SCRIPT_DIR%"
  )
  if errorlevel 1 echo   WARNING: pip install failed for emotional-activity-recommender-ml
  echo Starting emotional-activity-recommender-ml...
  if exist "%SERVICES%\emotional-activity-recommender-ml\.venv\Scripts\python.exe" (
    start "emotional-activity-recommender-ml (7004)" cmd /k "cd /d "%SERVICES%\emotional-activity-recommender-ml" && "%SERVICES%\emotional-activity-recommender-ml\.venv\Scripts\python.exe" app.py"
  ) else (
    start "emotional-activity-recommender-ml (7004)" cmd /k "cd /d "%SERVICES%\emotional-activity-recommender-ml" && python app.py"
  )
  timeout /t 3 /nobreak >nul
)

REM 5. Therapy Collab AI (FastAPI)
if exist "%SERVICES%\therapy-collab-ai" (
  if not exist "%SERVICES%\therapy-collab-ai\.venv\Scripts\python.exe" (
    echo   Creating venv in therapy-collab-ai...
    cd /d "%SERVICES%\therapy-collab-ai"
    python -m venv .venv
    cd /d "%SCRIPT_DIR%"
  )
  echo   Installing/updating Python requirements in therapy-collab-ai...
  if exist "%SERVICES%\therapy-collab-ai\.venv\Scripts\pip.exe" (
    "%SERVICES%\therapy-collab-ai\.venv\Scripts\pip.exe" install -r "%SERVICES%\therapy-collab-ai\requirements.txt"
  ) else (
    cd /d "%SERVICES%\therapy-collab-ai"
    pip install -r requirements.txt
    cd /d "%SCRIPT_DIR%"
  )
  if errorlevel 1 echo   WARNING: pip install failed for therapy-collab-ai
  echo Starting therapy-collab-ai...
  if exist "%SERVICES%\therapy-collab-ai\.venv\Scripts\python.exe" (
    start "therapy-collab-ai (7005)" cmd /k "cd /d "%SERVICES%\therapy-collab-ai" && "%SERVICES%\therapy-collab-ai\.venv\Scripts\python.exe" -m uvicorn main:app --host 0.0.0.0 --port 7005"
  ) else (
    start "therapy-collab-ai (7005)" cmd /k "cd /d "%SERVICES%\therapy-collab-ai" && python -m uvicorn main:app --host 0.0.0.0 --port 7005"
  )
  timeout /t 3 /nobreak >nul
)

REM 6. Therapy Collab (Node)
if exist "%SERVICES%\therapy-collab" (
  echo   Installing/updating npm dependencies in therapy-collab...
  cd /d "%SERVICES%\therapy-collab"
  call npm install
  cd /d "%SCRIPT_DIR%"
  echo Starting therapy-collab...
  start "therapy-collab (7006)" cmd /k "cd /d "%SERVICES%\therapy-collab" && npm run dev"
  timeout /t 3 /nobreak >nul
)

REM 7. Gateway (Express, port 7777)
if exist "%GATEWAY%" (
  echo   Installing/updating npm dependencies in gateway...
  cd /d "%GATEWAY%"
  call npm install
  cd /d "%SCRIPT_DIR%"
  echo Starting gateway...
  start "gateway (7777)" cmd /k "cd /d "%GATEWAY%" && npm start"
)

echo.
echo ================================================
echo   All services are starting in separate windows.
echo   gateway:                           http://localhost:7777
echo   autism-profile-builder:            http://localhost:7001
echo   cognitive-activity-recommender:    http://localhost:7002
echo   emotional-activity-recommender:    http://localhost:7003
echo   emotional-activity-recommender-ml: http://localhost:7004
echo   therapy-collab-ai:                 http://localhost:7005
echo   therapy-collab:                    http://localhost:7006
echo ================================================
echo.

timeout /t 5 /nobreak
