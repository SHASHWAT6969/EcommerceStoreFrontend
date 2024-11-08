import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_store/users/fragments/dashBoard.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class RazorpayPayment extends StatefulWidget {
  final double amount; // Accept amount from the previous screen
  final int userId; // Pass userId to associate with the order
  final List<dynamic> products; // Pass products list from OrderSummaryScreen

  const RazorpayPayment({super.key, required this.amount, required this.userId, required this.products});

  @override
  State<RazorpayPayment> createState() => _RazorpayPaymentState();
}

class _RazorpayPaymentState extends State<RazorpayPayment> {
  late Razorpay _razorpay;
  bool isLoading = false;

  // Function to open the Razorpay payment gateway
  void openCheckout(double amount) async {
    if (amount <= 0) {
      Fluttertoast.showToast(msg: "Invalid amount");
      return;
    }

    int convertedAmount = (amount * 100).toInt(); // Convert amount to paise (integer)

    var options = {
      'key': 'rzp_test_Py1yzc7CHEHunB', // Test key, use live key in production
      'amount': convertedAmount,
      'name': 'E-Commerce Store',
      'prefill': {'contact': '1234567890', 'email': 'test123@gmail.com'},
      'external': {'wallets': ['paytm']}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error opening Razorpay: $e');
      Fluttertoast.showToast(msg: "Error opening payment gateway");
    }
  }

  // Payment Success handler
  void handlePaymentSuccess(PaymentSuccessResponse response) async {
    Fluttertoast.showToast(
      msg: 'Payment Successful: ${response.paymentId}',
      toastLength: Toast.LENGTH_SHORT,
    );

    // Order placement logic after successful payment
    await placeOrder(response.paymentId!);  // Pass paymentId to associate with order

    setState(() {
      isLoading = false; // Reset loading state
    });
  }

  // Payment Failure handler
  void handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: 'Payment Failed: ${response.message}',
      toastLength: Toast.LENGTH_SHORT,
    );
    setState(() {
      isLoading = false; // Reset loading state
    });
  }

  // External Wallet handler
  void handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: 'External Wallet: ${response.walletName}',
      toastLength: Toast.LENGTH_SHORT,
    );
    setState(() {
      isLoading = false; // Reset loading state
    });
  }

  // Function to place the order after successful payment
  Future<void> placeOrder(String paymentId) async {
    final url = 'http://10.0.2.2/clothesapp_api/user/order.php';  // Your API URL

    // Prepare the product data for the API request
    List<Map<String, dynamic>> products = widget.products.map((product) {
      return {
        'product_id': product['product_id'],
        'quantity': product['quantity'],
        'price': product['price']
      };
    }).toList();

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': widget.userId,  // Pass userId to associate the order
          'payment_id': paymentId,   // Store paymentId for the order
          'products': products,      // Pass products list to the backend
          'status': 'success',       // Order status as 'success' after payment
        }),
      );

      final responseData = json.decode(response.body);

      if (responseData['success']) {
        Fluttertoast.showToast(msg: 'Order placed successfully!');
        Get.offAll(DashboardOfFragments());
          // Pop Razorpay screen to navigate back
      } else {
        Fluttertoast.showToast(msg: 'Order placement failed: ${responseData['message']}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error placing order: $e');
    }
  }

  @override
  void dispose() {
    _razorpay.clear();  // Ensure resources are cleared when the screen is disposed
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Payment Gateway', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 100),
              Center(
                child: Image.network(
                  'https://imgs.search.brave.com/R6aeyNVesKe09SHgCZkhdKQK_8pf4jjrrKxHpcFeelA/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly90NC5m/dGNkbi5uZXQvanBn/LzAxLzc0LzcyLzMz/LzM2MF9GXzE3NDcy/MzM5M193b0ZsRUZ5/QUpXbzMyaVBud2di/eG05NE1XVWEzWUxm/Sy5qcGc',
                  width: 300,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Pay Here',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Text(
                'Amount: ₹${widget.amount.toStringAsFixed(2)}', // Display the amount passed from OrderSummaryScreen
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });
                  openCheckout(widget.amount); // Use the amount passed from OrderSummaryScreen
                },
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Make Payment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
