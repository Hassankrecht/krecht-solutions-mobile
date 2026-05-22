// Pricing category data model used to filter pricing packages.
class PricingCategoryModel {
  const PricingCategoryModel({
    required this.id,
    this.name,
    this.slug,
    this.description,
    this.icon,
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
  final String? name;
  final String? slug;
  final String? description;
  final String? icon;
  final bool isActive;
  final int order;
  final String? createdAt;
  final String? updatedAt;

  // Bilingual fields
  final String? nameEn;
  final String? nameAr;
  final String? descriptionEn;
  final String? descriptionAr;

  // Creates a pricing category from API JSON with safe fallback values.
  factory PricingCategoryModel.fromJson(Map<String, dynamic> json) {
    return PricingCategoryModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString(),
      slug: json['slug']?.toString(),
      description: json['description']?.toString(),
      icon: json['icon']?.toString(),
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
    'description': description,
    'icon': icon,
    'is_active': isActive,
    'order': order,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'name_en': nameEn,
    'name_ar': nameAr,
    'description_en': descriptionEn,
    'description_ar': descriptionAr,
  };

  // Returns Arabic name when active and available, otherwise English/default.
  String getLocalizedName(bool isArabic) {
    return isArabic && nameAr != null && nameAr!.isNotEmpty
        ? nameAr!
        : (nameEn ?? name ?? '');
  }

  // Returns Arabic description when active and available.
  String getLocalizedDescription(bool isArabic) {
    return isArabic && descriptionAr != null && descriptionAr!.isNotEmpty
        ? descriptionAr!
        : (descriptionEn ?? description ?? '');
  }
}
