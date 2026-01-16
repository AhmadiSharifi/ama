@echo off
echo Проверка готовности файлов...
echo.

if exist "build\app\outputs\flutter-apk\app-release.apk" (
    echo [OK] APK готов
) else (
    echo [ОЖИДАНИЕ] APK еще собирается
)

if exist "build\app\outputs\bundle\release\app-release.aab" (
    echo [OK] AAB готов
) else (
    echo [ОЖИДАНИЕ] AAB еще собирается
)

echo.
pause
