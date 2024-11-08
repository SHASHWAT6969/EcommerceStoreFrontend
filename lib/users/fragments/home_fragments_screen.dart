import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_store/Widget_box/category_controller.dart';
import 'package:online_store/Widgets/animated_like_button.dart';
import '../../Widget_box/liked_product_controller.dart' as liked;
import '../../Widget_box/product_controller.dart' as product;
import '../../screens/SearchResultScreen.dart';
import 'CategoryProductScreen.dart';

class HomeFragmentsScreen extends StatefulWidget {
  @override
  _HomeFragmentsScreenState createState() => _HomeFragmentsScreenState();
}

class _HomeFragmentsScreenState extends State<HomeFragmentsScreen> with TickerProviderStateMixin {
  final product.ProductController controller = Get.put(product.ProductController());
  final CategoryControllers cat_controller = Get.put(CategoryControllers());

  final TextEditingController searchController = TextEditingController();

  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startImageSlider();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _startImageSlider() {
    // Ensure the state is updated only when the widget is mounted
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (mounted) {
        // Prevent state updates if the widget is being rebuilt during this phase
        if (_currentPage < 2) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void filterProducts(String query) {
    controller.filterProducts(query);
  }

  Widget searchBar() {
    return TextField(
      controller: searchController,
      style: TextStyle(color: Colors.black),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Search...',
        suffixIcon: IconButton(
          onPressed: () {},
          icon: Icon(Icons.search, color: Colors.black),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onChanged: (value) {
        // Navigate to the search results screen with the query
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchResultsScreen(query: value),
          ),
        );
      },
    );
  }

  Widget categoryBar() {
    return Obx(() {
      if (cat_controller.categories.isEmpty) {
        return Center(child: CircularProgressIndicator());
      }
      return Container(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: cat_controller.categories.length,
          itemBuilder: (context, index) {
            final category = cat_controller.categories[index];

            // Generate a unique hero tag for each category
            final String heroTag = "category-${category.name}";

            return GestureDetector(
              onTap: () {
                // Navigate to the CategoryProductsScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryProductsScreen(
                      categoryName: category.name,
                      heroTag: heroTag, // Pass the hero tag to the new screen
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    // Hero widget for smooth transition
                    Hero(
                      tag: heroTag, // Unique tag to identify the category's image
                      child: ClipOval(
                        child: Image.network(
                          category.image_url,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(category.name),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  // Image slider widget with indicator dots
  Widget imageSlider() {
    List<String> imageUrls = [
      "https://imgs.search.brave.com/ZcFV1E64Xxe-ergYs18zwwJtmpxvGFTcHfWosYQRQGI/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9jZWJs/b2cuczMuYW1hem9u/YXdzLmNvbS93cC1j/b250ZW50L3VwbG9h/ZHMvMjAyMC8wMy8x/NzE3MDk1NS9jb3N0/Y29lYXJ0aGRheXNh/dmluZ3NldmVudC5w/bmc",
      "https://imgs.search.brave.com/QW0y0d7i2fBGiB7w0Fqj_4IkIL3HxPTMQKyCmQCbm7U/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pLnBp/bmltZy5jb20vb3Jp/Z2luYWxzLzQxLzhj/LzY5LzQxOGM2OTQx/MTEyNGM0MjE0OWI1/Njc0MzRmNGVmM2Fj/LmpwZw",
      "https://imgs.search.brave.com/yqQIBu6CQsl2zi3BT6mKwwfukNRanCsm-vIydV1gKJc/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pLnBp/bmltZy5jb20vb3Jp/Z2luYWxzLzBmLzY3/LzdkLzBmNjc3ZGNl/ZWEwNTY5MDlhNzk0/MGM3OTAwNGEzZWM5/LmpwZw",
    ]; // List of images for the slider

    return Column(
      children: [
        Container(
          height: 250,
          child: PageView.builder(
            controller: _pageController,
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return Image.network(
                imageUrls[index],
                fit: BoxFit.cover,
              );
            },
            onPageChanged: (index) {
              if (mounted) {
                setState(() {
                  _currentPage = index;
                });
              }
            },
          ),
        ),
        SizedBox(height: 10), // Space between image slider and dots
        DotsIndicator(
          currentPage: _currentPage,
          totalPages: imageUrls.length,
        ),
      ],
    );
  }

  Widget productList() {
    return Obx(() {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Home"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: searchBar(),
          ),
          Expanded(
            child: Column(
              children: [
                categoryBar(),
                Expanded(child: imageSlider()), // Add the image slider here with dots
                Expanded(child: productList()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DotsIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  DotsIndicator({required this.currentPage, required this.totalPages});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: index == currentPage ? Colors.blueAccent : Colors.grey,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
