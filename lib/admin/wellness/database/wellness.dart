import 'package:hive/hive.dart';

part 'wellness.g.dart';

@HiveType(typeId: 5)
class Wellness {
  @HiveField(0)
  String proname;

  @HiveField(1)
  String procategory;

  @HiveField(2)
  String proprice;

  @HiveField(3)
  String image2;

  @HiveField(4)
  String countryOforigin;

  @HiveField(5)
  int id3;

  // @HiveField(5)
  // String imageUrl;

  Wellness({
    required this.proname,
    required this.procategory,
    required this.proprice,
    required this.image2,
    required this.countryOforigin,
    required this.id3,
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