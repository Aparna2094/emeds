import 'dart:convert';
import 'dart:typed_data';

import 'package:final_emeds/admin/medicine/database/product.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class EditPage extends StatefulWidget {
  final Product product;
  final String imagePath;
  final Function(Product editedProduct) onEdit;

  const EditPage({
    required this.product,
    required this.imagePath,
    required this.onEdit,
    super.key,
  });

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController _productNameController;
  late TextEditingController _productPriceController;
  late TextEditingController _productDisController;
  late Uint8List imagePath;

  @override
  void initState() {
    super.initState();
    _productNameController = TextEditingController(text: widget.product.name);
    _productPriceController =
        TextEditingController(text: widget.product.price.toString());
    _productDisController =
        TextEditingController(text: widget.product.description);
    imagePath = base64Decode(widget.product.image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _productNameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _productPriceController,
              decoration: const InputDecoration(labelText: 'Price'),
            ),
            TextFormField(
              controller: _productDisController,
              decoration:const  InputDecoration(labelText: 'Description'),
            ),
            SizedBox(
              height: 100,
              child: _buildImageWidget(),
            ),
            _buildSelectImageButton(),
            ElevatedButton(
              onPressed: () {
                Product editedProduct = Product(
                  name: _productNameController.text,
                  category: widget.product.category,
                  price: _productPriceController.text,
                  description: _productDisController.text,
                  image: base64Encode(imagePath),
                  id: widget.product.id,
                );

                widget.onEdit(editedProduct);
                Navigator.pop(context);
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    return Image.memory(
      imagePath,
      fit: BoxFit.cover,
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
        return const Text('Error loading image');
      },
    );
  }

  Widget _buildSelectImageButton() {
    return ElevatedButton(
      onPressed: _selectImage,
      child: const Text('Select Image from Gallery'),
    );
  }

  Future<void> _selectImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() async {
        imagePath = Uint8List.fromList(await image.readAsBytes());
      });
    }
  }
}
