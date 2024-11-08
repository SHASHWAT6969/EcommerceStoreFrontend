import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_store/Widget_box/product_controller.dart';

class SearchResultsScreen extends StatelessWidget {
  final String query;

  SearchResultsScreen({required this.query});

  final ProductController controller = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    controller.filterProducts(query); // Filter products based on the query

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: Obx(() {
        var filteredProducts = controller.filteredProducts;
        if (filteredProducts.isEmpty) {
          return Center(child: Text('No products found.'));
        }
        return GridView.builder(
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            final product = filteredProducts[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          width: 200,
                          height: 230,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Text(product.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                    Text("\$" + product.price.toString(), style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500)),
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
      }),
    );
  }
}
