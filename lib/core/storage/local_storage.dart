import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Shared wrapper around SharedPreferences for simple local persistence.
class LocalStorage {
  LocalStorage._();
  static final LocalStorage instance = LocalStorage._();

  // Storage keys
  static const String _authTokenKey = 'auth_token';
  static const String _userDataKey = 'user_data';
  static const String _languageKey = 'selected_language';
  static const String _darkModeKey = 'dark_mode';
  static const String _themeModeKey = 'theme_mode';
  static const String _notificationKey = 'notification_setting';
  static const String _currencyKey = 'currency';

  SharedPreferences? _prefs;

  // Lazily initializes SharedPreferences once and reuses the instance.
  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Auth Token
  // Saves the API auth token for later authenticated requests.
  Future<void> saveAuthToken(String token) async {
    final prefs = await _getPrefs();
    await prefs.setString(_authTokenKey, token);
  }

  // Reads the saved API auth token.
  Future<String?> getAuthToken() async {
    final prefs = await _getPrefs();
    return prefs.getString(_authTokenKey);
  }

  // User Data
  // Stores user data as JSON.
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await _getPrefs();
    await prefs.setString(_userDataKey, jsonEncode(userData));
  }

  // Reads and decodes stored user data.
  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await _getPrefs();
    final userDataString = prefs.getString(_userDataKey);
    if (userDataString == null) return null;
    return jsonDecode(userDataString) as Map<String, dynamic>;
  }

  // Selected Language
  // Saves the selected language code.
  Future<void> saveLanguage(String language) async {
    final prefs = await _getPrefs();
    await prefs.setString(_languageKey, language);
  }

  // Reads the selected language code.
  Future<String?> getLanguage() async {
    final prefs = await _getPrefs();
    return prefs.getString(_languageKey);
  }

  // Dark Mode
  // Saves the dark-mode preference.
  Future<void> saveDarkMode(bool isDarkMode) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_darkModeKey, isDarkMode);
    await prefs.setString(_themeModeKey, isDarkMode ? 'dark' : 'light');
  }

  // Reads the dark-mode preference.
  Future<bool> getDarkMode() async {
    final prefs = await _getPrefs();
    return prefs.getBool(_darkModeKey) ?? false;
  }

  Future<void> saveThemeMode(String themeMode) async {
    final prefs = await _getPrefs();
    await prefs.setString(_themeModeKey, themeMode);
    if (themeMode == 'dark' || themeMode == 'light') {
      await prefs.setBool(_darkModeKey, themeMode == 'dark');
    }
  }

  Future<String?> getThemeMode() async {
    final prefs = await _getPrefs();
    final themeMode = prefs.getString(_themeModeKey);
    if (themeMode != null) return themeMode;
    final oldDarkMode = prefs.getBool(_darkModeKey);
    if (oldDarkMode == null) return null;
    return oldDarkMode ? 'dark' : 'light';
  }

  // Notification Setting
  // Saves notification preference.
  Future<void> saveNotificationSetting(bool enabled) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_notificationKey, enabled);
  }

  // Reads notification preference, defaulting to enabled.
  Future<bool> getNotificationSetting() async {
    final prefs = await _getPrefs();
    return prefs.getBool(_notificationKey) ?? true;
  }

  // Currency
  // Saves the preferred currency code.
  Future<void> saveCurrency(String currency) async {
    final prefs = await _getPrefs();
    await prefs.setString(_currencyKey, currency);
  }

  // Reads the preferred currency code.
  Future<String?> getCurrency() async {
    final prefs = await _getPrefs();
    return prefs.getString(_currencyKey);
  }

  // Utility Methods
  // Checks whether an auth token is currently stored.
  Future<bool> isLoggedIn() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  // Clears authentication data.
  Future<void> logout() async {
    await clearAuthData();
  }

  // Removes only auth-related stored data.
  Future<void> clearAuthData() async {
    final prefs = await _getPrefs();
    await prefs.remove(_authTokenKey);
    await prefs.remove(_userDataKey);
  }

  // Clears all locally stored app data.
  Future<void> clearAll() async {
    final prefs = await _getPrefs();
    await prefs.clear();
  }

  // Generic methods for backward compatibility
  // Generic write helper for simple values and JSON-encodable objects.
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

  // Generic typed read helper.
  Future<T?> read<T>(String key) async {
    final prefs = await _getPrefs();
    final value = prefs.get(key);
    if (value == null) return null;
    if (value is T) return value as T;
    return null;
  }

  // Removes one stored key.
  Future<void> remove(String key) async {
    final prefs = await _getPrefs();
    await prefs.remove(key);
  }

  // Checks if a key exists in local storage.
  Future<bool> containsKey(String key) async {
    final prefs = await _getPrefs();
    return prefs.containsKey(key);
  }
}
