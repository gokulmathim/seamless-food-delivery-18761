import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/order.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class OrderProvider extends ChangeNotifier {
  Order? _activeOrder;
  Timer? _pollTimer;

  Order? get activeOrder => _activeOrder;
  bool get hasActiveOrder => _activeOrder != null;

  void _startPolling() {
    _pollTimer?.cancel();
    if (_activeOrder == null) return;
    _pollTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      final id = _activeOrder!.id;
      final status = await ApiService().getOrderStatus(id);
      _activeOrder = _activeOrder!.copyWith(status: status.status, trackingEta: status.trackingEta);
      notifyListeners();
      if (_activeOrder!.status == OrderStatus.delivered || _activeOrder!.status == OrderStatus.cancelled) {
        await clearActiveOrder();
      }
    });
  }

  // PUBLIC_INTERFACE
  Future<void> loadActiveOrder() async {
    final id = StorageService.activeOrderId;
    if (id == null) return;
    _activeOrder = await ApiService().getOrderStatus(id);
    notifyListeners();
    _startPolling();
  }

  // PUBLIC_INTERFACE
  Future<void> setActiveOrder(Order order) async {
    _activeOrder = order;
    await StorageService.setActiveOrderId(order.id);
    notifyListeners();
    _startPolling();
  }

  // PUBLIC_INTERFACE
  Future<void> clearActiveOrder() async {
    _pollTimer?.cancel();
    _pollTimer = null;
    _activeOrder = null;
    await StorageService.clearActiveOrderId();
    notifyListeners();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }
}
