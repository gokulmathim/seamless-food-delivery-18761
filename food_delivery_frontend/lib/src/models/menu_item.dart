class MenuItem {
  final String id;
  final String restaurantId;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final List<String> tags;
  final bool isPopular;

  MenuItem({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.tags,
    required this.isPopular,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
        id: json['id'] as String,
        restaurantId: json['restaurantId'] as String,
        name: json['name'] as String,
        description: json['description'] as String? ?? '',
        price: (json['price'] as num).toDouble(),
        imageUrl: json['imageUrl'] as String? ?? '',
        tags: (json['tags'] as List<dynamic>? ?? const <dynamic>[]).cast<String>(),
        isPopular: json['isPopular'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'restaurantId': restaurantId,
        'name': name,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'tags': tags,
        'isPopular': isPopular,
      };
}
