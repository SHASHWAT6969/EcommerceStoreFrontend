import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:online_store/users/authentication/login_screen.dart';
import 'package:online_store/users/userPreferences/current_user.dart';
import 'package:online_store/users/userPreferences/user_preferences.dart';
import 'package:geolocator/geolocator.dart';

class ProfileFragmentScreen extends StatefulWidget {
  @override
  _ProfileFragmentScreenState createState() => _ProfileFragmentScreenState();
}

class _ProfileFragmentScreenState extends State<ProfileFragmentScreen> {
  final CurrentUser _currentUser = Get.put(CurrentUser());
  String _currentLocation = "Fetching location..."; // Placeholder text for location

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Fetch location when the screen is loaded
  }

  // Function to get the current location
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _currentLocation = "Location services are disabled.";
      });
      return;
    }

    // Check for permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _currentLocation = "Location permission denied.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _currentLocation = "Location permissions are permanently denied.";
      });
      return;
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentLocation =
      "Lat: ${position.latitude}, Long: ${position.longitude}";
    });
  }

  signOut() async {
    var resultResponse = await Get.dialog(AlertDialog(
      backgroundColor: Colors.grey,
      title: const Text(
        "Sign out",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      content: const Text("Are you sure?\nYou want to log out?"),
      actions: [
        TextButton(
            onPressed: () {
              Get.back(result: "LoggedOut");
            },
            child: Text("Yes", style: TextStyle(color: Colors.redAccent))),
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text("No", style: TextStyle(color: Colors.black))),
      ],
    ));
    if (resultResponse == "LoggedOut") {
      // Delete-remove the user data from the local storage
      RememberUserPrefs.removeUserInfo();
      Get.off(loginscreen());
    }
  }

  Widget userInfoItemProfile(IconData iconData, String userData) {
    return Center(
      child: Container(
        width: 400, // Reduced width
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(iconData, size: 30, color: Colors.black),
            const SizedBox(width: 16),
            Text(userData, style: TextStyle(fontSize: 15, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          Center(
            child: Image.asset("assets/images/boy.png", width: 240),
          ),
          SizedBox(height: 100),
          userInfoItemProfile(Icons.person, _currentUser.user.user_name),
          SizedBox(height: 20),
          userInfoItemProfile(Icons.mail, _currentUser.user.user_email),
          SizedBox(height: 20),
          userInfoItemProfile(Icons.location_on, _currentLocation), // Show location here
          SizedBox(height: 80),
          Center(
            child: Material(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () {
                  signOut();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  child: Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
