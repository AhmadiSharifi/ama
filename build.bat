@echo off
echo ====================================
echo Building Amadeus App
echo ====================================
echo.

echo Checking Flutter installation...
flutter --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Flutter is not installed or not in PATH
    echo Please install Flutter from https://flutter.dev
    echo.
    pause
    exit /b 1
)

echo Flutter found!
echo.

echo Installing dependencies...
call flutter pub get
if errorlevel 1 (
    echo ERROR: Failed to install dependencies
    pause
    exit /b 1
)

echo.
echo ====================================
echo Building APK...
echo ====================================
call flutter build apk --release
if errorlevel 1 (
    echo ERROR: Failed to build APK
    pause
    exit /b 1
)

echo.
echo ====================================
echo Building AAB...
echo ====================================
call flutter build appbundle --release
if errorlevel 1 (
    echo ERROR: Failed to build AAB
    pause
    exit /b 1
)

echo.
echo ====================================
echo Build completed successfully!
echo ====================================
echo.
echo APK file: build\app\outputs\flutter-apk\app-release.apk
echo AAB file: build\app\outputs\bundle\release\app-release.aab
echo.
pause
