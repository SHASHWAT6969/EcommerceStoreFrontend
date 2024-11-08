import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product.dart';

class ProductController extends GetxController {
  var products = <Product>[].obs;
  var filteredProducts = <Product>[].obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      filteredProducts.clear();
      filteredProducts.addAll(products); // Show all products if query is empty
    } else {
      filteredProducts.value = products.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  void fetchProducts() async {
    String uri = "http://10.0.2.2/clothesapp_api/user/product_api.php";
    final response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      products.value = (jsonResponse as List).map((data) => Product.fromJson(data)).toList();

      // Initialize filteredProducts with all products after fetching
      filteredProducts.addAll(products);
    } else {
      throw Exception('Failed to load products');
    }
  }
}
