import 'package:shopping_list/models/category.dart';

class GroceryItem {
  const GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
  });

  final String id;
  final String name;
  final int quantity;
  final Category category;
}

// class Person {
//   const Person({
//     this.id,
//     this.name,
//     this.age,
//     this.gender,
//     this.occupation,
//     this.institute,
//   });

//   final int? id;
//   final String? name;
//   final int? age;
//   final String? gender;
//   final String? occupation;
//   final String? institute;
// }
