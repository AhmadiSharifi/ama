# Инструкции по сборке APK и AAB

## Предварительные требования

1. Установите Flutter: https://flutter.dev/docs/get-started/install
2. Проверьте установку:
```bash
flutter doctor
```

## Сборка APK файла

1. Откройте терминал в папке проекта
2. Выполните команду:
```bash
flutter build apk --release
```

3. APK файл будет создан в:
   `build/app/outputs/flutter-apk/app-release.apk`

## Сборка AAB файла (для Google Play)

1. Выполните команду:
```bash
flutter build appbundle --release
```

2. AAB файл будет создан в:
   `build/app/outputs/bundle/release/app-release.aab`

## Подпись приложения (опционально)

По умолчанию Flutter подписывает приложение debug ключом. Для релиза в Google Play нужно создать release ключ:

1. Создайте keystore:
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Создайте файл `android/key.properties`:
```
storePassword=ваш_пароль
keyPassword=ваш_пароль
keyAlias=upload
storeFile=путь/к/upload-keystore.jks
```

3. Обновите `android/app/build.gradle` для использования этого ключа (см. документацию Flutter)

## Установка APK на устройство

```bash
flutter install
```

Или вручную:
```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

## Размер файлов

- APK: ~15-20 MB
- AAB: ~15-20 MB (оптимизирован для Google Play)

## Решение проблем

### Ошибка: "Flutter not found"
- Убедитесь, что Flutter установлен и добавлен в PATH
- Перезапустите терминал

### Ошибка компиляции
- Выполните `flutter clean`
- Выполните `flutter pub get`
- Попробуйте снова

### Ошибка подписи
- Убедитесь, что `key.properties` настроен правильно
- Проверьте пути к keystore файлу
