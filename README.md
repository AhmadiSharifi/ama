# Amadeus Mobile App

Кроссплатформенное мобильное приложение для сайта ama-deus.com на Flutter.

## Возможности

- ✅ WebView для отображения сайта
- ✅ Нативное меню с кнопками (Главная, Обновить, Поделиться, Открыть в браузере)
- ✅ Обработка внешних ссылок
- ✅ Индикатор загрузки
- ✅ Обработка ошибок
- ✅ Поддержка Android и iOS

## Требования

- Flutter SDK 3.0.0 или выше
- Android Studio / Xcode (для iOS)
- Android SDK 24+ / iOS 12+

## Установка

1. Установите Flutter: https://flutter.dev/docs/get-started/install

2. Установите зависимости:
```bash
flutter pub get
```

3. Для Android - убедитесь, что Android SDK установлен
4. Для iOS - убедитесь, что Xcode установлен (только на macOS)

## Сборка

### Android APK
```bash
flutter build apk --release
```
APK файл будет в: `build/app/outputs/flutter-apk/app-release.apk`

### Android AAB (для Google Play)
```bash
flutter build appbundle --release
```
AAB файл будет в: `build/app/outputs/bundle/release/app-release.aab`

### iOS
```bash
flutter build ios --release
```

## Настройка URL

Чтобы изменить URL сайта, откройте `lib/main.dart` и измените:
```dart
final String _websiteUrl = 'https://ama-deus.com';
```

## Публикация

### Google Play
1. Создайте аккаунт разработчика
2. Соберите AAB: `flutter build appbundle --release`
3. Загрузите в Google Play Console
4. Заполните информацию о приложении
5. Создайте Privacy Policy страницу

### App Store
1. Создайте аккаунт разработчика Apple
2. Соберите iOS: `flutter build ios --release`
3. Откройте в Xcode и заархивируйте
4. Загрузите через App Store Connect

## Структура проекта

```
amadeus_app/
├── lib/
│   └── main.dart          # Главный файл приложения
├── android/                # Android конфигурация
├── ios/                    # iOS конфигурация
└── pubspec.yaml           # Зависимости Flutter
```

## Функции меню

- **Главная** - возврат на главную страницу сайта
- **Обновить** - перезагрузка текущей страницы
- **Поделиться** - поделиться ссылкой на сайт
- **Открыть в браузере** - открыть текущую страницу в системном браузере
