import 'package:final_emeds/user/cart/addr_page.dart';
import 'package:final_emeds/user/cart/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';


class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Box<CartItem> _cartBox;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    _cartBox = await Hive.openBox<CartItem>('cart');
    setState(() {});
  }

  void addItemToCart(CartItem cartItem) {
    _cartBox.add(cartItem);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = 0.0; // Variable to store total price

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cart Items',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.teal, // Change app bar background color
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
                  itemCount: _cartBox.length + 1, // Add one for total price row
                  itemBuilder: (context, index) {
                    if (index == _cartBox.length) {
                      // If it's the last item, display total price row
                      return ListTile(
                        title: const Text(
                          'Total Price:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        trailing: Text(
                          '₹${totalPrice.toStringAsFixed(2)}', // Display total price
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      );
                    }

                    final cartItem = _cartBox.getAt(index)!;
                    totalPrice += double.parse(cartItem.price); // Add item price to total
                    return Card(
                      elevation: 3, // Add elevation to the card
                      margin: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ), // Add margin to the card
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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red, // Change delete icon color
                              ),
                              onPressed: () {
                                _cartBox.deleteAt(index);
                                setState(() {});
                              },
                            ),
                            const SizedBox(width: 8), // Add some space between icons
                            IconButton(
                              icon: const Icon(
                                Icons.add_circle,
                                color: Colors.green, // Set color for add icon
                              ),
                              onPressed: () {
                                addItemToCart(cartItem); // Add item to cart
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Adrrpage(totalPrice: totalPrice),
            ),
          );
          // Add onPressed action here
        },
        label: const Text(
          'Continue',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal, // Set button background color
        icon: const Icon(Icons.arrow_forward), // Add icon if needed
      ),
    );
  }
}
