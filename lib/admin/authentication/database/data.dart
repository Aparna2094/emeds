import 'package:hive/hive.dart';

part 'data.g.dart';

@HiveType(typeId: 1)
class Data {
  @HiveField(0)
  final String? email;

  @HiveField(1)
  final String password;

  @HiveField(2)
  final String? name;

  @HiveField(3)
  final String? number;
  @HiveField(4)


  Data({
    required this.email,
    required this.password,
    required this.name,
    required this.number,
    
  });

  get id => null;
}
