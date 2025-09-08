import 'cart_item.dart';

enum OrderStatus { pending, confirmed, preparing, onTheWay, delivered, cancelled }

class Order {
  final String id;
  final String restaurantId;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;
  final OrderStatus status;
  final DateTime createdAt;
  final String? trackingEta;

  Order({
    required this.id,
    required this.restaurantId,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
    required this.status,
    required this.createdAt,
    this.trackingEta,
  });

  Order copyWith({OrderStatus? status, String? trackingEta}) => Order(
        id: id,
        restaurantId: restaurantId,
        items: items,
        subtotal: subtotal,
        deliveryFee: deliveryFee,
        tax: tax,
        total: total,
        status: status ?? this.status,
        createdAt: createdAt,
        trackingEta: trackingEta ?? this.trackingEta,
      );
}
