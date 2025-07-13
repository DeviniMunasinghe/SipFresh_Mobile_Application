class CartItem {
  final int id;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;
  final bool isSelected;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    this.isSelected = true, // default: selected
  });

  CartItem copyWith({
    int? id,
    String? name,
    double? price,
    int? quantity,
    String? imageUrl,
    bool? isSelected,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
