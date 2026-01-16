# Быстрый старт - Сборка APK и AAB

## Шаг 1: Установите Flutter

1. Скачайте Flutter: https://flutter.dev/docs/get-started/install/windows
2. Распакуйте в папку (например, `C:\flutter`)
3. Добавьте Flutter в PATH:
   - Откройте "Переменные среды"
   - Добавьте `C:\flutter\bin` в PATH
4. Перезапустите терминал

## Шаг 2: Проверьте установку

```bash
flutter doctor
```

Убедитесь, что Flutter установлен правильно.

## Шаг 3: Установите зависимости

В папке проекта выполните:

```bash
flutter pub get
```

## Шаг 4: Соберите APK

```bash
flutter build apk --release
```

APK файл будет в: `build/app/outputs/flutter-apk/app-release.apk`

## Шаг 5: Соберите AAB (для Google Play)

```bash
flutter build appbundle --release
```

AAB файл будет в: `build/app/outputs/bundle/release/app-release.aab`

## Готово! 

Теперь у вас есть:
- ✅ APK файл для установки на Android
- ✅ AAB файл для загрузки в Google Play

## Для iOS

Если у вас есть Mac с Xcode:

```bash
flutter build ios --release
```

Затем откройте `ios/Runner.xcworkspace` в Xcode и заархивируйте для App Store.

## Примечания

- Первая сборка может занять несколько минут (скачивание зависимостей)
- Убедитесь, что у вас есть интернет для первой сборки
- Размер APK/AAB будет около 15-20 MB
