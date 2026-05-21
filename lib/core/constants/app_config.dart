import 'dart:io';
import 'package:flutter/foundation.dart';

abstract final class AppConfig {
  // Toggle between local and production API
  static const bool isLocal = true;

  // Production API
  static const String productionBaseUrl = 'https://krechtsolutions.free.nf/api';

  // Local API URLs based on platform
  static String get _localBaseUrl {
    if (kIsWeb) {
      // Web/Chrome development
      return 'http://127.0.0.1:8000/api';
    }

    if (Platform.isAndroid) {
      // Check if running on emulator or real device
      // Android emulator uses 10.0.2.2 to access host machine
      // Real device needs the PC's local IP
      return 'http://10.0.2.2:8000/api';
    }

    if (Platform.isIOS) {
      // iOS simulator can use localhost
      return 'http://127.0.0.1:8000/api';
    }

    // Default to localhost for other platforms
    return 'http://127.0.0.1:8000/api';
  }

  // Alternative local API using Laragon virtual host
  static const String laragonBaseUrl = 'http://krechtsolutions.test/api';

  // Get the appropriate base URL based on isLocal setting
  static String get baseUrl {
    if (isLocal) {
      return _localBaseUrl;
    }
    return productionBaseUrl;
  }

  // For manual override (e.g., when using Laragon virtual host)
  // You can change _localBaseUrl above to use laragonBaseUrl if needed
}
