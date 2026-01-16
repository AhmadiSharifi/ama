#!/bin/bash

echo "===================================="
echo "Building Amadeus App"
echo "===================================="
echo ""

echo "Checking Flutter installation..."
if ! command -v flutter &> /dev/null; then
    echo "ERROR: Flutter is not installed or not in PATH"
    echo "Please install Flutter from https://flutter.dev"
    exit 1
fi

echo "Flutter found!"
echo ""

echo "Installing dependencies..."
flutter pub get
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to install dependencies"
    exit 1
fi

echo ""
echo "===================================="
echo "Building APK..."
echo "===================================="
flutter build apk --release
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to build APK"
    exit 1
fi

echo ""
echo "===================================="
echo "Building AAB..."
echo "===================================="
flutter build appbundle --release
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to build AAB"
    exit 1
fi

echo ""
echo "===================================="
echo "Build completed successfully!"
echo "===================================="
echo ""
echo "APK file: build/app/outputs/flutter-apk/app-release.apk"
echo "AAB file: build/app/outputs/bundle/release/app-release.aab"
echo ""
