import 'package:flutter/foundation.dart';

import '../models/restaurant.dart';
import '../services/api_service.dart';

class RestaurantProvider extends ChangeNotifier {
  final List<Restaurant> _restaurants = [];
  bool _loading = false;

  List<Restaurant> get restaurants => List.unmodifiable(_restaurants);
  bool get isLoading => _loading;

  // PUBLIC_INTERFACE
  Future<void> fetchRestaurants() async {
    if (_loading) return;
    _loading = true;
    notifyListeners();
    try {
      final data = await ApiService().getRestaurants();
      _restaurants
        ..clear()
        ..addAll(data);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
