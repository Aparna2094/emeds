

import 'package:final_emeds/user/cart/address.dart';
import 'package:final_emeds/user/cart/cart_item.dart';
import 'package:final_emeds/user/cart/confirm.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';



class Orderconfirm extends StatefulWidget {
  const Orderconfirm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OrderconfirmState createState() => _OrderconfirmState();
}

class _OrderconfirmState extends State<Orderconfirm> {
  late Future<Box<Address>> _boxaddressFuture;
  late Box<CartItem> _cartBox;

  @override
  void initState() {
    super.initState();
    _boxaddressFuture = _openBox();
    _openBox1();
  }

  Future<void> _openBox1() async {
    _cartBox = await Hive.openBox<CartItem>('cart');
    setState(() {});
  }

  Future<Box<Address>> _openBox() async {
    await Hive.initFlutter(); // Initialize Hive
    final box = await Hive.openBox<Address>('boxaddress');
    return box;
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = 0.0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Address'),
      ),
      // ignore: unnecessary_null_comparison
      body: _cartBox == null
          ? const Center(child: CircularProgressIndicator())
          : _cartBox.isEmpty
              ? const Center(
                  child: Text(
                    'Cart is empty',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: _cartBox.length + 2,
                  itemBuilder: (context, index) {
                    if (index == _cartBox.length) {
                      return ListTile(
                        title: const Text(
                          'Total Price:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        trailing: Text(
                          '₹${totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      );
                    } else if (index == _cartBox.length + 1) {
                      return FutureBuilder(
                        future: _boxaddressFuture,
                        builder:
                            (context, AsyncSnapshot<Box<Address>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data == null) {
                            return const Center(
                                child: Text('No products added yet.'));
                          } else {
                            final boxaddress = snapshot.data!;
                            final addressList = boxaddress.values.toList();
                            if (addressList.isEmpty) {
                              return const Center(
                                  child: Text('No products added yet.'));
                            }
                            final latestAddress = addressList.last;
                            return ListTile(
                              title: const Text(
                                'Delivery Address:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ' ${latestAddress.address}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(
                                      height:
                                          5),
                                           const Text(
                                'Pyment Method:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ), // Add some space between address and payment
                                  Text(
                                    ' ${latestAddress.payment}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      );
                    } else {
                      final cartItem = _cartBox.getAt(index)!;
                      totalPrice += double.parse(cartItem.price);
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        child: ListTile(
                          title: Text(
                            cartItem.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Price: ${cartItem.price.toString()}',
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Confirm Order"),
                content: const Text("Are you sure you want to confirm the order?"),
                actions: <Widget>[
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text("Confirm"),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      // Add functionality for confirming the order here
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ConfirmationPage(),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          
        ),
        child: const Text(
          'Confirm Order',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white
          ),
        ),
      ),
    );
  }
}
