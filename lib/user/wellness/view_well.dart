import 'dart:convert';
import 'dart:typed_data';


import 'package:final_emeds/admin/wellness/database/wellness.dart';
import 'package:final_emeds/user/cart/cart_item.dart';
import 'package:final_emeds/user/cart/cart_page.dart';
import 'package:final_emeds/user/wellness/details_well.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';


class Wellview extends StatefulWidget {
  const Wellview({super.key});

  @override
  State<Wellview> createState() => _WellviewState();
}

class _WellviewState extends State<Wellview> {
  late Future<Box<Wellness>> _boxwellnessFuture;
 

  @override
  void initState() {
    super.initState();
    _boxwellnessFuture = _openBox();
  }

  Future<Box<Wellness>> _openBox() async {
    await Hive.initFlutter();
    final box = await Hive.openBox<Wellness>('boxwellness');
    return box;
  }
  
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Wellness Details'),
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
                ? GridView.builder(
                   shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                            crossAxisSpacing: 16.0,
                            mainAxisSpacing: 16.0,
                            childAspectRatio: 0.7,
                    ),
                    itemCount: wellnessList.length,
                    itemBuilder: (context, index) {
                      List<int> bytes =
                          base64Decode(wellnessList[index].image2);

                      return InkWell(
                        onTap: (){
                          Navigator.push(context, 
                          MaterialPageRoute(builder: (context)=>WellnessDetailsPage(product: wellnessList[index]),),);
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
                                  wellnessList[index].proname,
                                  style:const  TextStyle(
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
                                   
                                  'Price: \u{20B9} ${wellnessList[index].proprice}',
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
      id: wellnessList[index].id3,
      name: wellnessList[index].proname,
      price: wellnessList[index].proprice,
      quantity: 1,
    ));
    
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added to cart: ${wellnessList[index].proname}'),
        duration: const Duration(seconds: 2),
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
                  )
                :const  Center(child: Text('No products added yet.'));
          }
        },
      ),
    );
  }
}
