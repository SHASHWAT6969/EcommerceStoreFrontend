import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../userPreferences/current_user.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with SingleTickerProviderStateMixin {
  List<dynamic> orders = [];
  final CurrentUser _currentUser = Get.put(CurrentUser());
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/clothesapp_api/user/ordershowcase.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'user_id': _currentUser.user.user_id}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        setState(() {
          orders = data['orders'];
        });
      } else {
        print(data['message']);
      }
    } else {
      throw Exception('Failed to load orders');
    }

    // Simulate loading time
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background color
      appBar: AppBar(
        title: Text('Ordered Products'),
        backgroundColor: Colors.blueAccent, // AppBar color
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : orders.isEmpty
          ? Center(child: Text('No Products Found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          double price = double.tryParse(order['price'].toString()) ?? 0.0;
          int quantity = int.tryParse(order['quantity'].toString()) ?? 0;

          return AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: 1.0,
            child: GestureDetector(
              onTap: () {
                // Add navigation to order detail page if needed
              },
              child: Card(
                margin: EdgeInsets.all(10),
                elevation: 8, // Increase elevation for a better shadow effect
                color: Colors.white, // Card background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      order['image_url'] != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 80,
                          height: 80,
                          child: Image.network(
                            order['image_url'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                          : Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 5),
                            Divider(color: Colors.grey[300]), // Divider for better separation
                            Text('Order ID: ${order['order_id']}', style: TextStyle(color: Colors.grey[600])),
                            Text('Quantity: $quantity', style: TextStyle(color: Colors.grey[600])),
                            Text('Price: \$${price.toStringAsFixed(2)}', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                            Text('Total: \$${(price * quantity).toStringAsFixed(2)}', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                            Text('Order Date: ${order['order_date']}', style: TextStyle(color: Colors.grey[600])),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
