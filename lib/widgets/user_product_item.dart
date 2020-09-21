import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;

  const UserProductItem(this.title, this.imageUrl, this.id);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(children: [
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () async {
              try {
                await Provider.of<Products>(context, listen: false)
                    .deleteProduct(id);
              } catch (err) {
                scaffold.showSnackBar(SnackBar(
                  content: Text('Deleting failed'),
                ));
              }
            },
          ),
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.purple,
            ),
            onPressed: () => Navigator.of(context)
                .pushNamed('/edit-products', arguments: id),
          )
        ]),
      ),
    );
  }
}
