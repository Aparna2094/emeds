
// ignore_for_file: invalid_use_of_protected_member

import 'package:final_emeds/admin/authentication/database/data.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';





ValueNotifier<List<Data>> datalist = ValueNotifier([]);
String dbname3 = 'dbname3';

Future<List<Data>> getUserByEmail(String email) async {
  final save3 = await Hive.openBox<Data>(dbname3);
  List<Data> users = [];
  try {
    for (var data in save3.values) {
      if (data.email == email) {
        users.add(data);
      }
    }
    return users;
  } finally {
    save3.close();
  }
}

// ignore: unused_element
Future<void> _save(Data value) async {
  final save3 = await Hive.openBox<Data>(dbname3);
  try {
    final id4 = await save3.add(value);
    final data3= save3.get(id4);
    //var id4;
    await save3.put(
        id4,
        Data(
            name: data3!.name,
            email: data3.email,
            number: data3.number,
           
            password: data3.password,
          
          ));
    getall1(value);
  } finally {
    save3.close();
  }
}

Future<void> getall1(Data value) async {
  final save3 = await Hive.openBox<Data>(dbname3);
  try {
    datalist.value.clear();
    datalist.value.addAll(save3.values);
    // ignore: invalid_use_of_visible_for_testing_member
    datalist.notifyListeners();
  } finally {
    save3.close();
  }
}


