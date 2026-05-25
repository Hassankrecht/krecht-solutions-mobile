import 'package:flutter/foundation.dart';
import '../core/api/api_client.dart';
import '../core/api/api_exception.dart';
import '../models/pricing_category_model.dart';
import '../models/pricing_package_model.dart';

// Manages pricing categories, packages, selected filters, loading, and errors.
class PricingProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<PricingCategoryModel> _categories = [];
  List<PricingPackageModel> _packages = [];
  PricingPackageModel? _selectedPackage;
  PricingCategoryModel? _selectedCategory;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<PricingCategoryModel> get categories => _categories;
  List<PricingPackageModel> get packages => _packages;
  PricingPackageModel? get selectedPackage => _selectedPackage;
  PricingCategoryModel? get selectedCategory => _selectedCategory;

  // Applies the selected pricing category without mutating the full package list.
  List<PricingPackageModel> get packagesByCategory {
    if (_selectedCategory == null) return _packages;
    return _packages
        .where((pkg) => pkg.pricingCategoryId == _selectedCategory!.id)
        .toList();
  }

  // Loads categories and packages together for pricing screens.
  Future<void> init() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await Future.wait([fetchCategories(), fetchPackages()]);
      _mergeCategoriesFromPackages();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetches pricing categories used by package filters.
  Future<void> fetchCategories() async {
    try {
      final res = await ApiClient.instance.getPricingCategories();
      _categories = (res as List)
          .map(
            (e) => PricingCategoryModel.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList();
      notifyListeners();
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load pricing categories: $e';
      notifyListeners();
    }
  }

  // Fetches all pricing packages.
  Future<void> fetchPackages() async {
    try {
      final res = await ApiClient.instance.getPricingPackages();
      _packages = (res as List)
          .map(
            (e) => PricingPackageModel.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList();
      _mergeCategoriesFromPackages();
      notifyListeners();
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load pricing packages: $e';
      notifyListeners();
    }
  }

  // Fetches one package for a potential package-details flow.
  Future<void> fetchPackageDetails(String slug) async {
    _isLoading = true;
    _error = null;
    _selectedPackage = null;
    notifyListeners();
    try {
      final res = await ApiClient.instance.getPricingPackageDetails(slug);
      _selectedPackage = PricingPackageModel.fromJson(
        Map<String, dynamic>.from(res as Map),
      );
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to load package details: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Stores the active pricing category filter.
  void selectCategory(PricingCategoryModel? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Removes the pricing category filter.
  void clearSelectedCategory() {
    _selectedCategory = null;
    notifyListeners();
  }

  // Uses package relation data as a fallback when the categories endpoint is empty.
  void _mergeCategoriesFromPackages() {
    if (_categories.isNotEmpty || _packages.isEmpty) return;

    final categoriesById = <int, PricingCategoryModel>{};
    for (final package in _packages) {
      final rawCategoryId = package.pricingCategory?['id'];
      final relatedCategoryId = rawCategoryId is num
          ? rawCategoryId.toInt()
          : int.tryParse(rawCategoryId?.toString() ?? '');
      final categoryId = package.pricingCategoryId ?? relatedCategoryId;
      if (categoryId == null || categoryId == 0) continue;

      final category = package.pricingCategory;
      categoriesById.putIfAbsent(
        categoryId,
        () => PricingCategoryModel(
          id: categoryId,
          name: category?['name']?.toString() ?? package.category,
          nameEn: category?['name_en']?.toString() ?? package.categoryEn,
          nameAr: category?['name_ar']?.toString() ?? package.categoryAr,
          slug: category?['slug']?.toString(),
          description: category?['description']?.toString(),
          descriptionEn: category?['description_en']?.toString(),
          descriptionAr: category?['description_ar']?.toString(),
        ),
      );
    }

    if (categoriesById.isNotEmpty) {
      _categories = categoriesById.values.toList();
    }
  }

  // Searches packages by name or description.
  List<PricingPackageModel> searchPackages(String query) {
    if (query.isEmpty) return _packages;
    final lowerQuery = query.toLowerCase();
    return _packages.where((pkg) {
      final name = pkg.name ?? pkg.nameEn ?? '';
      final description = pkg.description ?? pkg.descriptionEn ?? '';
      return name.toLowerCase().contains(lowerQuery) ||
          description.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
