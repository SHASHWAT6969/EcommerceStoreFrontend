import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_store/users/authentication/login_screen.dart';
import 'package:online_store/users/fragments/dashBoard.dart';
import 'package:online_store/users/userPreferences/user_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'RETAIL STORE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
        home: FutureBuilder(
          future: RememberUserPrefs.readUserInfo(),
          builder: (context, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator()); // Show loading indicator
            }
            if (dataSnapshot.hasError) {
              return Center(child: Text('Error: ${dataSnapshot.error}')); // Handle error
            }
            if (dataSnapshot.data == null) {
              print("Shared pref has no data");
              return loginscreen(); // Ensure your login screen's name starts with a capital letter
            }
            return DashboardOfFragments();
          },
        )

      );
  }
}


