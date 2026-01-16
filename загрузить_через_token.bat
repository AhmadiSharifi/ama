@echo off
chcp 65001 >nul
echo ====================================
echo Загрузка на GitHub через Token
echo ====================================
echo.

set GIT_PATH=C:\Program Files\Git\bin\git.exe

echo ВАЖНО: Сначала создайте Personal Access Token
echo.
echo 1. Зайдите на https://github.com/settings/tokens
echo 2. Generate new token (classic)
echo 3. Отметьте "repo"
echo 4. Generate и скопируйте токен
echo.

set /p TOKEN="Вставьте ваш Personal Access Token: "

if "%TOKEN%"=="" (
    echo Ошибка: Token не введен
    pause
    exit /b 1
)

echo.
echo Отправка на GitHub...
"%GIT_PATH%" push https://%TOKEN%@github.com/AhmadiSharifi/ama.git main

if errorlevel 1 (
    echo.
    echo ОШИБКА при загрузке
    echo Проверьте правильность токена
) else (
    echo.
    echo ====================================
    echo УСПЕШНО ЗАГРУЖЕНО НА GITHUB!
    echo ====================================
    echo.
    echo Репозиторий: https://github.com/AhmadiSharifi/ama
    echo.
    echo Теперь подключите к Codemagic для iOS:
    echo 1. https://codemagic.io
    echo 2. Sign up через GitHub
    echo 3. Add application
    echo 4. Выберите репозиторий ama
    echo 5. Start build
)

pause
