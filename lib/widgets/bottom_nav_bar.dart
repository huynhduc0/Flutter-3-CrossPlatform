import 'package:flutter/material.dart';
import 'package:flutter_food_ordering/constants/values.dart';
import 'package:flutter_food_ordering/pages/home_page.dart';
import 'package:flutter_food_ordering/pages/user_profile.dart';

import '../pages/user_profile.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentIndex = 0;

  final List<Widget> viewContainer = [
    MyHomePage(),
    MyHomePage(),
    UserProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    void onTabTapped(int index) {
      setState(() {
        currentIndex = index;
      });
    }

    return Scaffold(
        body: viewContainer[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            onTap: onTabTapped,
            currentIndex: currentIndex,
            fixedColor: Colors.red,
            items: [
              // BottomNavigationBarItem(
              //   icon: Container(
              //     width: MediaQuery.of(context).size.width,
              //     height: MediaQuery.of(context).size.height,
              //     child: Icon(currentIndex == 0 ? Icons.cached : Icons.home_outlined),
              //   ),
              //   title: Text(""),
              // ),
              BottomNavigationBarItem(
                icon: Icon(currentIndex == 0
                    ? Icons.home_filled
                    : Icons.home_outlined),
                title: Text(""),
              ),
              BottomNavigationBarItem(
                icon: Icon(currentIndex == 1
                    ? Icons.notifications
                    : Icons.notifications_none_outlined),
                title: Text(""),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                    currentIndex == 2 ? Icons.person : Icons.person_outline),
                title: Text(""),
              ),
            ]));
  }
}
