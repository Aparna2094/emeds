import 'package:hive/hive.dart';

part 'appointment.g.dart';

@HiveType(typeId: 8)
class Appointment {
  @HiveField(0)
  String name;

  @HiveField(1)
  String category;

  @HiveField(2)
  String date;

  @HiveField(3)
  String time;



  // @HiveField(5)
  // String imageUrl;

  Appointment({
    required this.name,
    required this.category,
    required this.date,
    required this.time,
  });

  //Product copyWith({required String name, required String price, required String description}) {}
}
// import 'package:hive/hive.dart';

// part 'product.g.dart';

// @HiveType(typeId: 0)
// class Product {
//   @HiveField(0)
//   String name;

//   @HiveField(1)
//   String category;

//   @HiveField(2)
//   String price;

//   @HiveField(3)
//   List<String>? images;

//   @HiveField(4)
//   String description;
//   @HiveField(5)
//   String imageUrl;
//   @HiveField(6)
//   int? id;

//   Product({
//     required this.name,
//     required this.category,
//     required this.price,
//     this.images,
//     required this.description,
//     required this.imageUrl,
//     this.id,
//   });
// }