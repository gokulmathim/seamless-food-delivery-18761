import 'package:flutter/material.dart';

import '../restaurant/restaurant_list_screen.dart';
import '../order/order_tracking_screen.dart';
import '../cart/cart_screen.dart';
import '../profile/profile_screen.dart';

class HomeShell extends StatefulWidget {
  static const routeName = '/home';
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  final List<Widget> _tabs = const [
    RestaurantListScreen(),
    OrderTrackingScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.restaurant_menu), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.delivery_dining), label: 'Orders'),
          NavigationDestination(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Account'),
        ],
        onDestinationSelected: (i) => setState(() => _index = i),
      ),
    );
  }
}
