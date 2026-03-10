@echo off
start "frontend" cmd /k "cd /d ""%~dp0frontend"" && npm run dev"
call "%~dp0backend\scripts\START_SERVICES.bat"
