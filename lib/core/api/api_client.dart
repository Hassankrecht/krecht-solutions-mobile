import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ─── Internals ─────────────────────────────────────────────────────────────

  Future<Map<String, String>> _headers() async {
    return <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final q = query?.map((k, v) => MapEntry(k, v.toString()));
    return Uri.parse(
      '${AppConstants.baseUrl}$path',
    ).replace(queryParameters: q?.isEmpty ?? true ? null : q);
  }

  dynamic _handleResponse(http.Response res) {
    final body = jsonDecode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      // Extract data field if response has {success, message, data} structure
      if (body is Map && body.containsKey('data')) {
        return body['data'];
      }
      return body;
    }
    final msg = body is Map
        ? (body['message'] ?? body['error'] ?? 'Unknown error').toString()
        : 'Unknown error';
    throw ApiException(statusCode: res.statusCode, message: msg, data: body);
  }

  Future<dynamic> _get(String path, {Map<String, dynamic>? query}) async {
    _isLoading = true;
    try {
      final res = await http
          .get(_uri(path, query), headers: await _headers())
          .timeout(AppConstants.connectTimeout);
      return _handleResponse(res);
    } on TimeoutException {
      throw ApiException(message: 'Request timed out. Please try again.');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Network error: $e');
    } finally {
      _isLoading = false;
    }
  }

  Future<dynamic> _post(String path, Map<String, dynamic> body) async {
    _isLoading = true;
    try {
      final res = await http
          .post(_uri(path), headers: await _headers(), body: jsonEncode(body))
          .timeout(AppConstants.connectTimeout);
      return _handleResponse(res);
    } on TimeoutException {
      throw ApiException(message: 'Request timed out. Please try again.');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Network error: $e');
    } finally {
      _isLoading = false;
    }
  }

  // ─── Content endpoints ────────────────────────────────────────────────────

  Future<dynamic> getProjects() => _get('/projects');

  Future<dynamic> getProjectDetails(String id) => _get('/projects/$id');

  Future<dynamic> getProjectCategories() => _get('/project-categories');

  Future<dynamic> getServices() => _get('/services');

  Future<dynamic> getServiceDetails(int id) => _get('/services/$id');

  Future<dynamic> getPricingCategories() => _get('/pricing-categories');

  Future<dynamic> getPricingPackages() => _get('/pricing-packages');

  Future<dynamic> getPricingPackageDetails(String slug) =>
      _get('/pricing-packages/$slug');

  Future<dynamic> getContact() => _get('/contact');

  Future<dynamic> getAppSettings() => _get('/settings');

  Future<dynamic> getPrivacyPolicy() => _get('/pages/privacy-policy');

  Future<dynamic> getTerms() => _get('/pages/terms');

  Future<dynamic> getSecurity() => _get('/pages/security');

  Future<dynamic> getFaqs() => _get('/faqs');

  Future<dynamic> submitContact({
    required String name,
    required String email,
    String? phone,
    String? subject,
    required String message,
  }) => _post('/contact', {
    'name': name,
    'email': email,
    if (phone != null && phone.isNotEmpty) 'phone': phone,
    if (subject != null && subject.isNotEmpty) 'subject': subject,
    'message': message,
  });
}
