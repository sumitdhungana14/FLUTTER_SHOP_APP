import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' show Orders;
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static final routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context).orders;

    return Scaffold(
        appBar: AppBar(title: Text('My Orders!')),
        drawer: AppDrawer(),
        body: ListView.builder(
          itemBuilder: (_, i) => OrderItem(orders[i]),
          itemCount: orders.length,
        ));
  }
}
