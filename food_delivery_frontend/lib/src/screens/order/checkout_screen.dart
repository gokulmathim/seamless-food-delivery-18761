import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../services/api_service.dart';
import '../home/home_shell.dart';
import 'order_tracking_screen.dart';

class CheckoutScreen extends StatefulWidget {
  static const routeName = '/checkout';
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _placing = false;
  String _paymentMethod = 'Visa **** 4242'; // Placeholder

  Future<void> _placeOrder() async {
    final cart = context.read<CartProvider>();
    if (cart.items.isEmpty || cart.restaurantId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add items to cart first')));
      return;
    }
    setState(() => _placing = true);
    try {
      final order = await ApiService().placeOrder(
        restaurantId: cart.restaurantId!,
        subtotal: cart.subtotal,
        deliveryFee: cart.deliveryFee,
        tax: cart.tax,
        total: cart.total,
      );
      await context.read<OrderProvider>().setActiveOrder(order);
      cart.clear();
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        OrderTrackingScreen.routeName,
        (route) => route.settings.name == HomeShell.routeName,
        arguments: {'orderId': order.id},
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to place order')));
    } finally {
      if (mounted) setState(() => _placing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              title: const Text('123 Main St, City'),
              subtitle: Text('Estimated: ${cart.items.isEmpty ? '-' : '30-40 min'}'),
              trailing: TextButton(onPressed: () {}, child: const Text('Change')),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Payment', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.credit_card),
              title: Text(_paymentMethod),
              subtitle: const Text('Payment handled by backend. This is a placeholder.'),
              trailing: TextButton(onPressed: () {}, child: const Text('Manage')),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Summary', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                _row('Subtotal', cart.subtotal),
                _row('Delivery', cart.deliveryFee),
                _row('Tax', cart.tax),
                const Divider(),
                _row('Total', cart.total, bold: true),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _placing ? null : _placeOrder,
            icon: const Icon(Icons.check),
            label: Text(_placing ? 'Placing Order...' : 'Place Order'),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, double val, {bool bold = false}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          Text('\$${val.toStringAsFixed(2)}', style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        ],
      );
}
