import '../constants/app_config.dart';

// Converts API image/video paths into absolute URLs the UI can load.
class ImageHelper {
  static String? buildImageUrl(String? path) {
    // Empty values should stay empty so image widgets can show placeholders.
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

    // Backend sometimes returns paths with storage/assets already included.
    // Other paths are treated as files inside the public storage directory.
    final normalizedPath =
        cleanPath.startsWith('assets/') || cleanPath.startsWith('storage/')
        ? cleanPath
        : 'storage/$cleanPath';
    return Uri.parse(
      '${AppConfig.siteUrl}/',
    ).resolve(normalizedPath).toString();
  }

  static String? buildVideoUrl(String? path) {
    // Videos are stored under the same public asset rules as images.
    return buildImageUrl(path);
  }

  static List<String?> buildImageUrls(List<String>? paths) {
    // Converts gallery image paths while preserving an empty gallery.
    if (paths == null || paths.isEmpty) {
      return [];
    }
    return paths.map((path) => buildImageUrl(path)).toList();
  }
}
