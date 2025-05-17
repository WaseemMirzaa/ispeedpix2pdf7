import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String LANGUAGE_CODE = 'languageCode';
  
  static final ValueNotifier<Locale> localeNotifier = ValueNotifier<Locale>(Locale('en', ''));
  
  static Future<Locale> getLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String languageCode = prefs.getString(LANGUAGE_CODE) ?? 'en';
    final locale = Locale(languageCode, '');
    localeNotifier.value = locale;
    return locale;
  }
  
  static Future<void> changeLanguage(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(LANGUAGE_CODE, languageCode);
    
    // Update the notifier
    localeNotifier.value = Locale(languageCode, '');
  }
}
