import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/widgets/badge.dart';

import '../widgets/products_grid.dart';

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavs = false;

  @override
  Widget build(BuildContext context) {
    int count = Provider.of<Cart>(context).count;

    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
              icon: Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 0) {
                  setState(() {
                    _showFavs = true;
                  });
                } else {
                  setState(() {
                    _showFavs = false;
                  });
                }
              },
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Favorites Only'),
                      value: 0,
                    ),
                    PopupMenuItem(
                      child: Text('All'),
                      value: 1,
                    )
                  ]),
          Badge(child: Icon(Icons.shopping_cart), value: count.toString())
        ],
      ),
      body: ProductsGrid(_showFavs),
    );
  }
}
