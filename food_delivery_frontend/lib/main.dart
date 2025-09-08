import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'src/app_theme.dart';
import 'src/navigation/app_router.dart';
import 'src/providers/auth_provider.dart';
import 'src/providers/restaurant_provider.dart';
import 'src/providers/menu_provider.dart';
import 'src/providers/cart_provider.dart';
import 'src/providers/order_provider.dart';
import 'src/services/storage_service.dart';

/// PUBLIC_INTERFACE
/// Entry point for the Food Delivery Flutter application.
/// - Loads environment configuration from `.env` (optional).
/// - Initializes local storage used for simple auth/order persistence.
/// - Sets up app-wide state providers (Auth, Restaurants, Menu, Cart, Order).
/// - Applies theming and configures named-route navigation using AppRouter.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables (optional; file is declared in pubspec assets).
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // It's okay if .env doesn't exist in some environments; continue.
  }

  // Initialize simple local storage.
  await StorageService.init();

  runApp(const FoodDeliveryApp());
}

/// PUBLIC_INTERFACE
/// Root widget for the application. Provides global state and theming.
class FoodDeliveryApp extends StatefulWidget {
  const FoodDeliveryApp({super.key});

  @override
  State<FoodDeliveryApp> createState() => _FoodDeliveryAppState();
}

class _FoodDeliveryAppState extends State<FoodDeliveryApp> {
  bool _bootstrapped = false;

  @override
  void initState() {
    super.initState();
    // Perform lightweight bootstrap: restore auth and active order.
    // Note: Do not use BuildContext after await; only set primitive state.
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final auth = AuthProvider();
    await auth.bootstrap();
    final orderProvider = OrderProvider();
    await orderProvider.loadActiveOrder();

    // After await: only update simple state; providers are attached in build().
    setState(() {
      _bootstrapped = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Attach providers here so we don't use context across async gaps.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()..bootstrap()),
        ChangeNotifierProvider<RestaurantProvider>(create: (_) => RestaurantProvider()..fetchRestaurants()),
        ChangeNotifierProvider<MenuProvider>(create: (_) => MenuProvider()),
        ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
        ChangeNotifierProvider<OrderProvider>(create: (_) => OrderProvider()..loadActiveOrder()),
      ],
      child: MaterialApp(
        title: 'Seamless Food Delivery',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: AppRouter.initialRoute,
        onGenerateRoute: AppRouter.onGenerateRoute,
        // Simple splash while our minimal bootstrap runs; providers above will fetch data on demand.
        home: _bootstrapped ? null : const _SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: const [
          FlutterLogo(size: 72),
          SizedBox(height: 16),
          CircularProgressIndicator(),
        ]),
      ),
    );
  }
}
