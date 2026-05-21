import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage { english, arabic }

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'app_language';
  
  AppLanguage _currentLanguage = AppLanguage.english;
  
  AppLanguage get currentLanguage => _currentLanguage;
  
  bool get isArabic => _currentLanguage == AppLanguage.arabic;
  
  Locale get locale => _currentLanguage == AppLanguage.arabic
      ? const Locale('ar')
      : const Locale('en');
  
  TextDirection get textDirection => _currentLanguage == AppLanguage.arabic
      ? TextDirection.rtl
      : TextDirection.ltr;

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey);
    
    if (languageCode != null) {
      _currentLanguage = languageCode == 'ar' 
          ? AppLanguage.arabic 
          : AppLanguage.english;
    }
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage language) async {
    _currentLanguage = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language == AppLanguage.arabic ? 'ar' : 'en');
    notifyListeners();
  }

  String getLocalizedContent({
    required String? english,
    required String? arabic,
  }) {
    return isArabic && arabic != null && arabic.isNotEmpty 
        ? arabic 
        : (english ?? '');
  }
}
