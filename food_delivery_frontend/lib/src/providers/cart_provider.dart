import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/menu_item.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  String? _restaurantId;

  List<CartItem> get items => List.unmodifiable(_items);
  String? get restaurantId => _restaurantId;

  double get subtotal => _items.fold(0.0, (s, e) => s + e.total);
  double get deliveryFee => _items.isEmpty ? 0.0 : 3.99;
  double get tax => subtotal * 0.08;
  double get total => subtotal + deliveryFee + tax;

  // PUBLIC_INTERFACE
  // PUBLIC_INTERFACE
  void addToCart(MenuItem item) {
    if (_restaurantId != null && _restaurantId != item.restaurantId) {
      // New restaurant: clear existing cart
      _items.clear();
    }
    _restaurantId = item.restaurantId;

    final idx = _items.indexWhere((c) => c.item.id == item.id);
    if (idx >= 0) {
      _items[idx] = _items[idx].copyWith(quantity: _items[idx].quantity + 1);
    } else {
      _items.add(CartItem(item: item, quantity: 1));
    }
    notifyListeners();
  }

  // PUBLIC_INTERFACE
  // PUBLIC_INTERFACE
  void removeFromCart(String menuItemId) {
    _items.removeWhere((c) => c.item.id == menuItemId);
    if (_items.isEmpty) _restaurantId = null;
    notifyListeners();
  }

  // PUBLIC_INTERFACE
  // PUBLIC_INTERFACE
  void changeQty(String menuItemId, int qty) {
    final idx = _items.indexWhere((c) => c.item.id == menuItemId);
    if (idx >= 0) {
      if (qty <= 0) {
        removeFromCart(menuItemId);
      } else {
        _items[idx] = _items[idx].copyWith(quantity: qty);
        notifyListeners();
      }
    }
  }

  // PUBLIC_INTERFACE
  // PUBLIC_INTERFACE
  void clear() {
    _items.clear();
    _restaurantId = null;
    notifyListeners();
  }
}
