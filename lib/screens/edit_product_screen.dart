import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  static final routeName = '/edit-products';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final priceFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();

  @override
  void dispose() {
    priceFocusNode.dispose();
    descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Product!'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            child: ListView(children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(priceFocusNode),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: priceFocusNode,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(descriptionFocusNode),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 4,
                keyboardType: TextInputType.multiline,
                focusNode: descriptionFocusNode,
              ),
            ]),
          ),
        ));
  }
}
