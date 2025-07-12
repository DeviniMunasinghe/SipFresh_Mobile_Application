class Item {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['item_id'] as int,
      name: json['item_name'] as String,
      description: json['item_description'] as String,
      imageUrl: json['item_image'] as String,
      price: double.tryParse(json['item_price'].toString()) ?? 0.0,
    );
  }
}
