import 'package:flutter/material.dart';

import 'package:toku_store/features/order/data/models/order_model.dart';

import 'package:toku_store/features/order/data/repositories/order_repository_impl.dart';

import 'package:toku_store/features/order/domain/repositories/order_repository.dart';

enum OrderStatus { initial, loading, success, error }

class OrderProvider extends ChangeNotifier {
  final OrderRepository _repository = OrderRepositoryImpl();

  OrderStatus _checkoutStatus = OrderStatus.initial;

  OrderModel? _lastOrder;

  List<OrderModel> _orders = [];

  String? _error;

  // ================= GETTERS =================

  OrderStatus get checkoutStatus => _checkoutStatus;

  OrderModel? get lastOrder => _lastOrder;

  List<OrderModel> get orders => _orders;

  String? get error => _error;

  // ================= PRIVATE HELPERS =================

  void _setLoading() {
    _checkoutStatus = OrderStatus.loading;

    _error = null;

    notifyListeners();
  }

  void _setError(String message) {
    _checkoutStatus = OrderStatus.error;

    _error = message;

    notifyListeners();
  }

  // ================= CHECKOUT =================

  Future<bool> checkout({
    required String shippingAddress,
    String? notes,
    required String paymentMethod,
  }) async {
    _setLoading();

    try {
      _lastOrder = await _repository.checkout(
        shippingAddress: shippingAddress,

        notes: notes,

        paymentMethod: paymentMethod,
      );

      _checkoutStatus = OrderStatus.success;

      notifyListeners();

      return true;
    } catch (e) {
      _setError('Gagal membuat pesanan');

      return false;
    }
  }

  // ================= FETCH MY ORDERS =================

  Future<void> fetchMyOrders({int page = 1, int limit = 10}) async {
    _setLoading();

    try {
      _orders = await _repository.getMyOrders(page: page, limit: limit);

      _checkoutStatus = OrderStatus.success;

      notifyListeners();
    } catch (e) {
      _setError('Gagal mengambil data pesanan');
    }
  }

  // ================= GET DETAIL =================

  Future<void> fetchOrderDetail(int orderId) async {
    _setLoading();

    try {
      _lastOrder = await _repository.getOrderDetail(orderId);

      _checkoutStatus = OrderStatus.success;

      notifyListeners();
    } catch (e) {
      _setError('Gagal mengambil detail pesanan');
    }
  }
}
