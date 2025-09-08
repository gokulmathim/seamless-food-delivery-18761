import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../services/api_service.dart';
import '../home/home_shell.dart';
import 'order_tracking_screen.dart';
import '../../widgets/ui_helpers.dart';

class CheckoutScreen extends StatefulWidget {
  static const routeName = '/checkout';
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _placing = false;
  final String _paymentMethod = 'Visa **** 4242'; // Placeholder
  bool _navigateToTracking = false;
  String? _nextOrderId;

  Future<void> _placeOrder() async {
    // Capture needed values before any await to avoid using context across async gaps
    final cart = context.read<CartProvider>();
    final hasItems = cart.items.isNotEmpty && cart.restaurantId != null;
    final restaurantId = cart.restaurantId;
    final subtotal = cart.subtotal;
    final deliveryFee = cart.deliveryFee;
    final tax = cart.tax;
    final total = cart.total;

    if (!hasItems || restaurantId == null) {
      // Safe to use context here since we haven't awaited yet
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add items to cart first')));
      return;
    }

    setState(() => _placing = true);
    try {
      // Capture providers before any await
      final orderProvider = context.read<OrderProvider>();

      final order = await ApiService().placeOrder(
        restaurantId: restaurantId,
        subtotal: subtotal,
        deliveryFee: deliveryFee,
        tax: tax,
        total: total,
      );

      // Update provider using the captured reference (no new context read)
      await orderProvider.setActiveOrder(order);

      // Clear cart safely; this uses the captured cart reference created before await
      cart.clear();

      // Mark navigation intent via state flags only (no context use across async)
      _nextOrderId = order.id;
      _navigateToTracking = true;
    } catch (e) {
      // Schedule error message in a post frame to avoid context across async gap
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to place order')));
      });
    } finally {
      if (mounted) {
        setState(() => _placing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final scheme = Theme.of(context).colorScheme;

    // Handle navigation after async via state flags to avoid using context across async gaps
    if (_navigateToTracking && _nextOrderId != null) {
      final orderId = _nextOrderId!;
      _navigateToTracking = false;
      _nextOrderId = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.of(context).pushNamedAndRemoveUntil(
          OrderTrackingScreen.routeName,
          (route) => route.settings.name == HomeShell.routeName,
          arguments: {'orderId': orderId},
        );
      });
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.bold, color: scheme.primary)),
          const SizedBox(height: 8),
          GlassCard(
            child: ListTile(
              title: const Text('123 Main St, City'),
              subtitle: Text('Estimated: ${cart.items.isEmpty ? '-' : '30-40 min'}'),
              trailing: TextButton(onPressed: () {}, child: const Text('Change')),
            ),
          ),
          const SizedBox(height: 16),
          Text('Payment', style: TextStyle(fontWeight: FontWeight.bold, color: scheme.primary)),
          const SizedBox(height: 8),
          GlassCard(
            child: ListTile(
              leading: const Icon(Icons.credit_card),
              title: Text(_paymentMethod),
              subtitle: const Text('Payment handled by backend. This is a placeholder.'),
              trailing: TextButton(onPressed: () {}, child: const Text('Manage')),
            ),
          ),
          const SizedBox(height: 16),
          Text('Summary', style: TextStyle(fontWeight: FontWeight.bold, color: scheme.primary)),
          const SizedBox(height: 8),
          GlassCard(
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
          AnimatedTap(
            onTap: _placing ? null : _placeOrder,
            child: FilledButton.icon(
              onPressed: _placing ? null : _placeOrder,
              icon: const Icon(Icons.check),
              label: Text(_placing ? 'Placing Order...' : 'Place Order'),
            ),
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
