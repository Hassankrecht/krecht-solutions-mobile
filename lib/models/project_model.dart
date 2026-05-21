import 'category_model.dart';

class ProjectModel {
  const ProjectModel({
    required this.id,
    required this.title,
    this.slug,
    this.shortDescription,
    this.description,
    this.client,
    this.url,
    this.image,
    this.galleryImages,
    this.video,
    this.technologies,
    this.technologiesEn,
    this.technologiesAr,
    this.categoryId,
    this.status,
    this.isActive = true,
    this.order = 0,
    this.completedAt,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.categories,
    // Bilingual fields
    this.titleEn,
    this.titleAr,
    this.shortDescriptionEn,
    this.shortDescriptionAr,
    this.descriptionEn,
    this.descriptionAr,
    this.contentEn,
    this.contentAr,
  });

  final int id;
  final String title;
  final String? slug;
  final String? shortDescription;
  final String? description;
  final String? client;
  final String? url;
  final String? image;
  final List<String>? galleryImages;
  final String? video;
  final String? technologies;
  final List<String>? technologiesEn;
  final List<String>? technologiesAr;
  final int? categoryId;
  final String? status;
  final bool isActive;
  final int order;
  final String? completedAt;
  final String? createdAt;
  final String? updatedAt;
  final CategoryModel? category;
  final List<CategoryModel>? categories;

  // Bilingual fields
  final String? titleEn;
  final String? titleAr;
  final String? shortDescriptionEn;
  final String? shortDescriptionAr;
  final String? descriptionEn;
  final String? descriptionAr;
  final String? contentEn;
  final String? contentAr;

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString(),
      shortDescription: json['short_description']?.toString(),
      description: json['description']?.toString(),
      client: json['client']?.toString(),
      url: json['url']?.toString(),
      image: json['image']?.toString(),
      galleryImages: _stringList(json['gallery_images']),
      video: json['video']?.toString(),
      technologies: json['technologies']?.toString(),
      technologiesEn: _stringList(json['technologies_en']),
      technologiesAr: _stringList(json['technologies_ar']),
      categoryId: (json['category_id'] as num?)?.toInt(),
      status: json['status']?.toString(),
      isActive: _boolValue(json['is_active'], fallback: true),
      order: (json['order'] as num?)?.toInt() ?? 0,
      completedAt: json['completed_at']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      category: json['category'] != null && json['category'] is Map
          ? CategoryModel.fromJson(
              Map<String, dynamic>.from(json['category'] as Map),
            )
          : null,
      categories: json['categories'] != null
          ? (json['categories'] as List<dynamic>)
                .whereType<Map>()
                .map(
                  (e) => CategoryModel.fromJson(Map<String, dynamic>.from(e)),
                )
                .toList()
          : null,
      // Bilingual fields
      titleEn: json['title_en']?.toString(),
      titleAr: json['title_ar']?.toString(),
      shortDescriptionEn: json['short_description_en']?.toString(),
      shortDescriptionAr: json['short_description_ar']?.toString(),
      descriptionEn: json['description_en']?.toString(),
      descriptionAr: json['description_ar']?.toString(),
      contentEn: json['content_en']?.toString(),
      contentAr: json['content_ar']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'slug': slug,
    'short_description': shortDescription,
    'description': description,
    'client': client,
    'url': url,
    'image': image,
    'gallery_images': galleryImages,
    'video': video,
    'technologies': technologies,
    'technologies_en': technologiesEn,
    'technologies_ar': technologiesAr,
    'category_id': categoryId,
    'status': status,
    'is_active': isActive,
    'order': order,
    'completed_at': completedAt,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'category': category?.toJson(),
    'title_en': titleEn,
    'title_ar': titleAr,
    'short_description_en': shortDescriptionEn,
    'short_description_ar': shortDescriptionAr,
    'description_en': descriptionEn,
    'description_ar': descriptionAr,
    'content_en': contentEn,
    'content_ar': contentAr,
  };

  String getLocalizedTitle(bool isArabic) {
    return isArabic && titleAr != null && titleAr!.isNotEmpty
        ? titleAr!
        : (titleEn ?? title);
  }

  String getLocalizedShortDescription(bool isArabic) {
    return isArabic &&
            shortDescriptionAr != null &&
            shortDescriptionAr!.isNotEmpty
        ? shortDescriptionAr!
        : (shortDescriptionEn ?? shortDescription ?? '');
  }

  String getLocalizedDescription(bool isArabic) {
    return isArabic && descriptionAr != null && descriptionAr!.isNotEmpty
        ? descriptionAr!
        : (descriptionEn ?? description ?? '');
  }

  String getLocalizedContent(bool isArabic) {
    return isArabic && contentAr != null && contentAr!.isNotEmpty
        ? contentAr!
        : (contentEn ?? description ?? '');
  }

  List<String> getLocalizedTechnologies(bool isArabic) {
    if (isArabic && technologiesAr != null && technologiesAr!.isNotEmpty) {
      return technologiesAr!;
    }
    return technologiesEn ?? [];
  }

  static bool _boolValue(dynamic value, {required bool fallback}) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.toLowerCase().trim();
      if (normalized == 'true' || normalized == '1') return true;
      if (normalized == 'false' || normalized == '0') return false;
    }
    return fallback;
  }

  static List<String>? _stringList(dynamic value) {
    if (value == null) return null;
    if (value is List) {
      return value
          .map((e) => e?.toString().trim() ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
    }
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return null;
      return trimmed
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }
    return null;
  }
}
