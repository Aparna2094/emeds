import 'package:final_emeds/user/cart/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';


class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Order History'),
      ),
      body: FutureBuilder(
        future: Hive.openBox<CartItem>('cart'),
        builder: (context, AsyncSnapshot<Box<CartItem>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No orders found.'));
          } else {
            final cartBox = snapshot.data!;
            final orderList = cartBox.values.toList();
            if (orderList.isEmpty) {
              return const Center(child: Text('No orders found.'));
            }
            return ListView.builder(
              itemCount: orderList.length,
              itemBuilder: (context, index) {
                final order = orderList[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        order.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Price: ${order.price}'),
                          const SizedBox(height: 5),
                          const Row(
                            children: [
                              // Rating Widget
                              StarRating(),
                              SizedBox(width: 5),
                              Text('Delivered On Nov 24, 2024'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 0), // Add a divider between items
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}

class StarRating extends StatefulWidget {
  const StarRating({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  bool isStarColored = true; // Set to true to initialize as 5 stars

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isStarColored = !isStarColored;
        });
      },
      child: Row(
        children: List.generate(
          5,
          (index) => Icon(
            isStarColored ? Icons.star : Icons.star_border,
            color: isStarColored ? Colors.green : null,
          ),
        ),
      ),
    );
  }
}
