# Автоматическая сборка iOS приложения

## Быстрый способ (Codemagic)

1. Зарегистрируйтесь на https://codemagic.io (бесплатно, через GitHub)
2. Нажмите "Add application"
3. Загрузите ZIP файл папки AMADEUS или подключите GitHub
4. Codemagic автоматически найдет `codemagic.yaml`
5. Нажмите "Start new build"
6. Через 10-15 минут получите .ipa файл

## Что уже настроено

- ✅ `codemagic.yaml` - конфигурация для Codemagic
- ✅ `.github/workflows/ios_build.yml` - для GitHub Actions
- ✅ iOS проект полностью готов

## Бесплатный план Codemagic

- 500 минут сборки в месяц
- Достаточно для нескольких сборок

## Результат

После сборки вы получите файл `.ipa`, который можно:
- Установить на iPhone через TestFlight
- Загрузить в App Store Connect
- Распространять через Ad-Hoc
