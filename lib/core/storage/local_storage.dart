import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage._();
  static final LocalStorage instance = LocalStorage._();

  // Storage keys
  static const String _authTokenKey = 'auth_token';
  static const String _userDataKey = 'user_data';
  static const String _languageKey = 'selected_language';
  static const String _darkModeKey = 'dark_mode';
  static const String _notificationKey = 'notification_setting';
  static const String _currencyKey = 'currency';
  static const String _appSettingsKey = 'cached_app_settings';

  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Auth Token
  Future<void> saveAuthToken(String token) async {
    final prefs = await _getPrefs();
    await prefs.setString(_authTokenKey, token);
  }

  Future<String?> getAuthToken() async {
    final prefs = await _getPrefs();
    return prefs.getString(_authTokenKey);
  }

  // User Data
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await _getPrefs();
    await prefs.setString(_userDataKey, jsonEncode(userData));
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await _getPrefs();
    final userDataString = prefs.getString(_userDataKey);
    if (userDataString == null) return null;
    return jsonDecode(userDataString) as Map<String, dynamic>;
  }

  // Selected Language
  Future<void> saveLanguage(String language) async {
    final prefs = await _getPrefs();
    await prefs.setString(_languageKey, language);
  }

  Future<String?> getLanguage() async {
    final prefs = await _getPrefs();
    return prefs.getString(_languageKey);
  }

  // Dark Mode
  Future<void> saveDarkMode(bool isDarkMode) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_darkModeKey, isDarkMode);
  }

  Future<bool> getDarkMode() async {
    final prefs = await _getPrefs();
    return prefs.getBool(_darkModeKey) ?? false;
  }

  // Notification Setting
  Future<void> saveNotificationSetting(bool enabled) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_notificationKey, enabled);
  }

  Future<bool> getNotificationSetting() async {
    final prefs = await _getPrefs();
    return prefs.getBool(_notificationKey) ?? true;
  }

  // Currency
  Future<void> saveCurrency(String currency) async {
    final prefs = await _getPrefs();
    await prefs.setString(_currencyKey, currency);
  }

  Future<String?> getCurrency() async {
    final prefs = await _getPrefs();
    return prefs.getString(_currencyKey);
  }

  // Cached App Settings
  Future<void> saveAppSettings(Map<String, dynamic> settings) async {
    final prefs = await _getPrefs();
    await prefs.setString(_appSettingsKey, jsonEncode(settings));
  }

  Future<Map<String, dynamic>?> getAppSettings() async {
    final prefs = await _getPrefs();
    final settingsString = prefs.getString(_appSettingsKey);
    if (settingsString == null) return null;
    return jsonDecode(settingsString) as Map<String, dynamic>;
  }

  // Utility Methods
  Future<bool> isLoggedIn() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    await clearAuthData();
  }

  Future<void> clearAuthData() async {
    final prefs = await _getPrefs();
    await prefs.remove(_authTokenKey);
    await prefs.remove(_userDataKey);
  }

  Future<void> clearCache() async {
    final prefs = await _getPrefs();
    await prefs.remove(_appSettingsKey);
  }

  Future<void> clearAll() async {
    final prefs = await _getPrefs();
    await prefs.clear();
  }

  // Generic methods for backward compatibility
  Future<void> write(String key, dynamic value) async {
    final prefs = await _getPrefs();
    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    } else {
      await prefs.setString(key, jsonEncode(value));
    }
  }

  Future<T?> read<T>(String key) async {
    final prefs = await _getPrefs();
    final value = prefs.get(key);
    if (value == null) return null;
    if (value is T) return value as T;
    return null;
  }

  Future<void> remove(String key) async {
    final prefs = await _getPrefs();
    await prefs.remove(key);
  }

  Future<bool> containsKey(String key) async {
    final prefs = await _getPrefs();
    return prefs.containsKey(key);
  }
}
