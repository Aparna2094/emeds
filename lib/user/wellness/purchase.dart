import 'package:final_emeds/admin/medicine/database/product.dart';
import 'package:flutter/material.dart';


class PurchasePage extends StatelessWidget {
  final Product product;

  const PurchasePage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display product details again if needed

            // User input fields (Address, etc.)
            // ...

            const SizedBox(height: 16.0),

            // Payment options (Cash on Delivery radio button, etc.)
            // ...

            // Purchase button
            ElevatedButton(
              onPressed: () {
                // Implement logic to complete the purchase
              },
              child: const Text('Purchase'),
            ),
          ],
        ),
      ),
    );
  }
}