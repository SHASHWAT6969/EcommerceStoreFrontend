import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user.dart';

class RememberUserPrefs {
  // Save - remember User-info
  static Future<void> storeUserInfo(User userInfo) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userJsonData = jsonEncode(userInfo.toJson());
    await preferences.setString('currentUser', userJsonData);
  }

  // Get - read User-info
  static Future<User?> readUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userInfo = preferences.getString("currentUser");

    if (userInfo != null) {
      Map<String, dynamic> userDataMap = jsonDecode(userInfo);
      return User.fromJson(userDataMap); // Ensure this returns a User object
    }

    return null; // If no user data found
  }
  static Future<void> removeUserInfo() async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("currentUser");

  }
}
