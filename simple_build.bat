@echo off
echo ====================================
echo Простая сборка (если Flutter установлен)
echo ====================================
echo.

REM Проверка Flutter
where flutter >nul 2>&1
if errorlevel 1 (
    echo Flutter не найден в PATH
    echo Запустите install_and_build.ps1 для автоматической установки
    pause
    exit /b 1
)

echo Flutter найден!
echo.

echo Установка зависимостей...
call flutter pub get
if errorlevel 1 (
    echo ОШИБКА: Не удалось установить зависимости
    pause
    exit /b 1
)

echo.
echo Сборка APK...
call flutter build apk --release
if errorlevel 1 (
    echo ОШИБКА: Не удалось собрать APK
    pause
    exit /b 1
)

echo.
echo Сборка AAB...
call flutter build appbundle --release
if errorlevel 1 (
    echo ОШИБКА: Не удалось собрать AAB
    pause
    exit /b 1
)

echo.
echo ====================================
echo СБОРКА ЗАВЕРШЕНА!
echo ====================================
echo.
echo APK: build\app\outputs\flutter-apk\app-release.apk
echo AAB: build\app\outputs\bundle\release\app-release.aab
echo.
pause
