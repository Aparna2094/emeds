import 'package:final_emeds/admin/medicine/database/product.dart';
import 'package:flutter/material.dart';


class CartPage extends StatelessWidget {
  final List<Product> cartItems;

  const CartPage({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    // Implement your cart page UI using the cartItems list
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          // Display each item in the cart
          return ListTile(
            title: Text(cartItems[index].name),
            subtitle: Text('Price: ${cartItems[index].price}'),
            // You can add more details if needed
          );
        },
      ),
    );
  }
}
