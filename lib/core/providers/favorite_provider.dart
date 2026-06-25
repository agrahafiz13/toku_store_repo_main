import 'package:flutter/material.dart';
import 'package:toku_store/features/dashboard/data/models/product_models.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<ProductModel> _favorites = [];

  List<ProductModel> get favorites => _favorites;

  // Cek apakah produk sudah ada di favorit
  bool isFavorite(ProductModel product) {
    return _favorites.any((p) => p.id == product.id);
  }

  // Tambah atau Hapus dari favorit
  void toggleFavorite(ProductModel product) {
    if (isFavorite(product)) {
      _favorites.removeWhere((p) => p.id == product.id);
    } else {
      _favorites.add(product);
    }
    notifyListeners(); // Memperbarui UI secara otomatis
  }
}