import 'dart:convert';
import 'dart:io';


import 'package:final_emeds/admin/authentication/database/boxes.dart';
import 'package:final_emeds/admin/doctor/database/docdatabase.dart';
import 'package:final_emeds/admin/doctor/database/doctordata.dart';
import 'package:final_emeds/admin/doctor/doc_details.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';



class Doctoraddingpage extends StatefulWidget {
  const Doctoraddingpage({super.key});

  @override
  State<Doctoraddingpage> createState() => _DoctoraddingpageState();
}

class _DoctoraddingpageState extends State<Doctoraddingpage> {
  final _formKey = GlobalKey<FormState>();
  final _docName = TextEditingController();
  late String _docCategory;
  final _yrsexp = TextEditingController();
  File? _selectedImage1;
  final _doceducation = TextEditingController();

  List<String> categories = [
    'General Physician',
    'ENT',
    'Gynecology',
    'Dermatology',
  ];

  @override
  void initState() {
    super.initState();
    _docCategory = categories.first;
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
        title: const Text('Add Doctor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.view_module),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DoclistView(),
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
                    _buildDoctorNameInput(),
                    const SizedBox(height: 10),
                    _buildCategoryDropdown(),
                    const SizedBox(height: 10),
                    _buildYearsOfExpInput(),
                    const SizedBox(height: 10),
                    _buildEducationInput(),
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
      onTap: _selectImage1,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 190, 182, 111),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: _selectedImage1 != null
            ? Image.file(
                _selectedImage1!,
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

  Widget _buildDoctorNameInput() {
    return TextFormField(
      controller: _docName,
      decoration: InputDecoration(
        labelText: 'Doctor Name',
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: _docName.text.isNotEmpty
                ? Colors.green
                :const Color.fromARGB(255, 190, 182, 111),
            width: 2.0,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the Doctor name';
        }
        return null;
      },
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _docCategory,
      decoration: InputDecoration(
        labelText: ' Category',
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: _docCategory.isNotEmpty
                ? Colors.green
                :const  Color.fromARGB(255, 190, 182, 111),
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
          _docCategory = value!;
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

  Widget _buildYearsOfExpInput() {
    return TextFormField(
      controller: _yrsexp,
      decoration: InputDecoration(
        labelText: 'Years Of Experience',
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: _yrsexp.text.isNotEmpty
                ? Colors.green
                :const  Color.fromARGB(255, 190, 182, 111),
            width: 2.0,
          ),
        ),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the years of experience';
        }
        if (double.tryParse(value) == null) {
          return 'Please enter a valid years of experience';
        }
        return null;
      },
    );
  }

  Widget _buildEducationInput() {
    return TextFormField(
      controller: _doceducation,
      decoration: InputDecoration(
        labelText: 'Education',
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: _doceducation.text.isNotEmpty
                ? Colors.green
                :const Color.fromARGB(255, 190, 182, 111),
            width: 2.0,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the Education';
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

  void _selectImage1() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage1 = File(image.path);
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
            title: const Text('Doctor Added Successfully'),
            actions: [
              TextButton(
                onPressed: () {
                 Navigator.pop(
      context);
    
                  
                },
                child:const  Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _addProduct() async {
    final dname = _docName.text;
    final dcat = _docCategory;
    final dexp = _yrsexp.text;
    final dedu = _doceducation.text;

    if (_selectedImage1 == null) {
      return;
    }

    final bytes = await _selectedImage1!.readAsBytes();
    final String base64img = base64Encode(bytes);

    final details = Doctordata(
      docname: dname,
      doccategory: dcat,
      exp: dexp,
      education: dedu,
      image1: base64img,
      id1: -1,
    );

    _save1(details);
  }

  Future<void> _openBox() async {
    boxdoctor = await Hive.openBox<Doctordata>('boxdoctor');
  }

  Future<void> _save1(Doctordata value) async {
    final id1 = await boxdoctor.add(value);
    final data1 = boxdoctor.get(id1);
    await boxdoctor.put(
      id1,
      Doctordata(
        docname: data1!.docname,
        doccategory: data1.doccategory,
        exp: data1.exp,
        education: data1.eduction,
        image1: data1.image1,
        id1: id1,
      ),
    );
    getall();
  }
}

void getall() async {
  final save = await Hive.openBox<Doctordata>('boxdoctor');
  doctorlist.value.clear();
  doctorlist.value.addAll(save.values);
  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  doctorlist.notifyListeners();
}
