import 'package:final_emeds/user/doctor/appointment_database/appointment.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';


class Appointmentdetails extends StatefulWidget {
  const Appointmentdetails({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AppointmentdetailsState createState() => _AppointmentdetailsState();
}

class _AppointmentdetailsState extends State<Appointmentdetails> {
  late Future<Box<Appointment>> _boxappointmentFuture;

  @override
  void initState() {
    super.initState();
    _boxappointmentFuture = _openBox();
  }

  Future<Box<Appointment>> _openBox() async {
    await Hive.initFlutter(); // Initialize Hive
    final box = await Hive.openBox<Appointment>('boxappointment');
    return box;
  }

  Future<void> _deleteProduct(Box<Appointment> box, int index) async {
    // Show a confirmation dialog
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Appointment'),
          content:
              const Text('Are you sure you want to cancel the appointment?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); // Cancel the deletion
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true); // Confirm the deletion
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      await box.deleteAt(index); // Delete the product from the box
      setState(() {}); // Refresh the UI after deletion
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Appointment Details'),
      ),
      body: FutureBuilder(
        future: _boxappointmentFuture,
        builder: (context, AsyncSnapshot<Box<Appointment>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No appointments added yet.'));
          } else {
            final boxappointment = snapshot.data!;
            final appointmentList = boxappointment.values.toList();
            return appointmentList.isNotEmpty
                ? ListView.builder(
                    itemCount: appointmentList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        elevation: 4,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(
                            ' Name:${appointmentList[index].name}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                'Category: ${appointmentList[index].category}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Date: ${appointmentList[index].date}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                'Time: ${appointmentList[index].time}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteProduct(boxappointment, index);
                            },
                          ),
                        ),
                      );
                    },
                  )
                : const Center(child: Text('No appointments added yet.'));
          }
        },
      ),
    );
  }
}
