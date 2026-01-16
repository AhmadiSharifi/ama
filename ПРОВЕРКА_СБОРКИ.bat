@echo off
echo ====================================
echo Проверка статуса сборки
echo ====================================
echo.

if exist "build\app\outputs\flutter-apk\app-release.apk" (
    echo [OK] APK файл найден
    for %%F in ("build\app\outputs\flutter-apk\app-release.apk") do echo     Дата: %%~tF
) else (
    echo [ОЖИДАНИЕ] APK файл еще не создан
)

echo.

if exist "build\app\outputs\bundle\release\app-release.aab" (
    echo [OK] AAB файл найден
    for %%F in ("build\app\outputs\bundle\release\app-release.aab") do echo     Дата: %%~tF
) else (
    echo [ОЖИДАНИЕ] AAB файл еще не создан
)

echo.
echo ====================================
pause
