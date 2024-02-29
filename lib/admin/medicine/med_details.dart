import 'dart:convert';
import 'dart:typed_data';


import 'package:final_emeds/admin/medicine/database/product.dart';
import 'package:final_emeds/admin/medicine/med_edit.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';



class ProductListView extends StatefulWidget {
  const ProductListView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  late Future<Box<Product>> _boxProductFuture;

  @override
  void initState() {
    super.initState();
    _boxProductFuture = _openBox();
  }

  Future<Box<Product>> _openBox() async {
    await Hive.initFlutter(); // Initialize Hive
    final box = await Hive.openBox<Product>('boxproduct');
    return box;
  }

  Future<void> _updateProduct(
      Box<Product> box, int index, Product editedProduct) async {
    await box.putAt(index, editedProduct);
    setState(() {}); // Refresh the UI after editing
  }

  Future<void> _deleteProduct(Box<Product> box, int index) async {
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
        title: const Text('Medicine'),
       
      ),
      body: FutureBuilder(
        future: _boxProductFuture,
        builder: (context, AsyncSnapshot<Box<Product>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No products added yet.'));
          } else {
            final boxproduct = snapshot.data!;
            final productList = boxproduct.values.toList();
            return productList.isNotEmpty
                ? ListView.builder(
                    itemCount: productList.length,
                    itemBuilder: (context, index) {
                      List<int> bytes = base64Decode(productList[index].image);

                      return Card(
                        margin:const  EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(productList[index].name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(productList[index].category),
                              Column(
                                children: [
                                  Text(
                                    'Price: ${productList[index].price}',
                                  ),
                                  // ignore: unnecessary_string_interpolations
                                  Text ('${productList[index].description}')
                                ],
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
                                      builder: (context) => EditPage(
                                          product: productList[index],
                                          imagePath:productList[index].image,
                                          onEdit: (editedProduct) {
                                            _updateProduct(boxproduct, index,
                                                editedProduct);
                                            Navigator.pop(context);
                                          }),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _deleteProduct(boxproduct, index);
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
