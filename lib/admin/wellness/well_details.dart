import 'dart:convert';
import 'dart:typed_data';


import 'package:final_emeds/admin/wellness/database/wellness.dart';
import 'package:final_emeds/admin/wellness/well_edit.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';


class WellDetails extends StatefulWidget {
  const WellDetails({super.key});

  @override
  State<WellDetails> createState() => _WellDetailsState();
}

class _WellDetailsState extends State<WellDetails> {
  late Future<Box<Wellness>> _boxwellnessFuture;

  @override
  void initState() {
    super.initState();
    _boxwellnessFuture = _openBox();
  }

  Future<Box<Wellness>> _openBox() async {
    await Hive.initFlutter(); // Initialize Hive
    final box = await Hive.openBox<Wellness>('boxwellness');
    return box;
  }

   Future<void> _updateProduct(
      Box<Wellness> box, int index, Wellness editedProduct) async {
    await box.putAt(index, editedProduct);
    setState(() {}); // Refresh the UI after editing
  }

  Future<void> _deleteProduct(Box<Wellness> box, int index) async {
    // Show a confirmation dialog
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); // Cancel the deletion
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true); // Confirm the deletion
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      await box.deleteAt(index); // Delete the product from the box
      setState(() {}); // Refresh the UI after deletion
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Wellness details'),
      ),
      body: FutureBuilder(
        future: _boxwellnessFuture,
        builder: (context, AsyncSnapshot<Box<Wellness>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No products added yet.'));
          } else {
            final boxwellness = snapshot.data!;
            final wellnessList = boxwellness.values.toList();
            return wellnessList.isNotEmpty
                ? ListView.builder(
                    itemCount: wellnessList.length,
                    itemBuilder: (context, index) {
                      List<int> bytes =
                          base64Decode(wellnessList[index].image2);

                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(wellnessList[index].proname),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(wellnessList[index].procategory),
                              Text(
                                'Price: ${wellnessList[index].proprice}',
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
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => wellEditPage(
                                                product2: wellnessList[index],
                                                imagePath2:
                                                    wellnessList[index].image2,
                                                onEdit: (editedProduct) {
                                                  _updateProduct(boxwellness,
                                                      index, editedProduct);
                                                  Navigator.pop(context);
                                                },
                                              )));

                                  // Implement edit functionality
                                  // Navigate to edit screen or perform edit action
                                  // based on productList[index]
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _deleteProduct(boxwellness, index);
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