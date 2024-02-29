import 'package:final_emeds/admin/doctor/doc_add.dart';
import 'package:final_emeds/user/cart/address.dart';
import 'package:hive/hive.dart';

import 'package:flutter/material.dart';




ValueNotifier<List<Address>> addresslist = ValueNotifier([]);
String dbname5 = 'dbname5';

// ignore: unused_element
Future<void> _save(Address value) async {
  final save = await Hive.openBox<Address>(dbname5);
  try {
    final id = await save.add(value);
    final data = save.get(id);
    await save.put(
        id,
      Address(
            address: data!.address,
            payment: data.payment,
           
            id: id));
    getall1(value);
  } finally {
    save.close();
  }
}

Future<void> getall1(Address value) async {
  final save = await Hive.openBox<Address>(dbname5);
  try {
    addresslist.value.clear();
    addresslist.value.addAll(save.values);
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    addresslist.notifyListeners();
  } finally {
    save.close();
  }
}

Future<void> delete(int id) async {
  final remove = await Hive.openBox<Address>('boxaddress');
  remove.delete(id);
  getall();
}
