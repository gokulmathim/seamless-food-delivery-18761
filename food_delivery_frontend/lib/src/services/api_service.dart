import 'dart:async';
import 'dart:math';

import '../models/menu_item.dart';
import '../models/order.dart';
import '../models/restaurant.dart';
import '../models/user.dart';

class ApiService {
  /// PUBLIC_INTERFACE
  /// Mock API service. Replace with real HTTP implementation in the future.
  ApiService._internal();
  static final ApiService _instance = ApiService._internal();
  // PUBLIC_INTERFACE
  factory ApiService() => _instance;

  final Random _rng = Random();

  Duration get _delay => Duration(milliseconds: 300 + _rng.nextInt(500));

  // PUBLIC_INTERFACE
  Future<List<Restaurant>> getRestaurants() async {
    await Future.delayed(_delay);
    return _sampleRestaurants;
  }

  // PUBLIC_INTERFACE
  Future<List<MenuItem>> getMenuForRestaurant(String restaurantId) async {
    await Future.delayed(_delay);
    return _sampleMenu.where((m) => m.restaurantId == restaurantId).toList();
  }

  // PUBLIC_INTERFACE
  Future<AppUser> login(String email, String password) async {
    await Future.delayed(_delay);
    return AppUser(id: 'u_${email.hashCode}', name: 'Foodie', email: email);
  }

  // PUBLIC_INTERFACE
  Future<AppUser> register(String name, String email, String password) async {
    await Future.delayed(_delay);
    return AppUser(id: 'u_${email.hashCode}', name: name, email: email);
  }

  // PUBLIC_INTERFACE
  Future<Order> placeOrder({
    required String restaurantId,
    required double subtotal,
    required double deliveryFee,
    required double tax,
    required double total,
  }) async {
    await Future.delayed(_delay);
    return Order(
      id: 'ord_${DateTime.now().millisecondsSinceEpoch}',
      restaurantId: restaurantId,
      items: const [],
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      tax: tax,
      total: total,
      status: OrderStatus.confirmed,
      createdAt: DateTime.now(),
      trackingEta: '30-40 min',
    );
  }

  // PUBLIC_INTERFACE
  Future<Order> getOrderStatus(String orderId) async {
    await Future.delayed(_delay);
    final statuses = OrderStatus.values;
    return Order(
      id: orderId,
      restaurantId: _sampleRestaurants.first.id,
      items: const [],
      subtotal: 0,
      deliveryFee: 0,
      tax: 0,
      total: 0,
      status: statuses[_rng.nextInt(statuses.length)],
      createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      trackingEta: '20-30 min',
    );
  }
}

// Sample data
final List<Restaurant> _sampleRestaurants = List<Restaurant>.generate(
  8,
  (i) => Restaurant(
    id: 'r$i',
    name: 'Tasty Place #$i',
    imageUrl: 'https://picsum.photos/seed/food$i/800/400',
    rating: 3.5 + (i % 3) * 0.5,
    address: '123 Main St, City',
    categories: ['Burgers', 'Pizza', 'Drinks']..shuffle(),
    minOrder: 10.0,
    deliveryTimeMin: 20 + i * 3,
  ),
);

final List<MenuItem> _sampleMenu = List<MenuItem>.generate(
  30,
  (i) => MenuItem(
    id: 'm$i',
    restaurantId: 'r${i % 5}',
    name: 'Dish #$i',
    description: 'A delicious dish number $i with fresh ingredients.',
    price: 6.5 + (i % 7) * 1.25,
    imageUrl: 'https://picsum.photos/seed/dish$i/600/400',
    tags: ['Spicy', 'Vegan', 'Gluten-free']..shuffle(),
    isPopular: i % 4 == 0,
  ),
);
