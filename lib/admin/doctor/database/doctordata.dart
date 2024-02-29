import 'package:hive/hive.dart';

part 'doctordata.g.dart';

@HiveType(typeId: 3)
class Doctordata {
  @HiveField(0)
  String docname;

  @HiveField(1)
  String doccategory;

  @HiveField(2)
  String exp;

  @HiveField(3)
  String image1;

  @HiveField(4)
  String education;

  @HiveField(5)
  int id1;

  // @HiveField(5)
  // String imageUrl;

  Doctordata({
    required this.docname,
    required this.doccategory,
    required this.exp,
    required this.image1,
    required this.education,
    required this.id1,
  });
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