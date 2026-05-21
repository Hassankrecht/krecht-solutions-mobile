class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.type,
    this.description,
    this.image,
    this.isActive = true,
    this.order = 0,
    this.createdAt,
    this.updatedAt,
    // Bilingual fields
    this.nameEn,
    this.nameAr,
    this.descriptionEn,
    this.descriptionAr,
  });

  final int id;
  final String name;
  final String slug;
  final String? type;
  final String? description;
  final String? image;
  final bool isActive;
  final int order;
  final String? createdAt;
  final String? updatedAt;

  // Bilingual fields
  final String? nameEn;
  final String? nameAr;
  final String? descriptionEn;
  final String? descriptionAr;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      type: json['type']?.toString(),
      description: json['description']?.toString(),
      image: json['image']?.toString(),
      isActive: json['is_active'] as bool? ?? true,
      order: (json['order'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      // Bilingual fields
      nameEn: json['name_en']?.toString(),
      nameAr: json['name_ar']?.toString(),
      descriptionEn: json['description_en']?.toString(),
      descriptionAr: json['description_ar']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
    'type': type,
    'description': description,
    'image': image,
    'is_active': isActive,
    'order': order,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'name_en': nameEn,
    'name_ar': nameAr,
    'description_en': descriptionEn,
    'description_ar': descriptionAr,
  };

  String getLocalizedName(bool isArabic) {
    return isArabic && nameAr != null && nameAr!.isNotEmpty
        ? nameAr!
        : (nameEn ?? name);
  }

  String getLocalizedDescription(bool isArabic) {
    return isArabic && descriptionAr != null && descriptionAr!.isNotEmpty
        ? descriptionAr!
        : (descriptionEn ?? description ?? '');
  }
}
