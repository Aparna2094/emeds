import 'package:flutter/material.dart';

class AppointmentConfirmationPage extends StatelessWidget {
  const AppointmentConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Confirmed'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 80.0),
            SizedBox(height: 16.0),
            Text(
              'Appointment Confirmed!',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
