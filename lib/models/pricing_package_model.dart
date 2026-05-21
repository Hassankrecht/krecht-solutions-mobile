class PricingPackageModel {
  const PricingPackageModel({
    required this.id,
    this.name,
    this.slug,
    this.price,
    this.category,
    this.categoryEn,
    this.categoryAr,
    this.features,
    this.description,
    this.isFeatured = false,
    this.isActive = true,
    this.order = 0,
    this.pricingCategoryId,
    this.pricingCategory,
    this.createdAt,
    this.updatedAt,
    // Bilingual fields
    this.nameEn,
    this.nameAr,
    this.descriptionEn,
    this.descriptionAr,
    this.featuresEn,
    this.featuresAr,
  });

  final int id;
  final String? name;
  final String? slug;
  final String? price;
  final String? category;
  final String? categoryEn;
  final String? categoryAr;
  final String? features;
  final String? description;
  final bool isFeatured;
  final bool isActive;
  final int order;
  final int? pricingCategoryId;
  final Map<String, dynamic>? pricingCategory;
  final String? createdAt;
  final String? updatedAt;

  // Bilingual fields
  final String? nameEn;
  final String? nameAr;
  final String? descriptionEn;
  final String? descriptionAr;
  final List<String>? featuresEn;
  final List<String>? featuresAr;

  factory PricingPackageModel.fromJson(Map<String, dynamic> json) {
    return PricingPackageModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString(),
      slug: json['slug']?.toString(),
      price: json['price']?.toString(),
      category: json['category']?.toString(),
      categoryEn: json['category_en']?.toString(),
      categoryAr: json['category_ar']?.toString(),
      features: json['features']?.toString(),
      description: json['description']?.toString(),
      isFeatured: json['is_featured'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      order: (json['order'] as num?)?.toInt() ?? 0,
      pricingCategoryId: (json['pricing_category_id'] as num?)?.toInt(),
      pricingCategory:
          json['pricing_category'] != null && json['pricing_category'] is Map
          ? Map<String, dynamic>.from(json['pricing_category'] as Map)
          : null,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      // Bilingual fields
      nameEn: json['name_en']?.toString(),
      nameAr: json['name_ar']?.toString(),
      descriptionEn: json['description_en']?.toString(),
      descriptionAr: json['description_ar']?.toString(),
      featuresEn: json['features_en'] != null
          ? (json['features_en'] as List<dynamic>)
                .map((e) => e?.toString() ?? '')
                .where((s) => s.isNotEmpty)
                .toList()
          : null,
      featuresAr: json['features_ar'] != null
          ? (json['features_ar'] as List<dynamic>)
                .map((e) => e?.toString() ?? '')
                .where((s) => s.isNotEmpty)
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
    'price': price,
    'category': category,
    'category_en': categoryEn,
    'category_ar': categoryAr,
    'features': features,
    'description': description,
    'is_featured': isFeatured,
    'is_active': isActive,
    'order': order,
    'pricing_category_id': pricingCategoryId,
    'pricing_category': pricingCategory,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'name_en': nameEn,
    'name_ar': nameAr,
    'description_en': descriptionEn,
    'description_ar': descriptionAr,
    'features_en': featuresEn,
    'features_ar': featuresAr,
  };

  String getLocalizedName(bool isArabic) {
    return isArabic && nameAr != null && nameAr!.isNotEmpty
        ? nameAr!
        : (nameEn ?? name ?? '');
  }

  String getLocalizedDescription(bool isArabic) {
    return isArabic && descriptionAr != null && descriptionAr!.isNotEmpty
        ? descriptionAr!
        : (descriptionEn ?? description ?? '');
  }

  List<String> getLocalizedFeatures(bool isArabic) {
    if (isArabic && featuresAr != null && featuresAr!.isNotEmpty) {
      return featuresAr!;
    }
    return featuresEn ?? [];
  }

  String get formattedPrice {
    return price ?? '';
  }

  String getLocalizedCategory(bool isArabic) {
    return isArabic && categoryAr != null && categoryAr!.isNotEmpty
        ? categoryAr!
        : (categoryEn ?? category ?? '');
  }
}
