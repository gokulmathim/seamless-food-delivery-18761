import 'menu_item.dart';

class CartItem {
  final MenuItem item;
  final int quantity;
  final List<String> customizations;

  CartItem({
    required this.item,
    this.quantity = 1,
    this.customizations = const [],
  });

  double get total => item.price * quantity;

  CartItem copyWith({int? quantity, List<String>? customizations}) => CartItem(
        item: item,
        quantity: quantity ?? this.quantity,
        customizations: customizations ?? this.customizations,
      );
}
