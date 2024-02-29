import 'dart:convert';
import 'dart:typed_data';

import 'package:final_emeds/admin/doctor/database/doctordata.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


// ignore: camel_case_types
class docEditPage extends StatefulWidget {
  final Doctordata product1;
  final String imagePath1;
  final Function(Doctordata editedProduct) onEdit;

  const docEditPage({
    required this.product1,
    required this.imagePath1,
    required this.onEdit,
    super.key,
  });

  @override
  State<docEditPage> createState() => _docEditPageState();
}

// ignore: camel_case_types
class _docEditPageState extends State<docEditPage> {
  late TextEditingController _doctorNameController;
  late TextEditingController _doctorexpController;
  late TextEditingController _doceduController;
  late Uint8List imagePath1;

  @override
  void initState() {
    super.initState();
    _doctorNameController = TextEditingController(text: widget.product1.docname);
    _doctorexpController =
        TextEditingController(text: widget.product1.exp.toString());
    _doceduController = TextEditingController(text: widget.product1.education);
    imagePath1 = base64Decode(widget.product1.image1);
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
              controller: _doctorNameController,
              decoration: const InputDecoration(labelText: 'Doctor Name'),
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _doctorexpController,
              decoration: const InputDecoration(labelText: 'Years of experience'),
            ),
            TextFormField(
              controller: _doceduController,
              decoration: const InputDecoration(labelText: 'Education'),
            ),
            SizedBox(
              height: 100,
              child: _buildImageWidget(),
            ),
            _buildSelectImageButton(),
            ElevatedButton(
              onPressed: () {
                Doctordata editedProduct = Doctordata(
                  docname: _doctorNameController.text,
                  doccategory: widget.product1.doccategory,
                  exp: _doctorexpController.text,
                  education: _doceduController.text,
                  image1: base64Encode(imagePath1),
                  id1: widget.product1.id1,
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
      imagePath1,
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
        imagePath1 = Uint8List.fromList(await image.readAsBytes());
      });
    }
  }
}
