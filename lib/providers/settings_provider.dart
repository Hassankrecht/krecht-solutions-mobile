import 'package:flutter/foundation.dart';
import '../core/api/api_client.dart';
import '../core/api/api_exception.dart';
import '../models/app_setting_model.dart';
import '../models/faq_item_model.dart';

class SettingsProvider extends ChangeNotifier {
  final ApiClient _api = ApiClient.instance;

  final AppSettingModel _appSettings = const AppSettingModel(
    appName: 'Krecht Solutions',
    appLogo: '',
    appVersion: '1.0.0',
    maintenanceMode: false,
    contactPhone: '',
    contactEmail: '',
    whatsappNumber: '',
    defaultCurrency: 'USD',
    defaultLanguage: 'en',
  );
  String? _privacyPolicy;
  String? _terms;
  String? _security;
  List<FaqItemModel> _faqs = [];
  bool _isLoading = false;
  String? _errorMessage;

  AppSettingModel? get appSettings => _appSettings;
  String? get privacyPolicy => _privacyPolicy;
  String? get terms => _terms;
  String? get security => _security;
  List<FaqItemModel> get faqs => _faqs;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isInMaintenanceMode => _appSettings.maintenanceMode;

  Future<void> fetchAppSettings() async {
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchPrivacyPolicy() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _api.getPrivacyPolicy();
      _privacyPolicy =
          response['content']?.toString() ??
          response['data']?['content']?.toString() ??
          response['data']?.toString();
      _errorMessage = null;
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Failed to load privacy policy: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTerms() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _api.getTerms();
      _terms =
          response['content']?.toString() ??
          response['data']?['content']?.toString() ??
          response['data']?.toString();
      _errorMessage = null;
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Failed to load terms: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSecurity() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _api.getSecurity();
      _security =
          response['content']?.toString() ??
          response['data']?['content']?.toString() ??
          response['data']?.toString();
      _errorMessage = null;
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Failed to load security info: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchFaqs() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _api.getFaqs();
      final dataList = response['data'] as List<dynamic>?;
      if (dataList != null) {
        _faqs = dataList
            .map((json) => FaqItemModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      _errorMessage = null;
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Failed to load FAQs: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshAll() async {
    await Future.wait([
      fetchAppSettings(),
      fetchPrivacyPolicy(),
      fetchTerms(),
      fetchSecurity(),
      fetchFaqs(),
    ], eagerError: false);
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
