import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widget_box/product_controller.dart' as product;

class SearchResultsScreen extends StatelessWidget {
  final String query;
  final product.ProductController controller = Get.find<product.ProductController>();

  SearchResultsScreen({required this.query});

  @override
  Widget build(BuildContext context) {
    // Call filter function directly to get filtered products based on query
    controller.filterProducts(query);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Search Results"),
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
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          width: 200,
                          height: 230,
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
                        // Add like button here
                      ],
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "\$${product.price}",
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Row(
                          children: [
                            Text(
                              'M.R.P:\$',
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w300),
                            ),
                            Text(
                              product.MRP.toString(),
                              style: TextStyle(decoration: TextDecoration.lineThrough, fontWeight: FontWeight.w300, fontSize: 19),
                            )
                          ],
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          product.name,
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.black87),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      alignment: Alignment.centerLeft,
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
      }),
    );
  }
}
