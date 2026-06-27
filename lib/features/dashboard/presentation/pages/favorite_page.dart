import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toku_store/core/providers/favorite_provider.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Membaca data dari FavoriteProvider
    final favProv = context.watch<FavoriteProvider>();
    final favorites = favProv.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorite Saya',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum ada produk favorit',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
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
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: p.imageUrl.isNotEmpty
                          ? Image.network(
                              p.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.image_outlined),
                            ),
                    ),
                    title: Text(
                      p.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      'Rp. ${p.price.toInt()}',
                      style: const TextStyle(
                        color: Color(0xFFC61A2B),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {
                        // Menghapus dari favorit langsung dari halaman ini
                        favProv.toggleFavorite(p);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${p.name} dihapus dari Favorit'),
                            duration: const Duration(seconds: 1),
                          ),
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