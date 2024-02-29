import 'package:final_emeds/admin/authentication/database/data.dart';
import 'package:final_emeds/admin/db2.dart';
import 'package:final_emeds/admin/doctor/database/doctordata.dart';
import 'package:final_emeds/admin/medicine/database/product.dart';
import 'package:final_emeds/admin/wellness/database/wellness.dart';
import 'package:final_emeds/splash_screen.dart';
import 'package:final_emeds/user/cart/address.dart';
import 'package:final_emeds/user/cart/cart_item.dart';
import 'package:final_emeds/user/doctor/appointment_database/appointment.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';


 // Import the cart data model

// ignore: constant_identifier_names
const SAVEKEY = 'UserLoggedIn';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(DataAdapter());
  await openBoxes();

  runApp(const MyApp());
}

Future<void> openBoxes() async {
  

  await Hive.openBox<Data>('userBox');
  Hive.registerAdapter(ProductAdapter());
  await Hive.openBox<Product>('boxproduct');
  Hive.registerAdapter(ServiceModel1Adapter());
  await Hive.openBox<ServiceModel1>('service');
  Hive.registerAdapter(DoctordataAdapter());
  await Hive.openBox<Doctordata>('boxdoctor');
  Hive.registerAdapter(WellnessAdapter());
  await Hive.openBox<Wellness>('boxwellness');
  Hive.registerAdapter(AppointmentAdapter());
  await Hive.openBox<Appointment>('boxappointment');
  Hive.registerAdapter(CartItemAdapter());
  await Hive.openBox<CartItem>('cartBox');
  Hive.registerAdapter(AddressAdapter());
  await Hive.openBox<Address>('boxaddress');



}

class MyApp extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const Screensplash(),
    );
  }
}
