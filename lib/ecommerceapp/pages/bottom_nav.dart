import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:functionalitydemo/ecommerceapp/pages/home.dart';
import 'package:functionalitydemo/ecommerceapp/pages/order.dart';
import 'package:functionalitydemo/ecommerceapp/pages/profile.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late Home home;
  late Order order;
  late Profile profile;
  late List pages;
  int currentIndex = 0;

  @override
  void initState() {
    home = Home();
    order = Order();
    profile = Profile();
    pages = [home, order, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
        bottomNavigationBar: CurvedNavigationBar(
            height: 60.0,
            animationDuration: Duration(seconds: 1),
            backgroundColor: Colors.white,
            color: Colors.black,
            onTap: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            items: [
              Icon(Icons.home_outlined,color: Colors.white,),
              Icon(Icons.shopping_bag_outlined,color: Colors.white,),
              Icon(Icons.person_outlined,color: Colors.white,),
            ]),
            body: pages[currentIndex],
            );
  }
}
