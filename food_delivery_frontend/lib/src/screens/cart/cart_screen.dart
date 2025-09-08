import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../order/checkout_screen.dart';
import '../../widgets/ui_helpers.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.items;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: items.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemBuilder: (_, i) {
                      final c = items[i];
                      return GlassCard(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: scheme.secondary.withAlpha(40),
                            foregroundColor: scheme.secondary,
                            child: Text(c.quantity.toString()),
                          ),
                          title: Text(c.item.name),
                          subtitle: Text('\$${c.item.price.toStringAsFixed(2)} each'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedTap(
                                onTap: () => cart.changeQty(c.item.id, c.quantity - 1),
                                child: const Icon(Icons.remove_circle_outline),
                              ),
                              const SizedBox(width: 6),
                              AnimatedTap(
                                onTap: () => cart.changeQty(c.item.id, c.quantity + 1),
                                child: Icon(Icons.add_circle, color: scheme.primary),
                              ),
                              const SizedBox(width: 6),
                              AnimatedTap(
                                onTap: () => cart.removeFromCart(c.item.id),
                                child: const Icon(Icons.delete_outline),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemCount: items.length,
                  ),
                ),
                GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: _Totals(subtotal: cart.subtotal, delivery: cart.deliveryFee, tax: cart.tax, total: cart.total),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: AnimatedTap(
                    onTap: () => Navigator.of(context).pushNamed(CheckoutScreen.routeName),
                    child: FilledButton.icon(
                      onPressed: () => Navigator.of(context).pushNamed(CheckoutScreen.routeName),
                      icon: const Icon(Icons.lock),
                      label: const Text('Proceed to Checkout'),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _Totals extends StatelessWidget {
  final double subtotal;
  final double delivery;
  final double tax;
  final double total;

  const _Totals({
    required this.subtotal,
    required this.delivery,
    required this.tax,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Text rowText(String label, double val, {bool bold = false}) => Text(
          '$label: \$${val.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            fontSize: bold ? 16 : 14,
            color: bold ? scheme.primary : null,
          ),
        );

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      rowText('Subtotal', subtotal),
      rowText('Delivery', delivery),
      rowText('Tax', tax),
      const Divider(),
      rowText('Total', total, bold: true),
    ]);
  }
}
