import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Widget_box/product_controller.dart';
import '../users/userPreferences/current_user.dart';

class AnimatedLikeButton extends StatefulWidget {
  final int product_id;

  AnimatedLikeButton({required this.product_id});

  @override
  _AnimatedLikeButtonState createState() => _AnimatedLikeButtonState();
}

class _AnimatedLikeButtonState extends State<AnimatedLikeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final CurrentUser _currentUser = Get.put(CurrentUser());
  final ProductController controller = Get.put(ProductController());
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    // Check if the product is liked when the widget is initialized
    _checkIfLiked();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkIfLiked() async {
    final String url = 'http://10.0.2.2/clothesapp_api/user/check_like.php';
    final response = await http.post(Uri.parse(url), body: {
      'user_id': _currentUser.user.user_id.toString(),
      'product_id': widget.product_id.toString(),
    });

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      setState(() {
        isLiked = result['isLiked'] == 'true'; // Assuming your API returns 'true' or 'false'
        // Reset the animation if already liked
        if (isLiked) {
          _controller.value = 1.0; // Ensure the animation starts from normal size
        }
      });
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  Future<void> _toggleLike() async {
    final String url = 'http://10.0.2.2/clothesapp_api/user/like.php';
    final response = await http.post(Uri.parse(url), body: {
      'user_id': _currentUser.user.user_id.toString(),
      'product_id': widget.product_id.toString(),
      'isLiked': isLiked.toString(),
    });

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['success']) {
        print('Like state updated successfully');
      } else {
        print('Failed to update like state');
      }
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isLiked) {
            Fluttertoast.showToast(
              msg: 'Item removed from cart',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM, // or ToastGravity.TOP for top position
              backgroundColor: Colors.black.withOpacity(0.7),
              textColor: Colors.white,
              fontSize: 16.0,
              webBgColor: "#000000",
              webPosition: "bottom",
              timeInSecForIosWeb: 1,
              // You can set padding if you want more height from the bottom
            );

            _controller.reverse();
          } else {
            Fluttertoast.showToast(
              msg: 'Item added to cart',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.black.withOpacity(0.7),
              textColor: Colors.white,
              fontSize: 16.0,
            );
            _controller.forward();

          }
          isLiked = !isLiked; // Toggle the like state
        });

        // Call the function to toggle like in the database
        _toggleLike();
      },
      child: ScaleTransition(
        scale: _animation,
        child: Icon(
          isLiked ? Icons.shopping_cart_rounded : Icons.shopping_cart_outlined,
          color: isLiked ? Colors.red : Colors.white24,
          size: 30, // Ensure consistent size
        ),
      ),
    );
  }
}
