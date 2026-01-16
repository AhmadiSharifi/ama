@echo off
chcp 65001 >nul
echo ====================================
echo Загрузка проекта на GitHub
echo ====================================
echo.

REM Проверка Git
set GIT_PATH=C:\Program Files\Git\bin\git.exe
if not exist "%GIT_PATH%" (
    set GIT_PATH=git.exe
    git --version >nul 2>&1
    if errorlevel 1 (
        echo ОШИБКА: Git не установлен!
        echo.
        echo Установите Git: https://git-scm.com/download/win
        pause
        exit /b 1
    )
)

echo Git найден!
echo.

REM Инициализация репозитория
if not exist ".git" (
    echo Инициализация Git репозитория...
    "%GIT_PATH%" init
    echo Готово!
    echo.
)

REM Настройка Git (если нужно)
"%GIT_PATH%" config user.email "amadeus@example.com" >nul 2>&1
"%GIT_PATH%" config user.name "Amadeus App" >nul 2>&1

REM Добавление файлов
echo Добавление файлов...
"%GIT_PATH%" add .
echo Готово!
echo.

REM Коммит
echo Создание коммита...
"%GIT_PATH%" commit -m "Initial commit: Amadeus mobile app" >nul 2>&1
if errorlevel 1 (
    echo Коммит уже создан или нет изменений
) else (
    echo Коммит создан!
)
echo.

echo ====================================
echo ВАЖНО: Сначала создайте репозиторий на GitHub!
echo ====================================
echo.
echo 1. Зайдите на https://github.com
echo 2. Создайте новый репозиторий (без README)
echo 3. Скопируйте URL репозитория
echo.

set /p REPO_URL="Вставьте URL репозитория: "

if "%REPO_URL%"=="" (
    echo Ошибка: URL не введен
    pause
    exit /b 1
)

echo.
echo Добавление remote...
"%GIT_PATH%" remote remove origin >nul 2>&1
"%GIT_PATH%" remote add origin %REPO_URL%
if errorlevel 1 (
    echo Ошибка добавления remote
    pause
    exit /b 1
)

echo Remote добавлен: %REPO_URL%
echo.

echo Переименование ветки в main...
"%GIT_PATH%" branch -M main

echo.
echo Отправка на GitHub...
echo (Может потребоваться ввод логина и пароля)
echo.
"%GIT_PATH%" push -u origin main

if errorlevel 1 (
    echo.
    echo ====================================
    echo ОШИБКА при загрузке
    echo ====================================
    echo.
    echo Возможные причины:
    echo - Репозиторий не создан на GitHub
    echo - Неправильный URL
    echo - Нет прав доступа
    echo - Нужна аутентификация
    echo.
    echo Попробуйте выполнить вручную:
    echo   git push -u origin main
) else (
    echo.
    echo ====================================
    echo УСПЕШНО ЗАГРУЖЕНО НА GITHUB!
    echo ====================================
    echo.
    echo Теперь подключите к Codemagic:
    echo 1. Зайдите на https://codemagic.io
    echo 2. Sign up (через GitHub)
    echo 3. Add application
    echo 4. Выберите ваш репозиторий
    echo 5. Start build
    echo 6. Через 10-15 минут получите .ipa файл
)

echo.
pause
