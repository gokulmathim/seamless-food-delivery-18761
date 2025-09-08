import 'package:flutter/foundation.dart';

import '../models/menu_item.dart';
import '../services/api_service.dart';

class MenuProvider extends ChangeNotifier {
  final Map<String, List<MenuItem>> _menus = {};
  bool _loading = false;

  bool get isLoading => _loading;

  List<MenuItem> menuFor(String restaurantId) => List.unmodifiable(_menus[restaurantId] ?? const []);

  // PUBLIC_INTERFACE
  Future<void> fetchMenu(String restaurantId) async {
    if (_loading) return;
    _loading = true;
    notifyListeners();
    try {
      final data = await ApiService().getMenuForRestaurant(restaurantId);
      _menus[restaurantId] = data;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
