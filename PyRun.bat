@echo off
echo Activando el entorno virtual...
call .\venv\Scripts\activate

echo Ejecutando el script Python...
python %~dp0\source\main.py

pause
