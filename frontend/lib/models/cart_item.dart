class CartItem {
  final int id; // ✅ Add this line
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;

  CartItem({
    required this.id, // ✅ Include in constructor
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  CartItem copyWith({
    int? id, // ✅ Allow override of id
    String? name,
    double? price,
    int? quantity,
    String? imageUrl,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
