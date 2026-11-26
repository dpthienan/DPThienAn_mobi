import 'package:flutter/material.dart';
import '../models/models.dart';

class MyOrdersPage extends StatelessWidget {
  final OrderManager orderManager;

  const MyOrdersPage({super.key, required this.orderManager});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('My Orders', style: textTheme.headlineMedium),
      ),
      body: ListView.builder(
        itemCount: orderManager.totalOrders,
        itemBuilder: (context, index) {
          return OrderTile(order: orderManager.orders[index]);
        },
      ),
    );
  }
}

class OrderTile extends StatelessWidget {
  final Order order;

  const OrderTile({super.key, required this.order});

  Widget _orderImage(Order order) {
    final imageUrl = order.items.isEmpty ? '' : order.items.first.imageUrl;
    const fallback = 'assets/food/burger.webp';
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          fallback,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      );
    }
    return Image.asset(
      imageUrl.isEmpty ? fallback : imageUrl,
      width: 50,
      height: 50,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: _orderImage(order),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Scheduled',
            style: textTheme.bodyLarge,
          ),
          Text(order.getFormattedOrderInfo()),
          Text(
            order.items.isEmpty
                ? 'Items: 0'
                : order.items
                    .map((item) => '${item.name} x${item.quantity}')
                    .join(', '),
          ),
        ],
      ),
    );
  }
}