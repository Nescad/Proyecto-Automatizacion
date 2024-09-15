@echo off

:: Definir la variable de entorno con la ruta del usuario
set carpeta_usuario=%USERPROFILE%

:: Mensaje para confirmar la ruta
echo Carpeta de usuario: %carpeta_usuario%

:: Crear el entorno virtual si aún no existe
if not exist venv (
    echo Creando ambiente virtual...
    python -m venv venv
)

:: Activar el entorno virtual
echo Activando ambiente virtual...
call .\venv\Scripts\activate

:: Verificar si pip está instalado
echo Verificando si pip está instalado...
python -m pip --version >nul 2>&1
if errorlevel 1 (
    echo Pip no encontrado. Instalando pip...
    :: Descargar e instalar pip
    powershell -Command "Invoke-WebRequest -Uri https://bootstrap.pypa.io/get-pip.py -OutFile get-pip.py"
    python get-pip.py
) else (
    echo Pip ya esta instalado.
)

:: Instalar dependencias desde el directorio actual
echo Instalando dependencias...
python.exe -m pip install --upgrade pip
pip install -r requirements.txt

:: Mantener la ventana abierta
pause
