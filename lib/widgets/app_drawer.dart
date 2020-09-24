import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('My Shop'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: FlatButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/');
                },
                child: Text('Shop')),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.layers),
            title: FlatButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/orders');
                },
                child: Text('Orders')),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: FlatButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/user-products');
                },
                child: Text('User Products')),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: FlatButton(
                onPressed: () {
                  Provider.of<Auth>(context, listen: false).logout();
                },
                child: Text('Logout')),
          ),
        ],
      ),
    );
  }
}
