
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
      id: json['item_id'],
      name: json['item_name'],
      description: json['item_description'],
      imageUrl: json['item_image'],
      price: double.parse(json['item_price']),
    );
  }
}
