import 'package:flutter/foundation.dart';
import '../core/api/api_client.dart';
import '../core/api/api_exception.dart';
import '../models/project_model.dart';
import '../models/category_model.dart';

class ProjectsProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<ProjectModel> _projects = [];
  ProjectModel? _selectedProject;
  int _currentPage = 1;
  int _lastPage = 1;
  List<CategoryModel> _categories = [];
  CategoryModel? _selectedCategory;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<ProjectModel> get projects => _projects;
  ProjectModel? get selectedProject => _selectedProject;
  bool get hasMorePages => _currentPage < _lastPage;
  List<CategoryModel> get categories => _categories;
  CategoryModel? get selectedCategory => _selectedCategory;

  List<ProjectModel> get filteredProjects {
    if (_selectedCategory == null) return _projects;
    return _projects.where(_matchesSelectedCategory).toList();
  }

  bool _matchesSelectedCategory(ProjectModel project) {
    final selectedId = _selectedCategory!.id;

    if (project.categoryId != null) {
      return project.categoryId == selectedId;
    }
    if (project.category != null) {
      return project.category!.id == selectedId;
    }
    return project.categories?.any((c) => c.id == selectedId) ?? false;
  }

  Future<void> fetchProjects({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _projects = [];
    }
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await ApiClient.instance.getProjects();
      final data = res is List ? res : res['data'];
      final list = (data as List)
          .map(
            (e) => ProjectModel.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList();
      if (refresh) {
        _projects = list;
      } else {
        _projects = [..._projects, ...list];
      }
      if (res is Map) {
        final meta = res['meta'] is Map ? res['meta'] as Map : res;
        _currentPage = (meta['current_page'] as num?)?.toInt() ?? 1;
        _lastPage = (meta['last_page'] as num?)?.toInt() ?? 1;
      }
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to load projects: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCategories() async {
    try {
      final res = await ApiClient.instance.getProjectCategories();
      _categories = (res as List)
          .map(
            (e) => CategoryModel.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList();
      notifyListeners();
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load categories: $e';
      notifyListeners();
    }
  }

  void selectCategory(CategoryModel? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void clearCategory() {
    _selectedCategory = null;
    notifyListeners();
  }

  Future<void> fetchProjectDetails(String id) async {
    _isLoading = true;
    _error = null;
    _selectedProject = null;
    notifyListeners();
    try {
      final res = await ApiClient.instance.getProjectDetails(id);
      final data = res is Map && res['data'] is Map ? res['data'] : res;
      _selectedProject = ProjectModel.fromJson(
        Map<String, dynamic>.from(data as Map),
      );
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to load project details: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
