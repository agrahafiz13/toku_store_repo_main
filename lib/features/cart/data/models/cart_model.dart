class CartProductModel {
  final int id;

  final String name;

  final String description;

  final double price;

  final int stock;

  final String imageUrl;

  final String category;

  final bool isActive;

  CartProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.category,
    required this.isActive,
  });

  factory CartProductModel.fromJson(Map<String, dynamic> json) {
    return CartProductModel(
      id: json['id'] as int? ?? 0,

      name: json['name'] as String? ?? '',

      description: json['description'] as String? ?? '',

      price: (json['price'] as num?)?.toDouble() ?? 0.0,

      stock: json['stock'] as int? ?? 0,

      imageUrl: json['image_url'] as String? ?? '',

      category: json['category'] as String? ?? '',

      isActive: json['is_active'] as bool? ?? false,
    );
  }
}

class CartItemModel {
  final int id;

  final int productId;

  final int quantity;

  final double subtotal;

  final CartProductModel product;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.subtotal,
    required this.product,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final product = CartProductModel.fromJson(
      json['product'] as Map<String, dynamic>? ?? {},
    );

    final quantity = json['quantity'] as int? ?? 0;

    final apiSubtotal = (json['subtotal'] as num?)?.toDouble() ?? 0.0;

    final subtotal = apiSubtotal > 0 ? apiSubtotal : product.price * quantity;

    return CartItemModel(
      id: json['id'] as int? ?? 0,

      productId: json['product_id'] as int? ?? 0,

      quantity: quantity,

      subtotal: subtotal,

      product: product,
    );
  }
}

class CartModel {
  final List<CartItemModel> items;

  final double total;

  final int itemCount;

  const CartModel({
    required this.items,
    required this.total,
    required this.itemCount,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List<dynamic>? ?? [])
        .map((e) => CartItemModel.fromJson(e))
        .toList();

    final total = items.fold<double>(0.0, (sum, item) => sum + item.subtotal);

    return CartModel(
      items: items,

      total: total,

      itemCount: json['item_count'] as int? ?? items.length,
    );
  }
}
