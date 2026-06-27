import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toku_store/features/dashboard/data/models/product_models.dart'; 

class FavoriteProvider extends ChangeNotifier {
  List<ProductModel> _favorites = [];

  List<ProductModel> get favorites => _favorites;

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
    
    _saveFavorites(); 
    notifyListeners();
  }

  // ─── FUNGSI PENYIMPANAN LOCAL STORAGE ──────────────────────────

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Menambahkan 'stock' dan 'isActive' saat menyimpan ke memori HP
    final List<Map<String, dynamic>> favList = _favorites.map((p) => {
      'id': p.id,
      'name': p.name,
      'price': p.price,
      'imageUrl': p.imageUrl,
      'category': p.category,
      'description': p.description,
      'stock': p.stock,       // DITAMBAHKAN
      'isActive': p.isActive, // DITAMBAHKAN
    }).toList();
    
    await prefs.setString('saved_favorites_toku', jsonEncode(favList));
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    
    final String? favString = prefs.getString('saved_favorites_toku');
    
    if (favString != null) {
      final List<dynamic> decodedData = jsonDecode(favString);
      
      _favorites = decodedData.map((item) => ProductModel(
        id: item['id'], 
        name: item['name'] ?? '',
        price: (item['price'] ?? 0).toDouble(),
        imageUrl: item['imageUrl'] ?? '',
        category: item['category'] ?? '',
        description: item['description'] ?? '',
        // Membaca kembali 'stock' dan 'isActive' dari memori HP
        // Memberikan nilai default 0 dan true jika datanya kosong
        stock: item['stock'] ?? 0,          // DITAMBAHKAN
        isActive: item['isActive'] ?? true, // DITAMBAHKAN
      )).toList();
      
      notifyListeners();
    }
  }
}