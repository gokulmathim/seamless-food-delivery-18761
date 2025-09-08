import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/menu_item.dart';
import '../../providers/cart_provider.dart';
import '../../providers/menu_provider.dart';
import '../../providers/restaurant_provider.dart';
import '../cart/cart_screen.dart';
import '../../widgets/ui_helpers.dart';

class RestaurantDetailScreen extends StatefulWidget {
  static const routeName = '/restaurant';
  final String restaurantId;
  const RestaurantDetailScreen({super.key, required this.restaurantId});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<MenuProvider>().fetchMenu(widget.restaurantId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = context
        .watch<RestaurantProvider>()
        .restaurants
        .firstWhere((r) => r.id == widget.restaurantId, orElse: () => throw Exception('Restaurant not found'));
    final menuProvider = context.watch<MenuProvider>();
    final menu = menuProvider.menuFor(widget.restaurantId);
    final isLoading = menuProvider.isLoading && menu.isEmpty;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(restaurant.name)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pushNamed(CartScreen.routeName),
        icon: const Icon(Icons.shopping_cart),
        label: const Text('Cart'),
        backgroundColor: scheme.secondary,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemBuilder: (_, i) => _MenuTile(menu[i]),
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemCount: menu.length,
            ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final MenuItem item;
  const _MenuTile(this.item);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GlassCard(
      child: ListTile(
        contentPadding: const EdgeInsets.only(right: 8, left: 8),
        leading: SizedBox(
          width: 64,
          child: FoodImage(url: item.imageUrl, aspectRatio: 1, borderRadius: 10),
        ),
        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(item.description, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            AnimatedTap(
              onTap: () {
                context.read<CartProvider>().addToCart(item);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('${item.name} added to cart'),
                  backgroundColor: scheme.primary,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 1),
                ));
              },
              child: Icon(Icons.add_circle, color: scheme.primary, size: 28),
            ),
          ],
        ),
      ),
    );
  }
}
