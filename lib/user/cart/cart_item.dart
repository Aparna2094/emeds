import 'package:hive/hive.dart';

part 'cart_item.g.dart';

@HiveType(typeId: 9)
class CartItem {
  @HiveField(0)
  late int id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String price;

  @HiveField(3)
  late int quantity;



  





 

  // @HiveField(5)
  // String imageUrl;

  CartItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.id,
   
    
   
  });

  get key => null;

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