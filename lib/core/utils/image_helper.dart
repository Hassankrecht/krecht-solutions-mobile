import '../constants/app_constants.dart';

class ImageHelper {
  static String get _assetBaseUrl {
    final apiUri = Uri.parse(AppConstants.baseUrl);
    return apiUri
        .replace(path: '', query: null, fragment: null)
        .toString()
        .replaceFirst(RegExp(r'/$'), '');
  }

  static String? buildImageUrl(String? path) {
    final rawPath = path?.trim();
    if (rawPath == null || rawPath.isEmpty) {
      return null;
    }

    // If path already starts with http, use it directly
    if (rawPath.startsWith('http://') || rawPath.startsWith('https://')) {
      return Uri.parse(rawPath).toString();
    }

    // Remove leading slash if present
    final cleanPath = rawPath.replaceFirst(RegExp(r'^/+'), '');

    final normalizedPath =
        cleanPath.startsWith('assets/') || cleanPath.startsWith('storage/')
        ? cleanPath
        : 'storage/$cleanPath';
    return Uri.parse('$_assetBaseUrl/').resolve(normalizedPath).toString();
  }

  static String? buildVideoUrl(String? path) {
    return buildImageUrl(path);
  }

  static List<String?> buildImageUrls(List<String>? paths) {
    if (paths == null || paths.isEmpty) {
      return [];
    }
    return paths.map((path) => buildImageUrl(path)).toList();
  }
}
