import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en', 'US');
  
  Locale get locale => _locale;
  
  bool get isEnglish => _locale.languageCode == 'en';
  bool get isSerbian => _locale.languageCode == 'sr';
  
  LanguageProvider() {
    _loadSavedLanguage();
  }
  
  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode') ?? 'en';
    final countryCode = prefs.getString('countryCode') ?? 'US';
    
    _locale = Locale(languageCode, countryCode);
    notifyListeners();
  }
  
  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    
    _locale = locale;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
    await prefs.setString('countryCode', locale.countryCode ?? '');
    
    notifyListeners();
  }
  
  Future<void> setEnglish() async {
    await setLocale(const Locale('en', 'US'));
  }
  
  Future<void> setSerbian() async {
    await setLocale(const Locale('sr', 'RS'));
  }
} 