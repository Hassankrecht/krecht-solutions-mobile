class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final dynamic data;

  ApiException({this.statusCode, required this.message, this.data});

  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isServerError => statusCode != null && statusCode! >= 500;
  bool get isTimeout => statusCode == null && message.contains('timed out');

  @override
  String toString() => 'ApiException(${statusCode ?? 'network'}): $message';
}
