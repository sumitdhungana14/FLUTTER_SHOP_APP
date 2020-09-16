import 'package:flutter/material.dart';
import 'package:shop_app/providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  const OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool isExpanded = false;

  Widget buildTrailingIconButton(Icon icon, bool val) {
    return IconButton(
        onPressed: () {
          setState(() {
            isExpanded = val;
          });
        },
        icon: icon);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
          title: Text('\$${widget.order.amount}'),
          trailing: !isExpanded
              ? buildTrailingIconButton(Icon(Icons.expand_more), true)
              : buildTrailingIconButton(Icon(Icons.expand_less), false),
        ),
        if (isExpanded)
          Container(
            height: 150,
            child: ListView(
              children: widget.order.products
                  .map((prod) => ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Text(prod.quantity.toString()),
                        ),
                        title: Text(prod.title),
                        trailing: Text('\$${prod.price}'),
                      ))
                  .toList(),
            ),
          ),
      ]),
    );
  }
}
