/// Represents a `Page` record from `GET /pages/{slug}`.
/// Slugs used: about | privacy-policy | terms | security
class PolicyPageModel {
  const PolicyPageModel({
    required this.id,
    required this.title,
    required this.slug,
    this.content,
    this.metaTitle,
    this.metaDescription,
    this.isPublished = true,
    this.createdAt,
    this.updatedAt,
    this.titleEn,
    this.titleAr,
    this.contentEn,
    this.contentAr,
    this.metaTitleEn,
    this.metaTitleAr,
    this.metaDescriptionEn,
    this.metaDescriptionAr,
  });

  final int id;
  final String title;
  final String slug;
  final String? content;
  final String? metaTitle;
  final String? metaDescription;
  final bool isPublished;
  final String? createdAt;
  final String? updatedAt;
  final String? titleEn;
  final String? titleAr;
  final String? contentEn;
  final String? contentAr;
  final String? metaTitleEn;
  final String? metaTitleAr;
  final String? metaDescriptionEn;
  final String? metaDescriptionAr;

  // Creates a policy page from API JSON with safe fallback values.
  factory PolicyPageModel.fromJson(Map<String, dynamic> json) {
    return PolicyPageModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      content: json['content']?.toString(),
      metaTitle: json['meta_title']?.toString(),
      metaDescription: json['meta_description']?.toString(),
      isPublished: json['is_published'] as bool? ?? true,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      titleEn: json['title_en']?.toString(),
      titleAr: json['title_ar']?.toString(),
      contentEn: json['content_en']?.toString(),
      contentAr: json['content_ar']?.toString(),
      metaTitleEn: json['meta_title_en']?.toString(),
      metaTitleAr: json['meta_title_ar']?.toString(),
      metaDescriptionEn: json['meta_description_en']?.toString(),
      metaDescriptionAr: json['meta_description_ar']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'slug': slug,
    'content': content,
    'meta_title': metaTitle,
    'meta_description': metaDescription,
    'is_published': isPublished,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'title_en': titleEn,
    'title_ar': titleAr,
    'content_en': contentEn,
    'content_ar': contentAr,
    'meta_title_en': metaTitleEn,
    'meta_title_ar': metaTitleAr,
    'meta_description_en': metaDescriptionEn,
    'meta_description_ar': metaDescriptionAr,
  };

  String getLocalizedTitle(bool isArabic) {
    return isArabic && titleAr != null && titleAr!.isNotEmpty
        ? titleAr!
        : (titleEn ?? title);
  }

  String getLocalizedContent(bool isArabic) {
    return isArabic && contentAr != null && contentAr!.isNotEmpty
        ? contentAr!
        : (contentEn ?? content ?? '');
  }
}
