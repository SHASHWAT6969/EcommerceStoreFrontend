import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:online_store/screens/OrderSummaryScreen.dart';
import '../userPreferences/current_user.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> with SingleTickerProviderStateMixin {
  final CurrentUser _currentUser = Get.put(CurrentUser());
  List<dynamic> favoriteProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  Future<void> _fetchFavorites() async {
    final String url = 'http://10.0.2.2/clothesapp_api/user/get_favourites.php';
    final response = await http.post(Uri.parse(url), body: {
      'action': 'fetch',
      'user_id': _currentUser.user.user_id.toString(),
    });

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['success']) {
        setState(() {
          favoriteProducts = result['products'];
          isLoading = false;
        });
      } else {
        print('Failed to load favorites: ${result['message']}');
      }
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  Future<void> _updateQuantity(int index, int change) async {
    int quantity = int.tryParse(favoriteProducts[index]['quantity'].toString()) ?? 1;
    quantity = (quantity + change).clamp(1, double.infinity).toInt();

    setState(() {
      favoriteProducts[index]['quantity'] = quantity;
    });

    final response = await http.post(
      Uri.parse('http://10.0.2.2/clothesapp_api/user/get_favourites.php'),
      body: {
        'action': 'update',
        'user_id': _currentUser.user.user_id.toString(),
        'product_id': favoriteProducts[index]['product_id'].toString(),
        'quantity': quantity.toString(),
      },
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['success']) {
        print('Updated');
      } else {
        print('Update failed: ${result['message']}');
      }
    }
  }

  Future<void> _removeFavorite(int index) async {
    final productId = favoriteProducts[index]['product_id'].toString();

    final response = await http.post(
      Uri.parse('http://10.0.2.2/clothesapp_api/user/get_favourites.php'),
      body: {
        'action': 'remove',
        'user_id': _currentUser.user.user_id.toString(),
        'product_id': productId,
      },
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['success']) {
        setState(() {
          favoriteProducts.removeAt(index);
        });
        print('Product removed from favorites');
      } else {
        print('Remove failed: ${result['message']}');
      }
    }
  }

  double getTotalPrice() {
    double total = 0.0;
    for (var product in favoriteProducts) {
      double price = double.tryParse(product['price'].toString()) ?? 0.0;
      int quantity = int.tryParse(product['quantity'].toString()) ?? 1;
      total += (price * quantity);
    }
    return total;
  }

  int getTotalItems() {
    int totalItems = 0;
    for (var product in favoriteProducts) {
      int quantity = int.tryParse(product['quantity'].toString()) ?? 0;
      totalItems += quantity;
    }
    return totalItems;
  }

  void _placeOrder() {
    Get.to(OrderSummaryScreen(
      userId: _currentUser.user.user_id,
      products: favoriteProducts,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Set a light background color
      appBar: AppBar(
        title: Text('Favorites'),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : favoriteProducts.isEmpty
          ? Center(child: Text('No items in favorites.'))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: favoriteProducts.length,
              itemBuilder: (context, index) {
                final product = favoriteProducts[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Card(
                    elevation: 8, // Increase shadow for depth
                    color: Colors.white, // Card color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              product['image_url'] ?? '',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['name'],
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  product['description'],
                                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '\$${product['price']}',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () async {
                                        await Get.dialog(AlertDialog(
                                          backgroundColor: Colors.white,
                                          title: const Text(
                                            "Delete item?",
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                          ),
                                          content: const Text("Remove item from favorites?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                _removeFavorite(index);
                                                Get.back();
                                              },
                                              child: Text("Yes", style: TextStyle(color: Colors.red)),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: Text("No", style: TextStyle(color: Colors.black)),
                                            ),
                                          ],
                                        ));
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => _updateQuantity(index, -1),
                                      icon: Icon(Icons.remove_circle, color: Colors.blue),
                                    ),
                                    Text('${product['quantity']}', style: TextStyle(fontSize: 16)),
                                    IconButton(
                                      onPressed: () => _updateQuantity(index, 1),
                                      icon: Icon(Icons.add_circle, color: Colors.blue),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Items: ${getTotalItems()}'),
                ElevatedButton(
                  onPressed: getTotalItems() > 0 ? _placeOrder : null,
                  style: ElevatedButton.styleFrom(
                     // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text('Order Now (\$${getTotalPrice().toStringAsFixed(2)})'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
