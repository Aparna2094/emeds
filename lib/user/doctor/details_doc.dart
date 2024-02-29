import 'dart:convert';
import 'dart:typed_data';

import 'package:final_emeds/admin/doctor/database/doctordata.dart';
import 'package:final_emeds/user/doctor/apponitment_form1.dart';
import 'package:flutter/material.dart';
// Adjust the import path based on your project structure

class DoctorDetailsPage extends StatefulWidget {
  final Doctordata product;

  const DoctorDetailsPage({super.key, required this.product});

  @override
  State<DoctorDetailsPage> createState() => _DoctorDetailsPageState();
}

class _DoctorDetailsPageState extends State<DoctorDetailsPage> {
  List<Doctordata> shoppingCart = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.teal,
        title: const Text('Doctor Details'),
      
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
                      Uint8List.fromList(base64Decode(widget.product.image1))),
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
              widget.product.docname,
              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
           const  SizedBox(height: 8.0),
           const Text(
              'Category:',
              style: TextStyle(fontSize: 16.0, color: Colors.teal),
            ),
            Text(
              widget.product.doccategory,
              style: const TextStyle(fontSize: 18.0),
            ),
           const SizedBox(height: 8.0),
           const Text(
              'Education:',
              style: TextStyle(fontSize: 16.0, color: Colors.teal),
            ),
            Text(
              '\$${widget.product.education.toString()}',
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
           const  SizedBox(height: 8.0),
           const Text(
              'Experience:',
              style: TextStyle(fontSize: 16.0, color: Colors.teal),
            ),
            Text(
              
              widget.product.exp,
              style: const TextStyle(fontSize: 18.0),
            ),
           const SizedBox(height: 16.0),
            // Add to cart button
            ElevatedButton(
              onPressed: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  const AppointmentConfirm(),
                  ),
                );
                // Implement logic to add the product to the cart
              },
              child:const  Text('Consult Now'),
            ),
          ],
        ),
      ),
    );
  }
}
