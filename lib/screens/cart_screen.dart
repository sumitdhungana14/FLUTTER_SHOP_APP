import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/cart_item.dart' as ci;

class CartScreen extends StatefulWidget {
  static final routeName = "/cart";

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var isSubmitting = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<Cart>(context);
    final items = cartProvider.items.values.toList();
    final keys = cartProvider.items.keys.toList();

    return Scaffold(
      key: scaffoldKey,
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
                      Consumer<Orders>(
                        builder: (_, orders, __) => FlatButton(
                          onPressed: () async {
                            try {
                              setState(() {
                                isSubmitting = true;
                              });
                              await orders.addOrder(items, cartProvider.total);
                              cartProvider.clear();
                            } catch (err) {
                              scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text('Can\'t order at this moment!'),
                              ));
                            }
                            setState(() {
                              isSubmitting = false;
                            });
                          },
                          child: isSubmitting
                              ? Center(child: CircularProgressIndicator())
                              : Text('Order Now'),
                          color: Colors.blue[100],
                        ),
                      )
                    ]),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (_, index) => ci.CartItem(
                    id: items[index].id,
                    productId: keys[index],
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
