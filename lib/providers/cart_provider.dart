import 'package:flutter/material.dart';
import 'package:rincongaditano/models/product.dart';
import 'package:rincongaditano/models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addProduct(Product product, {int quantity = 1}) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      final newQuantity = _items[index].quantity + quantity;
      _items[index].quantity = newQuantity.clamp(1, 30);
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void incrementQuantity(CartItem item) {
    if (item.quantity < 30) {
      item.quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(item);
    }
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.subtotal);
  double get deliveryCost => _items.isEmpty ? 0.0 : 2.50;
  double get total => subtotal + deliveryCost;
}
