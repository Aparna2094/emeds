// ignore: unnecessary_import
import 'package:final_emeds/admin/wellness/database/wellness.dart';
import 'package:hive_flutter/hive_flutter.dart';


class DatabaseManager {
  late Box<Wellness> _boxwellness;

  Future<void> initDatabase() async {
    await Hive.initFlutter(); // Initialize Hive
    _boxwellness = await Hive.openBox<Wellness>('boxwellness');
  }

  Future<List<Wellness>> getWellnessList() async {
    return _boxwellness.values.toList();
  }

  Future<void> updateProduct(int index, Wellness editedProduct) async {
    await _boxwellness.putAt(index, editedProduct);
  }

  Future<void> deleteProduct(int index) async {
    await _boxwellness.deleteAt(index);
  }
}
