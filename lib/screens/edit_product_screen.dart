import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  static final routeName = '/edit-products';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final priceFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();
  final imageFocusNode = FocusNode();
  final imageFieldController = TextEditingController();

  @override
  void initState() {
    imageFocusNode.addListener(updateImageContainer);
    super.initState();
  }

  @override
  void dispose() {
    priceFocusNode.dispose();
    descriptionFocusNode.dispose();
    imageFieldController.dispose();
    imageFocusNode.removeListener(updateImageContainer);
    super.dispose();
  }

  void updateImageContainer() {
    if(!imageFocusNode.hasFocus) setState(() {});
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
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Container(
                  margin: EdgeInsets.only(top: 8, right: 10),
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green[100], width: 2),
                  ),
                  child: imageFieldController.text.isEmpty
                      ? Text('Enter URL')
                      : Image.network(imageFieldController.text,
                          fit: BoxFit.cover),
                ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Image URL'),
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    controller: imageFieldController,
                    onFieldSubmitted: (_) {
                      setState(() {});
                    },
                    focusNode: imageFocusNode,
                  ),
                ),
              ])
            ]),
          ),
        ));
  }
}
