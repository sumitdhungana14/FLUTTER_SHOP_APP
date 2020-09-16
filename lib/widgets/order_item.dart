import 'package:flutter/material.dart';
import 'package:shop_app/providers/orders.dart' as ord;

class OrderItem extends StatelessWidget {
  final ord.OrderItem order;

  const OrderItem(this.order);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
          title: Text('\$${order.amount}'),
          trailing: IconButton(onPressed: null, icon: Icon(Icons.expand_more)),
        )
      ]),
    );
  }
}
