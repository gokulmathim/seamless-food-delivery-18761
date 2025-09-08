import 'package:flutter/material.dart';

import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_shell.dart';
import '../screens/restaurant/restaurant_detail_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/order/checkout_screen.dart';
import '../screens/order/order_tracking_screen.dart';
import '../screens/profile/profile_screen.dart';

class AppRouter {
  /// PUBLIC_INTERFACE
  /// The first route shown on app start. It decides whether to go to
  /// onboarding/login or straight to the home shell if user is authenticated.
  static const String initialRoute = OnboardingScreen.routeName;

  // PUBLIC_INTERFACE
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case OnboardingScreen.routeName:
        return _material(OnboardingScreen());
      case LoginScreen.routeName:
        return _material(const LoginScreen());
      case RegisterScreen.routeName:
        return _material(const RegisterScreen());
      case HomeShell.routeName:
        return _material(const HomeShell());
      case RestaurantDetailScreen.routeName:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final restaurantId = args['restaurantId'] as String? ?? '';
        return _material(RestaurantDetailScreen(restaurantId: restaurantId));
      case CartScreen.routeName:
        return _material(const CartScreen());
      case CheckoutScreen.routeName:
        return _material(const CheckoutScreen());
      case OrderTrackingScreen.routeName:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final orderId = args['orderId'] as String?;
        return _material(OrderTrackingScreen(orderId: orderId));
      case ProfileScreen.routeName:
        return _material(const ProfileScreen());
      default:
        return _material(Scaffold(
          appBar: AppBar(title: const Text('Not found')),
          body: Center(child: Text('Unknown route: ${settings.name}')),
        ));
    }
  }

  static MaterialPageRoute _material(Widget child) => MaterialPageRoute(builder: (_) => child);
}
