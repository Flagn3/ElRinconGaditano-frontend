import 'package:flutter/material.dart';
import 'package:rincongaditano/models/order.dart';
import 'package:rincongaditano/models/response_api.dart';
import 'package:rincongaditano/services/order_service.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService _orderService;
  String? _token;

  List<Order> _orders = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  OrderProvider(this._orderService, this._token);

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

  // post create (bool to empty the char if true)
  Future<bool> createOrder(int userId, List<Map<String, dynamic>> items) async {
    if (_isNotAuthorized()) return false;

    _errorMessage = '';
    _isLoading = true;
    notifyListeners();

    try {
      ResponseApi response = await _orderService.createOrder(
        userId,
        items,
        _token!,
      );

      if (response.success) {
        return true;
      } else {
        _errorMessage = response.message;
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // get all
  Future<void> getAllOrders() async {
    if (_isNotAuthorized()) return;

    _errorMessage = '';
    _isLoading = true;
    notifyListeners();

    try {
      ResponseApi response = await _orderService.getAllOrders(_token!);

      if (response.success && response.data != null) {
        List<dynamic> data = response.data;
        _orders = data.map((item) => Order.fromJson(item)).toList();
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

  // get by userId
  Future<void> getOrdersByUser(int userId) async {
    if (_isNotAuthorized()) return;

    _errorMessage = '';
    _isLoading = true;
    notifyListeners();

    try {
      ResponseApi response = await _orderService.getOrdersByUser(
        userId,
        _token!,
      );

      if (response.success && response.data != null) {
        List<dynamic> data = response.data;
        _orders = data.map((item) => Order.fromJson(item)).toList();
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

  // get by id
  Future<Order?> getOrderById(int id) async {
    if (_isNotAuthorized()) return null;

    _errorMessage = '';
    _isLoading = true;
    notifyListeners();

    try {
      ResponseApi response = await _orderService.getOrderById(id, _token!);

      if (response.success && response.data != null) {
        return Order.fromJson(response.data);
      } else {
        _errorMessage = response.message;
        return null;
      }
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //get by status
  Future<void> getOrdersByStatus(String status) async {
    if (_isNotAuthorized()) return;

    _errorMessage = '';
    _isLoading = true;
    notifyListeners();

    try {
      ResponseApi response = await _orderService.getOrdersByStatus(
        status,
        _token!,
      );

      if (response.success && response.data != null) {
        List<dynamic> data = response.data;
        _orders = data.map((item) => Order.fromJson(item)).toList();
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

  // update status
  Future<void> updateOrderStatus(int id, String status) async {
    if (_isNotAuthorized()) return;

    _errorMessage = '';
    _isLoading = true;
    notifyListeners();

    try {
      ResponseApi response = await _orderService.updateStatus(
        id,
        status,
        _token!,
      );

      if (response.success) {
        await getAllOrders();
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

  //cancel order
  Future<void> cancelOrder(int id, int userId) async {
    if (_isNotAuthorized()) return;

    _errorMessage = '';
    _isLoading = true;
    notifyListeners();

    try {
      ResponseApi response = await _orderService.cancelOrder(id, _token!);

      if (response.success) {
        await getOrdersByUser(userId);
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
