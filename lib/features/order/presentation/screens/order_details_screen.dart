import 'package:crafty_bay/app/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/presentation/widgets/centered_progress_indicator.dart';
import '../providers/order_provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key, required this.orderId});

  static const String name = '/order-details-screen';

  final String orderId;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().getOrderDetails(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, _) {
          if (orderProvider.isLoading) {
            return const CenteredProcessIndicator();
          }

          final order = orderProvider.selectedOrder;
          if (order == null) {
            return const Center(child: Text('Order not found'));
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order ID: ${order.id}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Status: ${order.status.toUpperCase()}'),
                Text('Payment Method: ${order.paymentMethod.toUpperCase()}'),
                Text('Total Amount: ${Constants.takaSign}${order.totalAmount}'),
                const SizedBox(height: 16),
                if (order.shippingAddress != null) ...[
                  const Text(
                    'Shipping Address:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Name: ${order.shippingAddress!['full_name'] ?? ''}'),
                  Text('Address: ${order.shippingAddress!['address'] ?? ''}'),
                  Text('City: ${order.shippingAddress!['city'] ?? ''}'),
                  Text('Phone: ${order.shippingAddress!['phone'] ?? ''}'),
                ],
                const Spacer(),
                if (order.status != 'canceled')
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: orderProvider.isActionLoading
                          ? null
                          : () async {
                              final success = await orderProvider
                                  .cancelOrder(order.id);
                              if (success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Order canceled successfully'),
                                  ),
                                );
                                Navigator.pop(context);
                              }
                            },
                      child: orderProvider.isActionLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Cancel Order'),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
