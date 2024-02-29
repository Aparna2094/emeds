import 'package:final_emeds/user/cart/address.dart';
import 'package:final_emeds/user/cart/cart_item.dart';
import 'package:final_emeds/user/cart/order_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';




const String dbname5 = 'boxaddress'; // Replace with your actual database name

class Adrrpage extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const Adrrpage({Key? key, required this.totalPrice});

  final double totalPrice;

  @override
  // ignore: library_private_types_in_public_api
  _AdrrpageState createState() => _AdrrpageState();
}

class _AdrrpageState extends State<Adrrpage> {
  final _formKey = GlobalKey<FormState>();
  final _address = TextEditingController();
  late String _payment;
  late Box<CartItem> _cartBox;

  List<String> payment = [
    'Cash On Delivery',
  ];

  @override
  void initState() {
    super.initState();
    _payment = payment.first;
    _openBox();
    _openBox1();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _openBox1() async {
    _cartBox = await Hive.openBox<CartItem>('cart');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Address details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ignore: unnecessary_null_comparison
            _cartBox == null
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
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _cartBox.length +
                              1, // Add one for total price row
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
                                  '₹${widget.totalPrice.toStringAsFixed(2)}',
                                  // Display total price
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              );
                            }

                            final cartItem = _cartBox.getAt(index)!;
                            return Card(
                              elevation: 3,
                              // Add elevation to the card
                              margin: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10,
                              ),
                              // Add margin to the card
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
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    // Change delete icon color
                                  ),
                                  onPressed: () {
                                    _cartBox.deleteAt(index);
                                    setState(() {});
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildAddressInput(),
                    const SizedBox(height: 10),
                    _buildPaymentDropdown(),
                    const SizedBox(height: 10),
                    _buildAddButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressInput() {
    return TextFormField(
      controller: _address,
      decoration: InputDecoration(
        labelText: 'Add Address',
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: _address.text.isNotEmpty
                ? Colors.teal
                : const Color.fromARGB(255, 190, 182, 111),
            width: 2.0,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the address';
        }
        return null;
      },
    );
  }

  Widget _buildPaymentDropdown() {
    return DropdownButtonFormField<String>(
      value: _payment,
      decoration: InputDecoration(
        labelText: 'Payment Method',
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: _payment.isNotEmpty
                ? Colors.teal
                : const Color.fromARGB(255, 190, 182, 111),
            width: 2.0,
          ),
        ),
      ),
      items: payment.map((String payment) {
        return DropdownMenuItem<String>(
          value: payment,
          child: Text(payment),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          _payment = value!;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select payment method';
        }
        return null;
      },
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
      onPressed: () {
        _submitForm();
      },
      child: const Text('Add'),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _addProduct();
    }
  }

  void _addProduct() async {
    final address = _address.text;
    final payment = _payment;

    try {
      final details = Address(
        address: address,
        payment: payment,
        id: -1,
      );

      await _save(details);
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Orderconfirm(),
        ),
      );
    } catch (e) {
      // ignore: avoid_print
      print('Error saving address: $e');
    }
  }

  Future<void> _openBox() async {
    await Hive.openBox<Address>(dbname5);
  }

  Future<void> _save(Address value) async {
    final box = Hive.box<Address>(dbname5);
    await box.add(value);
  }
}
