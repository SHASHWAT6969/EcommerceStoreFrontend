import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Widgets/animated_like_button.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String categoryName;
  final String heroTag; // Accept heroTag to link the Hero widget

  CategoryProductsScreen({required this.categoryName, required this.heroTag});

  Future<List<dynamic>> fetchCategoryProducts() async {
    final response = await http.get(Uri.parse('http://10.0.2.2/clothesapp_api/user/product_api.php?category=$categoryName'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load category products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchCategoryProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products found in this category.'));
          }

          final products = snapshot.data!;
          return GridView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Hero(
                            tag: heroTag, // Use the same tag as in HomeFragmentsScreen
                            child: Image.network(
                              product['image_url'],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 230,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Container(
                              alignment: Alignment.center,
                              height: 25,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: Colors.red,
                              ),
                              child: Text(
                                ' %50 off ',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Text(
                            ' Sale!',
                            style: TextStyle(color: Colors.red, fontSize: 19, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 25),
                          AnimatedLikeButton(product_id: int.parse(product['product_id'])),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          '\$${product['price']}',
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          'M.R.P: \$${product['MRP']}',
                          style: TextStyle(decoration: TextDecoration.lineThrough, fontWeight: FontWeight.w300, fontSize: 19),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          product['name'],
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.black87),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              mainAxisExtent: 410,
            ),
          );
        },
      ),
    );
  }
}
