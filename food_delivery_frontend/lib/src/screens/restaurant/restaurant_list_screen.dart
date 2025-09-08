import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/restaurant.dart';
import '../../providers/restaurant_provider.dart';
import '../restaurant/restaurant_detail_screen.dart';
import '../../widgets/ui_helpers.dart';

class RestaurantListScreen extends StatelessWidget {
  const RestaurantListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RestaurantProvider>();
    final restaurants = provider.restaurants;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover'),
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.fetchRestaurants(),
        child: provider.isLoading && restaurants.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                padding: const EdgeInsets.all(12),
                itemBuilder: (_, i) => _RestaurantCard(restaurant: restaurants[i]),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: restaurants.length,
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => provider.fetchRestaurants(),
        backgroundColor: scheme.tertiary,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  const _RestaurantCard({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnimatedTap(
      onTap: () => Navigator.of(context).pushNamed(
        RestaurantDetailScreen.routeName,
        arguments: {'restaurantId': restaurant.id},
      ),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FoodImage(url: restaurant.imageUrl, aspectRatio: 16 / 9, borderRadius: 12),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        restaurant.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        restaurant.categories.take(3).join(' • '),
                        style: TextStyle(color: scheme.onSurface.withAlpha(160)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${restaurant.deliveryTimeMin}-${restaurant.deliveryTimeMin + 10} min • Min \$${restaurant.minOrder.toStringAsFixed(0)}',
                        style: TextStyle(color: scheme.onSurface.withAlpha(140)),
                      )
                    ]),
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(restaurant.rating.toStringAsFixed(1)),
                    avatar: const Icon(Icons.star, size: 16, color: Colors.amber),
                    backgroundColor: scheme.secondary.withAlpha(40),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
