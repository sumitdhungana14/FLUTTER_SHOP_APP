import 'package:flutter/material.dart';
import 'package:shop_app/models/product.dart';

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
  final formKey = GlobalKey<FormState>();

  var newProduct = Product(
      id: DateTime.now().toString(),
      title: '',
      description: '',
      price: 0,
      imageUrl: '');

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
    if (!imageFocusNode.hasFocus) setState(() {});
  }

  void saveProduct() {
    var isValidated = formKey.currentState.validate();
    if (isValidated) formKey.currentState.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Product!'),
          actions: [IconButton(icon: Icon(Icons.save), onPressed: saveProduct)],
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: ListView(children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(priceFocusNode),
                onSaved: (value) => newProduct = Product(
                    id: newProduct.id,
                    title: value,
                    description: newProduct.description,
                    price: newProduct.price,
                    imageUrl: newProduct.imageUrl),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please input title.';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: priceFocusNode,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(descriptionFocusNode),
                onSaved: (value) => newProduct = Product(
                    id: newProduct.id,
                    title: newProduct.title,
                    description: newProduct.description,
                    price: double.parse(value),
                    imageUrl: newProduct.imageUrl),
                validator: (value) {
                  if (value.isEmpty) return 'Please enter price';
                  if (double.tryParse(value) == null) return 'Please provide a valid number';
                  if (double.parse(value) <= 0) return 'Price should have positive value';
  
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 4,
                keyboardType: TextInputType.multiline,
                focusNode: descriptionFocusNode,
                onSaved: (value) => newProduct = Product(
                    id: newProduct.id,
                    title: newProduct.title,
                    description: value,
                    price: newProduct.price,
                    imageUrl: newProduct.imageUrl),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a description.';
                  }
                  if (value.length < 10) {
                    return 'The description should be longer than 10 characters.';
                  }
                  return null;
                },
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
                    onChanged: (_) {
                      setState(() {});
                    },
                    onFieldSubmitted: (_) => saveProduct(),
                    focusNode: imageFocusNode,
                    onSaved: (value) => newProduct = Product(
                        id: newProduct.id,
                        title: newProduct.title,
                        description: newProduct.description,
                        price: newProduct.price,
                        imageUrl: value),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please provide an image URL.';
                      }
                      return null;
                    },
                  ),
                ),
              ])
            ]),
          ),
        ));
  }
}
