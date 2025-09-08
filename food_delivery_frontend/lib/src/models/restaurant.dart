class Restaurant {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final String address;
  final List<String> categories;
  final double minOrder;
  final int deliveryTimeMin;

  Restaurant({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.address,
    required this.categories,
    required this.minOrder,
    required this.deliveryTimeMin,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json['id'] as String,
        name: json['name'] as String,
        imageUrl: json['imageUrl'] as String,
        rating: (json['rating'] as num).toDouble(),
        address: json['address'] as String,
        categories: (json['categories'] as List<dynamic>).cast<String>(),
        minOrder: (json['minOrder'] as num).toDouble(),
        deliveryTimeMin: json['deliveryTimeMin'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
        'rating': rating,
        'address': address,
        'categories': categories,
        'minOrder': minOrder,
        'deliveryTimeMin': deliveryTimeMin,
      };
}
