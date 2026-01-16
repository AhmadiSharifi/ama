@echo off
chcp 65001 >nul
echo ====================================
echo Загрузка проекта на GitHub
echo ====================================
echo.

set GIT_PATH=C:\Program Files\Git\bin\git.exe

if not exist "%GIT_PATH%" (
    set GIT_PATH=git.exe
)

REM Проверка Git
"%GIT_PATH%" --version >nul 2>&1
if errorlevel 1 (
    echo ОШИБКА: Git не найден!
    pause
    exit /b 1
)

echo Git найден!
echo.

REM Настройка Git
"%GIT_PATH%" config user.email "amadeus@example.com" >nul 2>&1
"%GIT_PATH%" config user.name "Amadeus App" >nul 2>&1

REM Проверка репозитория
if not exist ".git" (
    echo Инициализация репозитория...
    "%GIT_PATH%" init
)

echo Добавление файлов...
"%GIT_PATH%" add .
echo Готово!
echo.

echo Создание коммита...
"%GIT_PATH%" commit -m "Amadeus mobile app" >nul 2>&1
echo Готово!
echo.

echo ====================================
echo ВАЖНО: Создайте репозиторий на GitHub
echo ====================================
echo.
echo 1. Зайдите на https://github.com
echo 2. Создайте новый репозиторий
echo 3. Скопируйте URL
echo.

set /p REPO_URL="Вставьте URL репозитория: "

if "%REPO_URL%"=="" (
    echo Ошибка: URL не введен
    pause
    exit /b 1
)

echo.
echo Настройка remote...
"%GIT_PATH%" remote remove origin >nul 2>&1
"%GIT_PATH%" remote add origin %REPO_URL%

echo.
echo Переименование ветки...
"%GIT_PATH%" branch -M main

echo.
echo ====================================
echo Отправка на GitHub...
echo ====================================
echo.
echo ВАЖНО: Может потребоваться ввод логина и пароля
echo        Или используйте Personal Access Token вместо пароля
echo.

"%GIT_PATH%" push -u origin main

if errorlevel 1 (
    echo.
    echo ====================================
    echo ОШИБКА при загрузке
    echo ====================================
    echo.
    echo Попробуйте выполнить вручную:
    echo   git push -u origin main
    echo.
    echo Или используйте GitHub Desktop:
    echo   https://desktop.github.com
    echo.
) else (
    echo.
    echo ====================================
    echo УСПЕШНО ЗАГРУЖЕНО!
    echo ====================================
    echo.
    echo Теперь подключите к Codemagic для iOS:
    echo 1. https://codemagic.io
    echo 2. Sign up через GitHub
    echo 3. Add application
    echo 4. Выберите репозиторий
    echo 5. Start build
    echo.
)

pause
