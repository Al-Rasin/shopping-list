import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';

import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
      'flutter-prep-bbc37-default-rtdb.firebaseio.com',
      'shopping-list.json',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        setState(() {
          _error = 'Faild to fetch data.Please try again later.';
        });
      }

      if (response.body == "null") {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final Map<String, dynamic> listData = json.decode(response.body);
      final List<GroceryItem> loadedItems = [];

      for (final item in listData.entries) {
        final category = categories.entries.firstWhere((catItem) => catItem.value.title == item.value['category']).value;
        loadedItems.add(
          GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category,
          ),
        );
        print(response.statusCode);
      }
      setState(() {
        _groceryItems = loadedItems;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _error = 'SomeThing is wrong.Please try again later.';
      });
    }
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );

    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);

    setState(() {
      _groceryItems.remove(item);
    });

    final url = Uri.https(
      'flutter-prep-bbc37-default-rtdb.firebaseio.com',
      'shopping-list/${item.id}.json',
    );
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      setState(() {
        _groceryItems.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No items added yet.'),
    );

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) {
            _removeItem(_groceryItems[index]);
          },
          key: ValueKey(_groceryItems[index].id),
          child: ListTile(
            title: Text(_groceryItems[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryItems[index].category.color,
            ),
            trailing: Text(
              _groceryItems[index].quantity.toString(),
            ),
          ),
        ),
      );
    }

    if (_error != null) {
      content = Center(child: Text(_error!));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: content,
    );
  }
}

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shopping_list/models/grocery_item.dart';

// class GroceryList extends StatefulWidget {
//   const GroceryList({
//     super.key,
//   });

//   @override
//   State<GroceryList> createState() => _GroceryListState();
// }

// class _GroceryListState extends State<GroceryList> {
//   @override
//   void initState() {
//     super.initState();
//     _loadItems();
//   }

//   Person? person;

//   void _loadItems() async {
//     final url = Uri.http('10.0.2.2:8080', 'test_get');
//     final response = await http.get(url);
//     final decoded = json.decode(response.body);

//     person = Person(
//       id: decoded['id'],
//       name: decoded['name'],
//       age: decoded['age'],
//       gender: decoded['gender'],
//       occupation: decoded['occupation'],
//       institute: decoded['institute'],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Your Grocery'),
//           actions: [
//             IconButton(
//               onPressed: () {},
//               icon: const Icon(Icons.add),
//             ),
//           ],
//         ),
//         body: Container(
//           margin: const EdgeInsets.all(20),
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(color: Colors.red),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Text(
//                 person?.id.toString() ?? '',
//                 style: TextStyle(fontSize: 100, fontWeight: FontWeight.w800, color: Colors.blue.shade300),
//               ),
//               const SizedBox(width: 10),
//               Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(person?.name ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.yellow)),
//                   Row(
//                     children: [
//                       Text(person?.age.toString() ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.yellow)),
//                       const SizedBox(width: 150),
//                       Text(person?.gender ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.yellow)),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       Text(person?.occupation ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.yellow)),
//                       const SizedBox(width: 20),
//                       Text(person?.institute ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.yellow)),
//                     ],
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ));
//   }
// }
