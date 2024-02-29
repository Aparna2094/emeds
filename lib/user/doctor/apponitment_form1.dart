import 'package:final_emeds/user/doctor/appointment_database/appointment.dart';
import 'package:final_emeds/user/doctor/appointment_database/appointment_details.dart';
import 'package:final_emeds/user/doctor/confirmation_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';


ValueNotifier<List<Appointment>> appointmentlist = ValueNotifier([]);
String dbname = 'boxappointment';

class AppointmentConfirm extends StatefulWidget {
  const AppointmentConfirm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AppointmentConfirmState createState() => _AppointmentConfirmState();
}

class _AppointmentConfirmState extends State<AppointmentConfirm>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final _formKey = GlobalKey<FormState>();
  final _appointmetname = TextEditingController();
  final _selectedCategory = ValueNotifier<String>('ENT'); // Default category

  late DateTime _selectedDate = DateTime.now();
  late TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _animationController.forward();
    _openBox(); // Initialize with the first category
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consult Details'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Appointmentdetails()),
              );
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.teal,
              Color.fromARGB(255, 63, 211, 196),
              Color.fromARGB(255, 135, 190, 184),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 80),
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Add your text widgets here if needed
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 60),
                        FadeTransition(
                          opacity: _animationController.drive(
                            CurveTween(curve: Curves.easeInOut),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(225, 95, 27, .3),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                )
                              ],
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200),
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: _appointmetname,
                                    decoration: const InputDecoration(
                                      hintText: "Name",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your name';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Category",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      ValueListenableBuilder<String>(
                                        valueListenable: _selectedCategory,
                                        builder: (context, value, child) {
                                          return DropdownButtonFormField<String>(
                                            value: value,
                                            onChanged: (newValue) {
                                              setState(() {
                                                _selectedCategory.value = newValue!;
                                              });
                                            },
                                            items: categories
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200),
                                    ),
                                  ),
                                  child: TextFormField(
                                    onTap: () => _selectDate(context),
                                    decoration: const InputDecoration(
                                      labelText: 'Select Date',
                                    ),
                                    readOnly: true,
                                    controller: TextEditingController(
                                        text: _selectedDate.toString()),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200),
                                    ),
                                  ),
                                  child: TextFormField(
                                    onTap: () => _selectTime(context),
                                    decoration: const InputDecoration(
                                      labelText: 'Select Time',
                                    ),
                                    readOnly: true,
                                    controller: TextEditingController(
                                        text: _selectedTime.format(context)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        FadeTransition(
                          opacity: _animationController.drive(
                            CurveTween(curve: Curves.easeInOut),
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              _submitForm();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AppointmentConfirmationPage(),
                                ),
                              );
                            },
                            height: 50,
                            color: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Center(
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        FadeTransition(
                          opacity: _animationController.drive(
                            CurveTween(curve: Curves.easeInOut),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _addProduct();
    }
  }

  Future<void> _openBox() async {
    final boxappointment = await Hive.openBox<Appointment>(dbname);
    appointmentlist.value.clear();
    appointmentlist.value.addAll(boxappointment.values);
  }

  Future<void> _addProduct() async {
    final name = _appointmetname.text;
    final cat = _selectedCategory.value;
    final date = _selectedDate.toString();
    final time = _selectedTime.format(context);

    try {
      final details = Appointment(
        name: name,
        category: cat,
        date: date,
        time: time,
      );
      final boxappointment = await Hive.openBox<Appointment>(dbname);
      await boxappointment.add(details);
      appointmentlist.value.add(details);
    } catch (e) {
      // Handle error
    }
  }

  final List<String> categories = [
    'ENT',
    'Gynecology',
    'Dermatology',
    'General Physician'
  ];
}
