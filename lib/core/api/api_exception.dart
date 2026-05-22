// Normalized exception type for API and network failures.
class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final dynamic data;

  ApiException({this.statusCode, required this.message, this.data});

  // Convenience flags used by UI/provider code when handling common failures.
  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isServerError => statusCode != null && statusCode! >= 500;
  bool get isTimeout => statusCode == null && message.contains('timed out');

  @override
  String toString() => 'ApiException(${statusCode ?? 'network'}): $message';
}
