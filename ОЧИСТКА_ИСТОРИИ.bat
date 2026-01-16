@echo off
chcp 65001 >nul
echo ====================================
echo ОЧИСТКА ИСТОРИИ GIT ОТ БОЛЬШИХ ФАЙЛОВ
echo ====================================
echo.
echo ВАЖНО: Это создаст НОВЫЙ репозиторий без истории
echo        но с текущими файлами (только нужные)
echo.

set GIT_PATH=C:\Program Files\Git\bin\git.exe

echo Шаг 1: Удаление старого .git...
if exist .git (
    rd /s /q .git
    echo Готово!
) else (
    echo .git не найден
)

echo.
echo Шаг 2: Инициализация нового репозитория...
"%GIT_PATH%" init
"%GIT_PATH%" config user.email "amadeus@example.com"
"%GIT_PATH%" config user.name "Amadeus App"

echo.
echo Шаг 3: Добавление только нужных файлов...
"%GIT_PATH%" add .

echo.
echo Шаг 4: Создание первого коммита...
"%GIT_PATH%" commit -m "Initial commit: Amadeus mobile app"

echo.
echo Шаг 5: Настройка remote...
"%GIT_PATH%" remote add origin https://github.com/AhmadiSharifi/ama.git
"%GIT_PATH%" branch -M main

echo.
echo ====================================
echo ГОТОВО!
echo ====================================
echo.
echo Теперь в GitHub Desktop:
echo 1. File → Add Local Repository
echo 2. Выберите: C:\Users\Admin\Desktop\AMADEUS
echo 3. Нажмите "Publish repository"
echo.
echo ИЛИ выполните:
echo   git push -u origin main --force
echo.
pause
