import 'package:flutter/material.dart';

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
            title: FlatButton(onPressed: () {
              Navigator.of(context).pushReplacementNamed('/');
            }, child: Text('Shop')),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.layers),
            title: FlatButton(onPressed: (){
              Navigator.of(context).pushReplacementNamed('/orders');
            }, child: Text('Orders')),
          ),
        ],
      ),
    );
  }
}
