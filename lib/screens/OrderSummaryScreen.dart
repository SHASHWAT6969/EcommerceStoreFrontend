import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../users/fragments/razorpay_payment.dart';
 // Import RazorpayPayment screen

class OrderSummaryScreen extends StatelessWidget {
  final List<dynamic> products;
  final int userId;

  OrderSummaryScreen({required this.products, required this.userId});

  // Function to calculate the total amount including GST and delivery charges
  double _calculateTotalAmount() {
    double gst = products.fold(0.0, (sum, product) {
      double price = double.tryParse(product['price'].toString()) ?? 0.0;
      int quantity = int.tryParse(product['quantity'].toString()) ?? 1;
      return sum + (price * quantity * 0.18);
    });
    double deliveryCharges = 5.00;
    double subtotal = products.fold(0.0, (sum, product) {
      double price = double.tryParse(product['price'].toString()) ?? 0.0;
      int quantity = int.tryParse(product['quantity'].toString()) ?? 1;
      return sum + (price * quantity);
    });
    return subtotal + gst + deliveryCharges;
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = _calculateTotalAmount(); // Get the total amount including GST and delivery charges

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  double price = double.tryParse(product['price'].toString()) ?? 0.0;
                  int quantity = int.tryParse(product['quantity'].toString()) ?? 1;

                  return ListTile(
                    title: Text('${product['name']}'),
                    subtitle: Text('Quantity: $quantity'),
                    trailing: Text('\$${(price * quantity).toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            Divider(),
            Text('Subtotal: \$${(totalAmount - 5.00 - 0.18 * totalAmount).toStringAsFixed(2)}'), // Subtotal without GST & delivery
            Text('GST (18%): \$${(0.18 * totalAmount).toStringAsFixed(2)}'),
            Text('Delivery Charges: \$5.00'),
            Divider(),
            Text(
              'Total: \$${totalAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Pass the total amount, userId, and products list to RazorpayPayment screen
                Get.to(() => RazorpayPayment(
                  amount: totalAmount,
                  userId: userId,
                  products: products, // Pass products list to RazorpayPayment
                ));
              },
              child: Text('Proceed to Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
