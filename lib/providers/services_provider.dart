import 'package:flutter/foundation.dart';
import '../core/api/api_client.dart';
import '../core/api/api_exception.dart';

class ServicesProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<Map<String, dynamic>> _services = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Map<String, dynamic>> get services => _services;

  Future<void> fetchServices() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await ApiClient.instance.getServices();
      _services = List<Map<String, dynamic>>.from(
        (res as List).map((e) => Map<String, dynamic>.from(e as Map)),
      );
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to load services: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
