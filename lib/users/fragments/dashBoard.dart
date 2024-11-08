import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:online_store/users/fragments/favourites_fragment_screen.dart';
import 'package:online_store/users/fragments/home_fragments_screen.dart';
import 'package:online_store/users/fragments/order_fragmnets_screen.dart';
import 'package:online_store/users/fragments/profile_fragment_screen.dart';
import '../userPreferences/current_user.dart';

class DashboardOfFragments extends StatelessWidget {
  final CurrentUser _currentUser = Get.put(CurrentUser());
  final CurrentUser _rememberCurrentUser = Get.put(CurrentUser());

  // Initialize _fragmentScreens as a list of widgets
  late final List<Widget> _fragmentScreens;

  // Define navigation button properties
  final List<Map<String, dynamic>> _navigationButtonsProperties = [
    {
      "active_icon": Icons.home,
      "non_active_icon": Icons.home_outlined,
      "label": "Home"
    },
    {
      "active_icon": Icons.shopping_cart_rounded,
      "non_active_icon": Icons.shopping_cart_outlined,
      "label": "Cart"
    },
    {
      "active_icon": FontAwesomeIcons.boxOpen,
      "non_active_icon": FontAwesomeIcons.box,
      "label": "Orders"
    },
    {
      "active_icon": Icons.person,
      "non_active_icon": Icons.person_outlined,
      "label": "Profile"
    },
  ];

  // Reactive variable to track the index of the current screen
  final RxInt _indexNumber = 0.obs;

  DashboardOfFragments({Key? key}) : super(key: key) {
    // Initialize the fragment screens here
    _fragmentScreens = [
      HomeFragmentsScreen(),
      FavoritesScreen(),
      OrdersPage(),
      ProfileFragmentScreen()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CurrentUser>(
      init: CurrentUser(),
      initState: (currentState) {
        _rememberCurrentUser.getUserInfo();
      },
      builder: (controller) {
        return Scaffold(
          body: SafeArea(child: Obx(() => _fragmentScreens[_indexNumber.value])),
          backgroundColor: Colors.black,
          bottomNavigationBar: Obx(
                () => BottomNavigationBar(
              currentIndex: _indexNumber.value,
              items: List.generate(4, (index) {
                var navBtnProperty = _navigationButtonsProperties[index];
                return BottomNavigationBarItem(
                  backgroundColor: Colors.black,
                  icon: Icon(navBtnProperty["non_active_icon"]),
                  activeIcon: Icon(navBtnProperty["active_icon"]),
                  label: navBtnProperty["label"],
                );
              }),
              onTap: (value) {
                _indexNumber.value = value;
              },
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white24,
            ),
          ),
        );
      },
    );
  }
}
