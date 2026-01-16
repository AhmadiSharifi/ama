# Скрипт автоматической установки Flutter и сборки приложения

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Установка Flutter и сборка приложения" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Путь для установки Flutter
$flutterPath = "$env:USERPROFILE\flutter"
$flutterBin = "$flutterPath\bin"

# Проверка, установлен ли Flutter
if (Test-Path "$flutterBin\flutter.bat") {
    Write-Host "Flutter уже установлен в $flutterPath" -ForegroundColor Green
    $env:Path += ";$flutterBin"
}
else {
    Write-Host "Flutter не найден. Скачивание Flutter..." -ForegroundColor Yellow
    
    # Создаем папку для Flutter
    if (-not (Test-Path $flutterPath)) {
        New-Item -ItemType Directory -Path $flutterPath -Force | Out-Null
    }
    
    # URL для скачивания Flutter
    $flutterUrl = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.16.9-stable.zip"
    $zipPath = "$env:TEMP\flutter.zip"
    
    Write-Host "Скачивание Flutter (это может занять несколько минут)..." -ForegroundColor Yellow
    
    $downloadSuccess = $false
    try {
        Invoke-WebRequest -Uri $flutterUrl -OutFile $zipPath -UseBasicParsing -ErrorAction Stop
        Write-Host "Распаковка Flutter..." -ForegroundColor Yellow
        Expand-Archive -Path $zipPath -DestinationPath $env:USERPROFILE -Force -ErrorAction Stop
        Remove-Item $zipPath -Force
        Write-Host "Flutter установлен!" -ForegroundColor Green
        $env:Path += ";$flutterBin"
        $downloadSuccess = $true
    }
    catch {
        Write-Host "ОШИБКА: Не удалось скачать Flutter автоматически." -ForegroundColor Red
        Write-Host "Пожалуйста, установите Flutter вручную:" -ForegroundColor Yellow
        Write-Host "1. Скачайте: https://docs.flutter.dev/get-started/install/windows" -ForegroundColor Yellow
        Write-Host "2. Распакуйте в $flutterPath" -ForegroundColor Yellow
        Write-Host "3. Добавьте $flutterBin в PATH" -ForegroundColor Yellow
        Write-Host "4. Запустите этот скрипт снова" -ForegroundColor Yellow
    }
    
    if (-not $downloadSuccess) {
        Read-Host "Нажмите Enter для выхода"
        exit 1
    }
}

# Проверка Flutter
Write-Host ""
Write-Host "Проверка Flutter..." -ForegroundColor Cyan
& "$flutterBin\flutter.bat" --version
if ($LASTEXITCODE -ne 0) {
    Write-Host "ОШИБКА: Flutter не работает правильно" -ForegroundColor Red
    Read-Host "Нажмите Enter для выхода"
    exit 1
}

# Переход в папку проекта
$projectPath = $PSScriptRoot
Set-Location $projectPath

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Установка зависимостей" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
& "$flutterBin\flutter.bat" pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "ОШИБКА: Не удалось установить зависимости" -ForegroundColor Red
    Read-Host "Нажмите Enter для выхода"
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Сборка APK..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
& "$flutterBin\flutter.bat" build apk --release
if ($LASTEXITCODE -ne 0) {
    Write-Host "ОШИБКА: Не удалось собрать APK" -ForegroundColor Red
    Read-Host "Нажмите Enter для выхода"
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Сборка AAB..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
& "$flutterBin\flutter.bat" build appbundle --release
if ($LASTEXITCODE -ne 0) {
    Write-Host "ОШИБКА: Не удалось собрать AAB" -ForegroundColor Red
    Read-Host "Нажмите Enter для выхода"
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "СБОРКА ЗАВЕРШЕНА УСПЕШНО!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "APK файл:" -ForegroundColor Yellow
Write-Host "  $projectPath\build\app\outputs\flutter-apk\app-release.apk" -ForegroundColor White
Write-Host ""
Write-Host "AAB файл:" -ForegroundColor Yellow
Write-Host "  $projectPath\build\app\outputs\bundle\release\app-release.aab" -ForegroundColor White
Write-Host ""
Read-Host "Нажмите Enter для выхода"
