
import 'package:final_emeds/admin/doctor/database/doctordata.dart';
import 'package:final_emeds/admin/doctor/doc_add.dart';
import 'package:hive/hive.dart';

import 'package:flutter/material.dart';




ValueNotifier<List<Doctordata>> doctorlist = ValueNotifier([]);
String dbname1 = 'dbname1';

// ignore: unused_element
Future<void> _save(Doctordata value) async {
  final save1 = await Hive.openBox<Doctordata>(dbname1);
  try {
    final id1 = await save1.add(value);
    final data1 = save1.get(id1);
    await save1.put(
        id1,
        Doctordata(
            docname: data1!.docname,
            doccategory: data1.doccategory,
            exp: data1.exp,
            education: data1.education,
            image1: data1.image1,
            id1: id1));
    getall1(value);
  } finally {
    save1.close();
  }
}

Future<void> getall1(Doctordata value) async {
  final save1 = await Hive.openBox<Doctordata>(dbname1);
  try {
    doctorlist.value.clear();
    doctorlist.value.addAll(save1.values);
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    doctorlist.notifyListeners();
  } finally {
    save1.close();
  }
}

Future<void> delete(int id1) async {
  final remove1 = await Hive.openBox<Doctordata>('boxdoctor');
  remove1.delete(id1);
  getall();
}
