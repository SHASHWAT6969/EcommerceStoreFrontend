import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'categories.dart';



class CategoryControllers extends GetxController {
  var categories = [].obs;

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  void fetchCategories() async {
    final response = await http.get(
        Uri.parse('http://10.0.2.2/clothesapp_api/user/categories.php'));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      categories.value = (jsonResponse as List)
          .map((data) => Category.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class CategoriesWidget extends StatefulWidget {
//   @override
//   _CategoriesWidgetState createState() => _CategoriesWidgetState();
// }
//
// class _CategoriesWidgetState extends State<CategoriesWidget> {
//   List categories = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchCategories();
//   }
//
//   Future<void> fetchCategories() async {
//     final response = await http.get(Uri.parse('http://localhost/get_categories.php'));
//
//     if (response.statusCode == 200) {
//       setState(() {
//         categories = json.decode(response.body);
//       });
//     } else {
//       throw Exception('Failed to load categories');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return categories.isEmpty
//         ? Center(child: CircularProgressIndicator())
//         : ListView.builder(
//       itemCount: categories.length,
//       itemBuilder: (context, index) {
//         return ListTile(
//           title: Text(categories[index]['name']),
//         );
//       },
//     );
//   }
// }
