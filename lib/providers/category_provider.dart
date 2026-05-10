import 'package:flutter/material.dart';
import 'package:rincongaditano/models/category.dart';
import 'package:rincongaditano/models/response_api.dart';
import 'package:rincongaditano/services/category_service.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryService _categoryService;
  String? _token;

  List<Category> _categories = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  CategoryProvider(this._categoryService, this._token);

  void updateToken(String? newToken) {
    _token = newToken;
  }

  bool _isNotAuthorized() {
    if (_token == null || _token!.isEmpty) {
      _errorMessage = 'No tienes permisos o la sesión ha caducado';
      notifyListeners();
      return true;
    }
    return false;
  }

  // get all
  Future<void> getAllCategories() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      ResponseApi response = await _categoryService.getAllCategories();

      if (response.success && response.data != null) {
        List<dynamic> data = response.data;
        _categories = data.map((item) => Category.fromJson(item)).toList();
      } else {
        _errorMessage = response.message;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // create
  Future<void> createCategory(String name, String image) async {
    if (_isNotAuthorized()) return;

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      ResponseApi response = await _categoryService.createCategory(
        _token!,
        name,
        image,
      );

      if (response.success) {
        await getAllCategories();
      } else {
        _errorMessage = response.message;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // update
  Future<void> updateCategory(int id, String name, String image) async {
    if (_isNotAuthorized()) return;

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      ResponseApi response = await _categoryService.updateCategory(
        id,
        _token!,
        name,
        image,
      );

      if (response.success) {
        await getAllCategories();
      } else {
        _errorMessage = response.message;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // delete
  Future<void> deleteCategory(int id) async {
    if (_isNotAuthorized()) return;

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      ResponseApi response = await _categoryService.deleteCategory(id, _token!);

      if (response.success) {
        await getAllCategories();
      } else {
        _errorMessage = response.message;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
