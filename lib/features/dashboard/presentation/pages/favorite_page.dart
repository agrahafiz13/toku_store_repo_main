import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toku_store/core/constants/api_colors.dart';
import 'package:toku_store/core/providers/favorite_provider.dart';
import 'package:toku_store/features/cart/presentation/providers/cart_provider.dart';
import 'package:toku_store/features/dashboard/data/models/product_models.dart';
class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  // Fungsi format harga yang sama persis seperti di DashboardPage
  String _formatPrice(double price) {
    final str = price.toInt().toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
      count++;
    }
    return 'Rp. ${buffer.toString().split('').reversed.join()}';
  }

  // Fungsi untuk memunculkan Bottom Sheet Add to Cart
  void _showAddToCartSheet(BuildContext context, ProductModel p) {
    int qty = 1;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setState) {
          final primary = Theme.of(context).colorScheme.primary;
          final cartProv = context.watch<CartProvider>();

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              top: 16,
              left: 20,
              right: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: p.imageUrl.isNotEmpty
                          ? Image.network(p.imageUrl, width: 70, height: 70, fit: BoxFit.cover)
                          : Container(width: 70, height: 70, color: Colors.grey.shade200),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _formatPrice(p.price), // Menggunakan fungsi lokal
                            style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Jumlah', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (qty > 1) setState(() => qty--);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.remove, color: primary),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            '$qty',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => qty++),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.add, color: primary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: cartProv.isAdding
                        ? const SizedBox.shrink()
                        : const Icon(Icons.shopping_cart_outlined, size: 20),
                    label: cartProv.isAdding
                        ? const SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text(
                            'Tambah ke Keranjang',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                    onPressed: cartProv.isAdding
                        ? null
                        : () async {
                            final success = await context.read<CartProvider>().addToCart(p.id, qty);
                            if (!context.mounted) return;
                            
                            Navigator.pop(context);
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  success ? '${p.name} ditambahkan ke keranjang' : 'Gagal menambahkan ke keranjang'
                                ),
                                // Mengubah AppColors.red menjadi AppColors.error
                                backgroundColor: success ? Colors.green : AppColors.error, 
                              ),
                            );
                          },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favProv = context.watch<FavoriteProvider>();
    final favorites = favProv.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Saya', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  const Text('Belum ada produk favorit', style: TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final p = favorites[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    onTap: () => _showAddToCartSheet(context, p),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: p.imageUrl.isNotEmpty
                          ? Image.network(p.imageUrl, width: 60, height: 60, fit: BoxFit.cover)
                          : Container(width: 60, height: 60, color: Colors.grey.shade200, child: const Icon(Icons.image_outlined)),
                    ),
                    title: Text(
                      p.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      _formatPrice(p.price), // Menggunakan fungsi lokal
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red), // Tetap pakai Colors.red bawaan Material
                      onPressed: () {
                        favProv.toggleFavorite(p);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${p.name} dihapus dari Favorit'), duration: const Duration(seconds: 1)),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}