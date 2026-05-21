import 'package:flutter/foundation.dart';
import '../core/api/api_client.dart';
import '../core/api/api_exception.dart';
import '../models/pricing_category_model.dart';
import '../models/pricing_package_model.dart';

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

  List<PricingPackageModel> get packagesByCategory {
    if (_selectedCategory == null) return _packages;
    return _packages
        .where((pkg) => pkg.pricingCategoryId == _selectedCategory!.id)
        .toList();
  }

  Future<void> init() async {
    await Future.wait([fetchCategories(), fetchPackages()]);
  }

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
      notifyListeners();
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load pricing packages: $e';
      notifyListeners();
    }
  }

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

  void selectCategory(PricingCategoryModel? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void clearSelectedCategory() {
    _selectedCategory = null;
    notifyListeners();
  }

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
