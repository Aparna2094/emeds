import 'dart:convert';
import 'dart:typed_data';
import 'package:final_emeds/admin/medicine/database/product.dart';
import 'package:flutter/material.dart';

 // Adjust the import path based on your project structure

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.teal,
        title: const Text('Product Details'),
        actions: [
          IconButton(
            icon:const  Icon(Icons.shopping_cart),
            onPressed: () {
             // Navigator.push(
               // context,
                //MaterialPageRoute(
                  //builder: (context) => ShoppingCart(cartItems: shoppingCart),
               // ),
              //);

              // Navigate to the shopping cart screen
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display product image
            Container(
              height: 200.0,
              width: 200.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                image: DecorationImage(
                  image: MemoryImage(
                      Uint8List.fromList(base64Decode(widget.product.image))),
                  fit: BoxFit.fill, // Set BoxFit to cover
                ),
              ),
            ),
           const SizedBox(height: 20.0),
            // Display product details with styling
           const Text(
              'Name:',
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
            ),
            Text(
              widget.product.name,
              style:const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
           const SizedBox(height: 8.0),
           const Text(
              'Category:',
              style: TextStyle(fontSize: 16.0, color: Colors.teal),
            ),
            Text(
              widget.product.category,
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Price: ',
              style: TextStyle(fontSize: 16.0, color: Colors.teal),
            ),
            Text(
              '\u{20B9}${widget.product.price.toString()}',
              style:const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
             const SizedBox(height: 8.0),
            const Text(
              'Country of Origin:',
              style: TextStyle(fontSize: 16.0, color: Colors.teal),
            ),
            Text(
              widget.product.description,
              style: const TextStyle(fontSize: 18.0),
            ),
           const SizedBox(height: 16.0),
            // Add to cart button
          
            
          ],
        ),
      ),
    );
  }
}
