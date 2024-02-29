import 'dart:convert';
import 'dart:io';
import 'package:final_emeds/admin/authentication/database/boxes.dart';
import 'package:final_emeds/admin/wellness/database/wellness.dart';
import 'package:final_emeds/admin/wellness/database/wellnessdata.dart';
import 'package:final_emeds/admin/wellness/well_details.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';



const String dbname2 = 'boxwellness';

class WellnessAdd extends StatefulWidget {
  const WellnessAdd({super.key});

  @override
  State<WellnessAdd> createState() => _WellnessAddState();
}

class _WellnessAddState extends State<WellnessAdd> {
  final _formKey = GlobalKey<FormState>();
  final _wellName = TextEditingController();
  late String _wellCategory;
  final _wellPrice = TextEditingController();
  File? _selectedImage3;
  final _wellorigin = TextEditingController();

  List<String> categories = [
    'Fitness',
    'Devices',
    'Personal Care',
    'Treatments',
  ];

  @override
  void initState() {
    super.initState();
    _wellCategory = categories.first;
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
        title: const Text('Add Wellness'),
        actions: [
          IconButton(
            icon: const Icon(Icons.view_module),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WellDetails(),
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
      onTap: _selectImage2,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 190, 182, 111),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: _selectedImage3 != null
            ? Image.file(
                _selectedImage3!,
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
      controller: _wellName,
      decoration: InputDecoration(
        labelText: ' Product Name',
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: _wellName.text.isNotEmpty
                ? Colors.green
                : const Color.fromARGB(255, 190, 182, 111),
            width: 2.0,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the product name';
        }
        return null;
      },
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _wellCategory,
      decoration: InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: _wellCategory.isNotEmpty
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
          _wellCategory = value!;
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
      controller: _wellPrice,
      decoration: InputDecoration(
        labelText: 'Price',
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: _wellPrice.text.isNotEmpty
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
      controller: _wellorigin,
      decoration: InputDecoration(
        labelText: 'Country Of Origin',
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: _wellorigin.text.isNotEmpty
                ? Colors.green
                : const Color.fromARGB(255, 190, 182, 111),
            width: 2.0,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the Country of origin';
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

  void _selectImage2() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage3 = File(image.path);
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
            title: const Text('Wellness Added Successfully'),
            actions: [
              TextButton(
                onPressed: () {
                   Navigator.pop(context);
    
  // Close the  // Close the dialog
              
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
    final proname = _wellName.text;
    final procatogory = _wellCategory;
    final proprice = _wellPrice.text;
    final countryOforigin = _wellorigin.text;

    if (_selectedImage3 == null) {
      return;
    }

    final bytes = await _selectedImage3!.readAsBytes();
    final String base64img = base64Encode(bytes);

    final details = Wellness(
      proname: proname,
      procategory: procatogory,
      proprice: proprice,
      countryOforigin: countryOforigin,
      image2: base64img,
      id3: -1,
    );

    _save(details);
  }

  Future<void> _openBox() async {
    boxwellness = await Hive.openBox<Wellness>('boxwellness');
  }

  Future<void> _save(Wellness value) async {
    final id2 = await boxwellness.add(value);
    final data2 = boxwellness.get(id2);
    // ignore: prefer_typing_uninitialized_variables
    var id3;
    await boxwellness.put(
      id2,
      Wellness(
        proname: data2!.proname,
        procategory: data2.procategory,
        proprice: data2.proprice,
        countryOforigin: data2.countryOforigin,
        image2: data2.image2,
        id3: id3,
      ),
    );
    getall();
  }
}

void getall() async {
  final save = await Hive.openBox<Wellness>('boxwellness');
  wellnesslist.value.clear();
  wellnesslist.value.addAll(save.values);
  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  wellnesslist.notifyListeners();
}
