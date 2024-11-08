

import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:online_store/Widget_box/product.dart';
import 'package:http/http.dart'as http;

import '../users/userPreferences/current_user.dart';
class ProductController extends GetxController {
  var likedProducts = <int>[].obs; // List of liked product IDs
  var favoriteProducts = <Product>[].obs; // List of favorite products
  final CurrentUser _currentUser=Get.put(CurrentUser());

  // Fetch liked products from the database
  Future<void> fetchLikedProducts() async {
    final response = await http.get(Uri.parse('http://10.0.2.2/clothesapp_api/user/like.php?user_id=${_currentUser.user.user_id}'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      likedProducts.value = data.map((item) => item['product_id'] as int).toList();
    }
  }

  // Fetch favorite products (you may need to adjust the API endpoint)
  Future<void> fetchFavoriteProducts() async {
    final response = await http.get(Uri.parse('http://10.0.2.2/clothesapp_api/user/get_favorite_products.php?user_id=${_currentUser.user.user_id}'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      favoriteProducts.value = data.map((item) => Product.fromJson(item)).toList();
    }
  }
}
