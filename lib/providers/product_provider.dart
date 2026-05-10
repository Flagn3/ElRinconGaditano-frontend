import 'package:flutter/material.dart';
import 'package:rincongaditano/models/product.dart';
import 'package:rincongaditano/models/response_api.dart';
import 'package:rincongaditano/services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService;
  String? _token;

  List<Product> _products = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  ProductProvider(this._productService, this._token);

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

  //get available (public)
  Future<void> getAvailableProducts() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      ResponseApi response = await _productService.getAvailable();

      if (response.success && response.data != null) {
        List<dynamic> data = response.data;
        _products = data.map((item) => Product.fromJson(item)).toList();
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

  //get available by category (public)
  Future<void> getAvailableByCategory(String category) async {
    _errorMessage = '';
    _isLoading = true;
    notifyListeners();

    try {
      ResponseApi response = await _productService.getAvailableByCategory(
        category,
      );
      if (response.success && response.data != null) {
        List<dynamic> data = response.data;
        _products = data.map((item) => Product.fromJson(item)).toList();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //get all (admin)
  Future<void> getAllProducts() async {
    if (_isNotAuthorized()) return;

    _errorMessage = '';
    _isLoading = true;
    notifyListeners();

    try {
      ResponseApi response = await _productService.getAllProducts(_token!);

      if (response.success && response.data != null) {
        List<dynamic> data = response.data;
        _products = data.map((item) => Product.fromJson(item)).toList();
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

  //get all by category (admin)
  Future<void> getAllByCategory(String category) async {
    if (_isNotAuthorized()) return;

    _errorMessage = '';
    _isLoading = true;
    notifyListeners();

    try {
      ResponseApi response = await _productService.getAllByCategory(
        category,
        _token!,
      );

      if (response.success && response.data != null) {
        List<dynamic> data = response.data;
        _products = data.map((item) => Product.fromJson(item)).toList();
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

  //create product
  Future<void> createProduct(
    String name,
    String description,
    double price,
    bool available,
    int categoryId,
    String image,
  ) async {
    if (_isNotAuthorized()) return;

    _errorMessage = '';
    _isLoading = true;
    notifyListeners();

    try {
      ResponseApi response = await _productService.create(
        _token!,
        name,
        description,
        price,
        available,
        categoryId,
        image,
      );

      if (response.success) {
        await getAllProducts();
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

  //delete product
  Future<void> deleteProduct(int id) async {
    if (_isNotAuthorized()) return;

    _errorMessage = '';
    _isLoading = true;
    notifyListeners();

    try {
      ResponseApi response = await _productService.delete(id, _token!);

      if (response.success) {
        await getAllProducts();
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

  //switch available
  Future<void> switchAvailable(int id) async {
    if (_isNotAuthorized()) return;

    _errorMessage = '';
    _isLoading = true;
    notifyListeners();

    try {
      ResponseApi response = await _productService.switchAvailable(id, _token!);

      if (response.success) {
        await getAllProducts();
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

  //update product
  Future<void> updateproduct(
    int id,
    String name,
    String description,
    double price,
    bool available,
    int categoryId,
  ) async {
    if (_isNotAuthorized()) return;

    _errorMessage = '';
    _isLoading = true;
    notifyListeners();

    try {
      ResponseApi response = await _productService.update(
        id,
        _token!,
        name,
        description,
        price,
        available,
        categoryId,
      );

      if (response.success) {
        await getAllProducts();
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
