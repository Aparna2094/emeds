import 'package:final_emeds/admin/doctor/doc_add.dart';
import 'package:final_emeds/user/doctor/appointment_database/appointment.dart';
import 'package:hive/hive.dart';

import 'package:flutter/material.dart';




ValueNotifier<List<Appointment>> appointmentlist = ValueNotifier([]);
String dbname = 'dbname8';

// ignore: unused_element
Future<void> _save(Appointment value) async {
  final save = await Hive.openBox<Appointment>(dbname);
  try {
    final id = await save.add(value);
    final data = save.get(id);
    await save.put(
        id,
        Appointment(
            name: data!.name,
            category: data.category,
            date: data.date,
            time: data.time,
           ));
    getall1(value);
  } finally {
    save.close();
  }
}

Future<void> getall1(Appointment value) async {
  final save = await Hive.openBox<Appointment>(dbname);
  try {
    appointmentlist.value.clear();
    appointmentlist.value.addAll(save.values);
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    appointmentlist.notifyListeners();
  } finally {
    save.close();
  }
}

Future<void> delete(int id) async {
  final remove = await Hive.openBox<Appointment>('boxappointment');
  remove.delete(id);
  getall();
}
