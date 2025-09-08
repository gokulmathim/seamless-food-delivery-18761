import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/order.dart';
import '../../providers/order_provider.dart';

class OrderTrackingScreen extends StatelessWidget {
  static const routeName = '/order-tracking';
  final String? orderId;
  const OrderTrackingScreen({super.key, this.orderId});

  String _statusLabel(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.onTheWay:
        return 'On the way';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderProvider>();
    final order = provider.activeOrder;

    return Scaffold(
      appBar: AppBar(title: const Text('Order Tracking')),
      body: order == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No active orders.\nYour updates will appear here after checkout.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withAlpha(180)),
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.receipt_long),
                      title: Text('Order ${order.id}'),
                      subtitle: Text('ETA: ${order.trackingEta ?? '-'}'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _StatusStepper(status: order.status, labelBuilder: _statusLabel),
                  const Spacer(),
                  if (order.status == OrderStatus.delivered || order.status == OrderStatus.cancelled)
                    FilledButton(
                      onPressed: () => provider.clearActiveOrder(),
                      child: const Text('Clear'),
                    ),
                ],
              ),
            ),
    );
  }
}

class _StatusStepper extends StatelessWidget {
  final OrderStatus status;
  final String Function(OrderStatus) labelBuilder;
  const _StatusStepper({required this.status, required this.labelBuilder});

  int _indexFor(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending:
        return 0;
      case OrderStatus.confirmed:
        return 1;
      case OrderStatus.preparing:
        return 2;
      case OrderStatus.onTheWay:
        return 3;
      case OrderStatus.delivered:
        return 4;
      case OrderStatus.cancelled:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      OrderStatus.pending,
      OrderStatus.confirmed,
      OrderStatus.preparing,
      OrderStatus.onTheWay,
      OrderStatus.delivered,
    ];
    final current = _indexFor(status);
    return Stepper(
      physics: const ClampingScrollPhysics(),
      currentStep: current,
      controlsBuilder: (ctx, details) => const SizedBox.shrink(),
      steps: steps
          .map((s) => Step(
                title: Text(labelBuilder(s)),
                content: const SizedBox.shrink(),
                isActive: _indexFor(s) <= current,
                state: _indexFor(s) < current ? StepState.complete : StepState.indexed,
              ))
          .toList(),
    );
  }
}
