import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  /// Provides a thin wrapper around SharedPreferences for auth/order persistence.
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static const _keyAuthToken = 'auth_token';
  static const _keyUserEmail = 'user_email';
  static const _keyUserName = 'user_name';
  static const _keyActiveOrderId = 'active_order_id';

  static Future<void> saveAuth(String token, String email, String name) async {
    await _prefs.setString(_keyAuthToken, token);
    await _prefs.setString(_keyUserEmail, email);
    await _prefs.setString(_keyUserName, name);
  }

  static String? get token => _prefs.getString(_keyAuthToken);
  static String? get email => _prefs.getString(_keyUserEmail);
  static String? get name => _prefs.getString(_keyUserName);

  static Future<void> clearAuth() async {
    await _prefs.remove(_keyAuthToken);
    await _prefs.remove(_keyUserEmail);
    await _prefs.remove(_keyUserName);
  }

  static Future<void> setActiveOrderId(String orderId) => _prefs.setString(_keyActiveOrderId, orderId);
  static String? get activeOrderId => _prefs.getString(_keyActiveOrderId);
  static Future<void> clearActiveOrderId() => _prefs.remove(_keyActiveOrderId);
}
