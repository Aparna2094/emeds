import 'dart:convert';
import 'dart:typed_data';


import 'package:final_emeds/admin/doctor/database/doctordata.dart';
import 'package:final_emeds/admin/doctor/doc_edit.dart';
import 'package:final_emeds/user/doctor/appointment_database/appointment_details.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';


class DoclistView extends StatefulWidget {
  const DoclistView({super.key});

  @override
  State<DoclistView> createState() => _DoclistViewState();
}

class _DoclistViewState extends State<DoclistView> {
   late Future<Box<Doctordata>> _boxdoctorFuture;
     @override
  void initState() {
    super.initState();
    _boxdoctorFuture = _openBox1();
  }
   Future<Box<Doctordata>> _openBox1() async {
    await Hive.initFlutter(); // Initialize Hive
    final box1 = await Hive.openBox<Doctordata>('boxdoctor');
    return box1;
  }
 Future<void> _updateProduct(
      Box<Doctordata> box, int index, Doctordata editedProduct) async {
    await box.putAt(index, editedProduct);
    setState(() {}); // Refresh the UI after editing
  }
  
   Future<void> _deletedoctor(Box<Doctordata> box1, int index) async {
    // Show a confirmation dialog
    bool confirmDelete1 = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this doctor?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); // Cancel the deletion
              },
              child:const  Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true); // Confirm the deletion
              },
              child:const  Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete1 == true) {
      await box1.deleteAt(index); // Delete the product from the box
      setState(() {}); // Refresh the UI after deletion
    }
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Medicine details'),
         actions: [
          // Icon button for appointment
          IconButton(
            icon: const Icon(Icons.event),
            onPressed: (){
               Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  const Appointmentdetails(),
                  ),
                );

            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _boxdoctorFuture,
        builder: (context, AsyncSnapshot<Box<Doctordata>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No products added yet.'));
          } else {
            final boxdoctor = snapshot.data!;
            final doctorList = boxdoctor.values.toList();
            return doctorList.isNotEmpty
                ? ListView.builder(
                    itemCount: doctorList.length,
                    itemBuilder: (context, index) {
                      List<int> bytes = base64Decode(doctorList[index].image1);

                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(doctorList[index].docname),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(doctorList[index].doccategory),
                              Text(
                                'Price: ${doctorList[index].exp}',
                              ),
                            ],
                          ),
                          leading: Image.memory(
                            Uint8List.fromList(bytes),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () { Navigator.push(
            context, MaterialPageRoute(builder: (context) => docEditPage(product1: doctorList[index], 
            imagePath1: doctorList[index].image1,
             onEdit: (editedProduct) {
                _updateProduct(boxdoctor, index,
                                                editedProduct);
                                            Navigator.pop(context);
             },)));
                                  // Implement edit functionality
                                  // Navigate to edit screen or perform edit action
                                  // based on productList[index]
                                },
                              ),
                              IconButton(
                                icon:const  Icon(Icons.delete),
                                onPressed: () {
                                  _deletedoctor(boxdoctor, index);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : const Center(child: Text('No products added yet.'));
          }
        },
      ),
    );
  }
}