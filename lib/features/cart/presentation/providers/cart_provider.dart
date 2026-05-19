import 'package:flutter/material.dart';

import '../../data/models/cart_model.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../domain/repositories/cart_repository.dart';

enum CartStatus { initial, loading, loaded, error }

class CartProvider extends ChangeNotifier {
  final CartRepository _repository = CartRepositoryImpl();

  CartStatus _status = CartStatus.initial;

  CartModel? _cart;

  String? _error;

  bool _isAdding = false;

  CartStatus get status => _status;

  CartModel? get cart => _cart;

  String? get error => _error;

  bool get isAdding => _isAdding;

  int get itemCount => _cart?.itemCount ?? 0;

  Future<void> fetchCart() async {
    try {
      _status = CartStatus.loading;

      notifyListeners();

      _cart = await _repository.getCart();

      _status = CartStatus.loaded;

      notifyListeners();
    } catch (e) {
      _status = CartStatus.error;

      _error = e.toString();

      notifyListeners();
    }
  }

  Future<bool> addToCart(int productId, int quantity) async {
    _isAdding = true;

    notifyListeners();

    try {
      await _repository.addToCart(productId, quantity);

      await fetchCart();

      _isAdding = false;

      notifyListeners();

      return true;
    } catch (e) {
      _isAdding = false;

      notifyListeners();

      return false;
    }
  }

  Future<void> updateItem(int cartItemId, int quantity) async {
    try {
      await _repository.updateCartItem(cartItemId, quantity);

      await fetchCart();
    } catch (e) {
      _error = e.toString();

      notifyListeners();
    }
  }

  Future<void> removeItem(int cartItemId) async {
    try {
      await _repository.removeCartItem(cartItemId);

      await fetchCart();
    } catch (e) {
      _error = e.toString();

      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    try {
      await _repository.clearCart();

      _cart = const CartModel(items: [], total: 0, itemCount: 0);

      _status = CartStatus.loaded;

      notifyListeners();
    } catch (e) {
      _error = e.toString();

      notifyListeners();
    }
  }
}
