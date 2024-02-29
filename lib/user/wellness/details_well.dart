import 'dart:convert';
import 'dart:typed_data';

import 'package:final_emeds/admin/wellness/database/wellness.dart';
import 'package:flutter/material.dart';

// Adjust the import path based on your project structure

class WellnessDetailsPage extends StatefulWidget {
  final Wellness product;

  const WellnessDetailsPage({super.key, required this.product});

  @override
  State<WellnessDetailsPage> createState() => _WellnessDetailsPageState();
}

class _WellnessDetailsPageState extends State<WellnessDetailsPage> {
  List<Wellness> shoppingCart = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Product Details'),
      
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
                      Uint8List.fromList(base64Decode(widget.product.image2))),
                  fit: BoxFit.fill, // Set BoxFit to cover
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            // Display product details with styling
            const Text(
              'Name:',
              style:  TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
            ),
            Text(
              widget.product.proname,
              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
           const SizedBox(height: 8.0),
           const Text(
              'Category:',
              style: TextStyle(fontSize: 16.0, color: Colors.teal),
            ),
            Text(
              widget.product.procategory,
              style: const TextStyle(fontSize: 18.0),
            ),
           const SizedBox(height: 8.0),
           const Text(
              'Price:',
              style: TextStyle(fontSize: 16.0, color: Colors.teal),
            ),
            Text(
              '\$${widget.product.proprice.toString()}',
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          const  SizedBox(height: 8.0),
           const Text(
              'Country Of Origin:',
              style: TextStyle(fontSize: 16.0, color: Colors.teal),
            ),
            Text(
              
              widget.product.countryOforigin,
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
