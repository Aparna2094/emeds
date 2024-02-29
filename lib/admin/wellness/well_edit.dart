import 'dart:convert';
import 'dart:typed_data';

import 'package:final_emeds/admin/wellness/database/wellness.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


// ignore: camel_case_types
class wellEditPage extends StatefulWidget {
  final Wellness product2;
  final String imagePath2;
  final Function(Wellness editedProduct) onEdit;

  const wellEditPage({
    required this.product2,
    required this.imagePath2,
    required this.onEdit,
    super.key,
  });

  @override
  State<wellEditPage> createState() => _wellEditPageState();
}

// ignore: camel_case_types
class _wellEditPageState extends State<wellEditPage> {
  late TextEditingController _wellnessNameController;
  late TextEditingController _wellnessPriceController;
  late TextEditingController _wellnessoriginController;
  late Uint8List imagePath2;

  @override
  void initState() {
    super.initState();
    _wellnessNameController =
        TextEditingController(text: widget.product2.proname);
    _wellnessPriceController =
        TextEditingController(text: widget.product2.proprice.toString());
    _wellnessoriginController =
        TextEditingController(text: widget.product2.countryOforigin);
    imagePath2 = base64Decode(widget.product2.image2);
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
              controller: _wellnessNameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _wellnessPriceController,
              decoration: const InputDecoration(labelText: 'Price'),
            ),
            TextFormField(
              controller: _wellnessoriginController,
              decoration: const InputDecoration(labelText: 'Country of origin'),
            ),
            SizedBox(
              height: 100,
              child: _buildImageWidget(),
            ),
            _buildSelectImageButton(),
            ElevatedButton(
              onPressed: () {
                Wellness editedProduct = Wellness(
                  proname: _wellnessNameController.text,
                  procategory: widget.product2.procategory,
                  proprice: _wellnessPriceController.text,
                  countryOforigin: _wellnessoriginController.text,
                  image2: base64Encode(imagePath2),
                  id3: widget.product2.id3,
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
      imagePath2,
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
        imagePath2 = Uint8List.fromList(await image.readAsBytes());
      });
    }
  }
}
