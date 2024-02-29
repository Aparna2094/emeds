import 'dart:convert';
import 'dart:io';

import 'package:final_emeds/admin/authentication/database/boxes.dart';
import 'package:final_emeds/admin/medicine/database/database.dart';
import 'package:final_emeds/admin/medicine/database/product.dart';
import 'package:final_emeds/admin/medicine/med_details.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';


const String dbname = 'boxproduct'; // Replace with your actual database name

class ProductAddingPage extends StatefulWidget {
  const ProductAddingPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProductAddingPageState createState() => _ProductAddingPageState();
}

class _ProductAddingPageState extends State<ProductAddingPage> {
  final _formKey = GlobalKey<FormState>();
  final _productName = TextEditingController();
  late String _productCategory;
  final _productPrice = TextEditingController();
  File? _selectedImage;
  final _productDis = TextEditingController();

  List<String> categories = [
    'Petcare',
    'Vitamins and Supplements',
    'Face Wash & Cleansers',
    'Baby & Infant Care',
  ];

  @override
  void initState() {
    super.initState();
    _productCategory = categories.first;
    _openBox();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Add Medicine'),
        actions: [
          IconButton(
            icon:const Icon(Icons.view_module),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductListView(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            width: 500,
            height: 600,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromARGB(255, 190, 182, 111),
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildImageSelector(),
                    const SizedBox(height: 10),
                    _buildProductNameInput(),
                    const SizedBox(height: 10),
                    _buildCategoryDropdown(),
                    const SizedBox(height: 10),
                    _buildProductPriceInput(),
                    const SizedBox(height: 10),
                    _buildProductDescriptionInput(),
                    _buildAddButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSelector() {
    return GestureDetector(
      onTap: _selectImage,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color:const  Color.fromARGB(255, 190, 182, 111),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: _selectedImage != null
            ? Image.file(
                _selectedImage!,
                fit: BoxFit.cover,
              )
            : const Icon(
                Icons.add_photo_alternate,
                size: 50,
                color: Colors.white,
              ),
      ),
    );
  }

  Widget _buildProductNameInput() {
    return TextFormField(
      controller: _productName,
      decoration: InputDecoration(
        labelText: 'Medicine Name',
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: _productName.text.isNotEmpty
                ? Colors.green
                :const  Color.fromARGB(255, 190, 182, 111),
            width: 2.0,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a Medicine name';
        }
        return null;
      },
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _productCategory,
      decoration: InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: _productCategory.isNotEmpty
                ? Colors.green
                : const Color.fromARGB(255, 190, 182, 111),
            width: 2.0,
          ),
        ),
      ),
      items: categories.map((String category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(category),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          _productCategory = value!;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a category';
        }
        return null;
      },
    );
  }

  Widget _buildProductPriceInput() {
    return TextFormField(
      controller: _productPrice,
      decoration: InputDecoration(
        labelText: 'Price',
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: _productPrice.text.isNotEmpty
                ? Colors.green
                : const Color.fromARGB(255, 190, 182, 111),
            width: 2.0,
          ),
        ),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a price';
        }
        if (double.tryParse(value) == null) {
          return 'Please enter a valid price';
        }
        return null;
      },
    );
  }

  Widget _buildProductDescriptionInput() {
    return TextFormField(
      controller: _productDis,
      decoration: InputDecoration(
        labelText: 'Country Of Origin',
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: _productDis.text.isNotEmpty
                ? Colors.green
                : const Color.fromARGB(255, 190, 182, 111),
            width: 2.0,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a description';
        }
        return null;
      },
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton(
      style: ButtonStyle(
         backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
      onPressed: () {
        _submitForm();
      },
      
      child: const Text('Add'),
      
    );
  }

  void _selectImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _addProduct();

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Medicine Added Successfully'),
            actions: [
              TextButton(
                onPressed: () {
                 Navigator.pop(context);
    // Replace with the correct destination
    // Close the dialog
                 // Go back to the previous screen
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

void _addProduct() async {
  final name = _productName.text;
  final cat = _productCategory;
  final price = _productPrice.text;
  final describ = _productDis.text;

  if (_selectedImage == null) {
    return;
  }

  try {
    final bytes = await _selectedImage!.readAsBytes();
    final String base64img = base64Encode(bytes);

    final details = Product(
      name: name,
      category: cat,
      price: price,
      description: describ,
      image: base64img,
      id: -1,
    );

    _save(details);
  } catch (e) {
    // ignore: avoid_print
    print('Error encoding image: $e');
  }
}


  Future<void> _openBox() async {
    boxproduct = await Hive.openBox<Product>('boxproduct');
  }

  Future<void> _save(Product value) async {
    final id = await boxproduct.add(value);
    final data = boxproduct.get(id);
    await boxproduct.put(
      id,
      Product(
        name: data!.name,
        category: data.category,
        price: data.price,
        description: data.description,
        image: data.image,
        id: id,
      ),
    );
    getall();
  }
}

class ProductListingPage extends StatelessWidget {
  const ProductListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

void getall() async {
  final save = await Hive.openBox<Product>('boxproduct');
  productlist.value.clear();
  productlist.value.addAll(save.values);
  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  productlist.notifyListeners();
}
