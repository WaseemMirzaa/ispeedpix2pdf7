import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String LANGUAGE_CODE = 'languageCode';
  static const String HAS_SELECTED_LANGUAGE = 'hasSelectedLanguage';

  // List of supported language codes in the app
  static const List<String> supportedLanguages = [
    'en',
    'es',
    'zh',
    'fr',
    'de',
    'pt',
    'ar',
    'hi',
    'ja',
    'ko',
    'ru',
    'it',
    'tr',
    'vi',
    'th',
    'he'
  ];

  // Add a method to check if a language is RTL
  static bool isRtlLanguage(String languageCode) {
    return languageCode == 'ar' || languageCode == 'he' || languageCode == 'hi';
  }

  // Add a method to get text direction
  static TextDirection getTextDirectionForLanguage(String languageCode) {
    return isRtlLanguage(languageCode) ? TextDirection.rtl : TextDirection.ltr;
  }

  static final ValueNotifier<Locale> localeNotifier =
      ValueNotifier<Locale>(Locale('en', ''));

  static Future<Locale> getLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if user has explicitly selected a language before
    bool hasSelectedLanguage = prefs.getBool(HAS_SELECTED_LANGUAGE) ?? false;

    if (hasSelectedLanguage) {
      // Use the previously selected language
      String languageCode = prefs.getString(LANGUAGE_CODE) ?? 'en';
      final locale = Locale(languageCode, '');
      localeNotifier.value = locale;
      return locale;
    } else {
      // Try to use the device language if supported
      Locale deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
      String deviceLanguage = deviceLocale.languageCode;

      // Check if device language is supported
      if (supportedLanguages.contains(deviceLanguage)) {
        // Save the device language as the selected language
        await prefs.setString(LANGUAGE_CODE, deviceLanguage);
        final locale = Locale(deviceLanguage, '');
        localeNotifier.value = locale;
        return locale;
      } else {
        // Default to English if device language is not supported
        await prefs.setString(LANGUAGE_CODE, 'en');
        final locale = Locale('en', '');
        localeNotifier.value = locale;
        return locale;
      }
    }
  }

  static Future<void> changeLanguage(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save the language code
    await prefs.setString(LANGUAGE_CODE, languageCode);

    // Mark that user has explicitly selected a language
    await prefs.setBool(HAS_SELECTED_LANGUAGE, true);

    // Update the notifier
    localeNotifier.value = Locale(languageCode, '');
  }
}
