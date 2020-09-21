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
                      OrderButton(
                          cartProvider: cartProvider,
                          items: items,
                          scaffoldKey: scaffoldKey)
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cartProvider,
    @required this.items,
    @required this.scaffoldKey,
  }) : super(key: key);

  final Cart cartProvider;
  final List<CartItem> items;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<Orders>(
      builder: (_, orders, __) => FlatButton(
        onPressed: (widget.cartProvider.total <= 0 || _isLoading)
            ? null
            : () async {
                try {
                  setState(() {
                    _isLoading = true;
                  });
                  await orders.addOrder(
                      widget.items, widget.cartProvider.total);
                  widget.cartProvider.clear();
                } catch (err) {
                  widget.scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text('Can\'t order at this moment!'),
                  ));
                }
                setState(() {
                  _isLoading = false;
                });
              },
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Text('Order Now'),
        color: Colors.blue[100],
      ),
    );
  }
}
