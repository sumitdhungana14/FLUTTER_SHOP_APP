import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/widgets/cart_item.dart' as ci;

class CartScreen extends StatelessWidget {
  static final routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<Cart>(context);
    final items = cartProvider.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart!'),
      ),
      body: Container(
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.all(10),
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total'),
                      Chip(label: Text('\$${cartProvider.total}')),
                      FlatButton(
                        onPressed: () {},
                        child: Text('Order Now'),
                        color: Colors.blue[100],
                      )
                    ]),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (_, index) => ci.CartItem(
                    id: items[index].id,
                    title: items[index].title,
                    price: items[index].price,
                    quantity: items[index].quantity),
                itemCount: cartProvider.items.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
