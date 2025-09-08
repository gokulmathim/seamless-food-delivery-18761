import 'package:flutter/foundation.dart';

import '../models/user.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  AppUser? _user;
  bool _isLoading = false;

  AppUser? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;

  Future<void> bootstrap() async {
    // Restore from storage if available
    final email = StorageService.email;
    final name = StorageService.name;
    if (email != null && name != null) {
      _user = AppUser(id: 'u_${email.hashCode}', name: name, email: email);
    }
    notifyListeners();
  }

  // PUBLIC_INTERFACE
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final user = await ApiService().login(email, password);
      _user = user;
      await StorageService.saveAuth('mock-token', user.email, user.name);
      return true;
    } catch (_) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // PUBLIC_INTERFACE
  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final user = await ApiService().register(name, email, password);
      _user = user;
      await StorageService.saveAuth('mock-token', user.email, user.name);
      return true;
    } catch (_) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // PUBLIC_INTERFACE
  Future<void> logout() async {
    _user = null;
    await StorageService.clearAuth();
    notifyListeners();
  }
}
