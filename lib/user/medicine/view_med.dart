import 'dart:convert';
import 'dart:typed_data';

import 'package:final_emeds/admin/medicine/database/product.dart';
import 'package:final_emeds/user/cart/cart_item.dart';
import 'package:final_emeds/user/cart/cart_page.dart';
import 'package:final_emeds/user/medicine/details_med.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
 // Import cart data class

class Viewmed extends StatefulWidget {
  const Viewmed({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ViewmedState createState() => _ViewmedState();
}

class _ViewmedState extends State<Viewmed> {
  late Future<Box<Product>> _boxProductFuture;

  @override
  void initState() {
    super.initState();
    _boxProductFuture = _openBox();
  }

  Future<Box<Product>> _openBox() async {
    await Hive.initFlutter();
    final box = await Hive.openBox<Product>('boxproduct');
    return box;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Medicines'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartPage(),
                ),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
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
                ? SingleChildScrollView(
              child: Column(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 0.7, // Adjust as needed for the image ratio
                    ),
                    itemCount: productList.length,
                    itemBuilder: (context, index) {
                      List<int> bytes = base64Decode(productList[index].image);

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailsPage(product: productList[index]),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          color: const Color.fromARGB(255, 221, 228, 227),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12.0),
                                    ),
                                    child: Image.memory(
                                      Uint8List.fromList(bytes),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  productList[index].name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    color: Colors.teal,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 11.0,
                                  vertical: 5.0,
                                ),
                                child: Text(
                                  'Price: \u{20B9} ${productList[index].price}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.add_shopping_cart, color: Colors.teal),
                                    onPressed: () async {
                                      final cartBox = await Hive.openBox<CartItem>('cart');
                                      cartBox.add(CartItem(
                                        id: productList[index].id,
                                        name: productList[index].name,
                                        price: productList[index].price,
                                        quantity: 1, // You can adjust quantity as needed
                                      ));

                                      // Show Snackbar to notify item addition
                                      // ignore: use_build_context_synchronously
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('${productList[index].name} added to cart'),
                                          duration: const Duration(seconds: 2), // Adjust duration as needed
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
                : const Center(child: Text('No products added yet.'));
          }
        },
      ),
    );
  }
}
