import 'app_config.dart';

// App-wide constant values that should remain consistent across modules.
abstract final class AppConstants {
  static const String appName = 'Krecht Solutions';
  static const String appVersion = '1.0.0';

  static String get baseUrl => AppConfig.baseUrl;

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  static const String tokenKey = 'auth_token';
  static const String userKey = 'current_user';
  static const String themeKey = 'app_theme';
}
