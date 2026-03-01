@echo off
echo ================================================
2: echo   AUTISMCARE UNIFIED SETUP SCRIPT
3: echo ================================================
4: echo.
5: 
6: REM Install Node dependencies
7: echo [1/3] Installing Server dependencies...
8: cd server && npm install && cd ..
9: 
10: echo [2/3] Installing Client dependencies...
11: cd client && npm install && cd ..
12: 
13: echo [3/3] Setting up AI Service (Python)...
14: cd ai-service
15: if not exist .venv (
16:     echo Creating virtual environment...
17:     python -m venv .venv
18: )
19: echo Installing Python requirements...
20: .\.venv\Scripts\python.exe -m pip install -r requirements.txt
21: cd ..
22: 
23: echo.
24: echo ================================================
25: echo   SETUP COMPLETE! 
26: echo   To start the project, run: START_ALL.bat
27: echo ================================================
28: pause
