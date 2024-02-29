import 'package:final_emeds/admin/medicine/add_medicine.dart';
import 'package:final_emeds/admin/medicine/database/product.dart';
import 'package:hive/hive.dart';

import 'package:flutter/material.dart';




ValueNotifier<List<Product>> productlist = ValueNotifier([]);
String dbname = 'dbname';

// ignore: unused_element
Future<void> _save(Product value) async {
  final save = await Hive.openBox<Product>(dbname);
  try {
    final id = await save.add(value);
    final data = save.get(id);
    await save.put(
        id,
        Product(
            name: data!.name,
            category: data.category,
            price: data.price,
            description: data.description,
            image: data.image,
            id: id));
    getall1(value);
  } finally {
    save.close();
  }
}

Future<void> getall1(Product value) async {
  final save = await Hive.openBox<Product>(dbname);
  try {
    productlist.value.clear();
    productlist.value.addAll(save.values);
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    productlist.notifyListeners();
  } finally {
    save.close();
  }
}

Future<void> delete(int id) async {
  final remove = await Hive.openBox<Product>('boxproduct');
  remove.delete(id);
  getall();
}
