# Финальный скрипт сборки - проверяет Flutter и собирает файлы

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Проверка и сборка Amadeus App" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$flutterFound = $false
$flutterPath = ""

# Проверка 1: Flutter в PATH
$flutterInPath = Get-Command flutter -ErrorAction SilentlyContinue
if ($flutterInPath) {
    Write-Host "✓ Flutter найден в PATH" -ForegroundColor Green
    $flutterFound = $true
    $flutterPath = "flutter"
}

# Проверка 2: Flutter в папке проекта
if (-not $flutterFound) {
    $localFlutter = "$PWD\flutter\bin\flutter.bat"
    if (Test-Path $localFlutter) {
        Write-Host "✓ Flutter найден в папке проекта" -ForegroundColor Green
        $flutterFound = $true
        $flutterPath = "$PWD\flutter\bin\flutter.bat"
    }
}

# Проверка 3: Flutter в домашней папке
if (-not $flutterFound) {
    $homeFlutter = "$env:USERPROFILE\flutter\bin\flutter.bat"
    if (Test-Path $homeFlutter) {
        Write-Host "✓ Flutter найден в домашней папке" -ForegroundColor Green
        $flutterFound = $true
        $flutterPath = $homeFlutter
    }
}

if (-not $flutterFound) {
    Write-Host "✗ Flutter не найден!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Варианты решения:" -ForegroundColor Yellow
    Write-Host "1. Запустите install_and_build.ps1 для автоматической установки" -ForegroundColor White
    Write-Host "2. Установите Flutter вручную: https://docs.flutter.dev/get-started/install/windows" -ForegroundColor White
    Write-Host "3. Подождите, если установка еще идет (проверьте папку $env:USERPROFILE\flutter)" -ForegroundColor White
    Read-Host "Нажмите Enter для выхода"
    exit 1
}

# Установка зависимостей
Write-Host ""
Write-Host "Установка зависимостей..." -ForegroundColor Cyan
if ($flutterPath -eq "flutter") {
    & flutter pub get
} else {
    & $flutterPath pub get
}

if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Ошибка установки зависимостей" -ForegroundColor Red
    Read-Host "Нажмите Enter для выхода"
    exit 1
}

# Сборка APK
Write-Host ""
Write-Host "Сборка APK..." -ForegroundColor Cyan
if ($flutterPath -eq "flutter") {
    & flutter build apk --release
} else {
    & $flutterPath build apk --release
}

if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Ошибка сборки APK" -ForegroundColor Red
    Read-Host "Нажмите Enter для выхода"
    exit 1
}

# Сборка AAB
Write-Host ""
Write-Host "Сборка AAB..." -ForegroundColor Cyan
if ($flutterPath -eq "flutter") {
    & flutter build appbundle --release
} else {
    & $flutterPath build appbundle --release
}

if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Ошибка сборки AAB" -ForegroundColor Red
    Read-Host "Нажмите Enter для выхода"
    exit 1
}

# Успех!
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "✓ СБОРКА ЗАВЕРШЕНА УСПЕШНО!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "APK файл:" -ForegroundColor Yellow
Write-Host "  $PWD\build\app\outputs\flutter-apk\app-release.apk" -ForegroundColor White
Write-Host ""
Write-Host "AAB файл:" -ForegroundColor Yellow
Write-Host "  $PWD\build\app\outputs\bundle\release\app-release.aab" -ForegroundColor White
Write-Host ""

# Проверка существования файлов
$apkPath = "$PWD\build\app\outputs\flutter-apk\app-release.apk"
$aabPath = "$PWD\build\app\outputs\bundle\release\app-release.aab"

if (Test-Path $apkPath) {
    $apkSize = (Get-Item $apkPath).Length / 1MB
    Write-Host "✓ APK создан ($([math]::Round($apkSize, 2)) MB)" -ForegroundColor Green
} else {
    Write-Host "✗ APK не найден" -ForegroundColor Red
}

if (Test-Path $aabPath) {
    $aabSize = (Get-Item $aabPath).Length / 1MB
    Write-Host "✓ AAB создан ($([math]::Round($aabSize, 2)) MB)" -ForegroundColor Green
} else {
    Write-Host "✗ AAB не найден" -ForegroundColor Red
}

Write-Host ""
Read-Host "Нажмите Enter для выхода"
