import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' show Orders;
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static final routeName = '/orders';
  
  @override
  Widget build(BuildContext context) {
    // final orders = Provider.of<Orders>(context).orders;

    return Scaffold(
        appBar: AppBar(title: Text('My Orders!')),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).getAndSetOrders(),
          builder: (ctx, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapShot.error != null) {
                //handle error
                return Center(
                  child: Text('An error occured'),
                );
              } else {
                return Consumer<Orders>(
                    builder: (_, orders, __) => ListView.builder(
                          itemBuilder: (_, i) => OrderItem(orders.orders[i]),
                          itemCount: orders.orders.length,
                        ));
              }
            }
          },
        ));
  }
}
