class ServiceItemModel {
  const ServiceItemModel({
    required this.id,
    required this.title,
    this.slug,
    this.shortDescription,
    this.description,
    this.icon,
    this.image,
    this.isActive = true,
    this.sortOrder = 0,
    this.createdAt,
    this.updatedAt,
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
  final String? icon;
  final String? image;
  final bool isActive;
  final int sortOrder;
  final String? createdAt;
  final String? updatedAt;

  // Bilingual fields
  final String? titleEn;
  final String? titleAr;
  final String? shortDescriptionEn;
  final String? shortDescriptionAr;
  final String? descriptionEn;
  final String? descriptionAr;
  final String? contentEn;
  final String? contentAr;

  factory ServiceItemModel.fromJson(Map<String, dynamic> json) {
    return ServiceItemModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString(),
      shortDescription: json['short_description']?.toString(),
      description: json['description']?.toString(),
      icon: json['icon']?.toString(),
      image: json['image']?.toString(),
      isActive: json['is_active'] as bool? ?? true,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
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
    'icon': icon,
    'image': image,
    'is_active': isActive,
    'sort_order': sortOrder,
    'created_at': createdAt,
    'updated_at': updatedAt,
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
}
