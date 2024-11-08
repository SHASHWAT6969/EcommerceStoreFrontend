import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_store/users/userPreferences/user_preferences.dart';

import '../model/user.dart';
class CurrentUser extends GetxController
{
  Rx<User> _currentUser=User(0, '', '', '').obs;
  User get user=>_currentUser.value;
  getUserInfo()async
  {
    User? getUserInfoFromLocalStorage=await RememberUserPrefs.readUserInfo();
    _currentUser.value=getUserInfoFromLocalStorage!;
  }

}