import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toku_store/features/dashboard/data/models/product_models.dart';

class FavoriteProvider extends ChangeNotifier {
  List<ProductModel> _favorites = [];

  List<ProductModel> get favorites => _favorites;

  // Constructor memanggil fungsi untuk memuat data saat aplikasi dibuka
  FavoriteProvider() {
    _loadFavorites();
  }

  bool isFavorite(ProductModel product) {
    return _favorites.any((p) => p.id == product.id);
  }

  void toggleFavorite(ProductModel product) {
    if (isFavorite(product)) {
      _favorites.removeWhere((p) => p.id == product.id);
    } else {
      _favorites.add(product);
    }
    
    _saveFavorites(); // Simpan setiap ada perubahan
    notifyListeners();
  }

  // ─── FUNGSI PENYIMPANAN LOCAL STORAGE ──────────────────────────

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    
    final List<Map<String, dynamic>> favList = _favorites.map((p) => {
      'id': p.id,
      'name': p.name,
      'price': p.price,
      'imageUrl': p.imageUrl,
      'category': p.category,
      'description': p.description,
      'stock': p.stock,
      'isActive': p.isActive,
    }).toList();
    
    await prefs.setString('saved_favorites_toku', jsonEncode(favList));
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? favString = prefs.getString('saved_favorites_toku');
      
      if (favString != null) {
        final List<dynamic> decodedData = jsonDecode(favString);
        
        _favorites = decodedData.map((item) => ProductModel(
          id: int.parse(item['id'].toString()), 
          name: item['name']?.toString() ?? '',
          price: double.parse((item['price'] ?? 0).toString()), 
          imageUrl: item['imageUrl']?.toString() ?? '',
          category: item['category']?.toString() ?? '',
          description: item['description']?.toString() ?? '',
          stock: int.parse((item['stock'] ?? 0).toString()), 
          isActive: item['isActive'] == true || item['isActive'] == 'true',
        )).toList();
        
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error memuat favorit: $e');
    }
  }
}