
import 'package:final_emeds/admin/wellness/database/wellness.dart';
import 'package:final_emeds/admin/wellness/well_add.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';




ValueNotifier<List<Wellness>> wellnesslist = ValueNotifier([]);
String dbname2 = 'dbname2';

// ignore: unused_element
Future<void> _save(Wellness value) async {
  final save2 = await Hive.openBox<Wellness>(dbname2);
  try {
    final id2 = await save2.add(value);
    final data2 = save2.get(id2);
    // ignore: prefer_typing_uninitialized_variables
    var id3;
    await save2.put(
        id2,
        Wellness(
            proname: data2!.proname,
            procategory: data2.procategory,
            proprice: data2.proprice,
            countryOforigin: data2.countryOforigin,
            image2: data2.image2,
            id3: id3));
    getall1(value);
  } finally {
    save2.close();
  }
}

Future<void> getall1(Wellness value) async {
  final save2 = await Hive.openBox<Wellness>(dbname2);
  try {
    wellnesslist.value.clear();
    wellnesslist.value.addAll(save2.values);
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    wellnesslist.notifyListeners();
  } finally {
    save2.close();
  }
}

Future<void> delete(int id3) async {
  final remove2 = await Hive.openBox<Wellness>('boxwellness');
  remove2.delete(id3);
  getall();
}
