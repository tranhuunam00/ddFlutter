import 'dart:convert';

import 'package:app1/main.dart';
import 'package:app1/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './Profile.dart';
import './HomeScreen.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key, required this.user}) : super(key: key);
  final UserModel user;
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<Widget> _widgetOptions = [
    HomeScreen(),
    Profile(),
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  // color: Colors.grey[500],
                ),
                title: Container(
                  child: Text("home"),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide()),
                  ),
                ),
                backgroundColor: Colors.green),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                title: SizedBox(),
                backgroundColor: Colors.yellow),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
              ),
              title: SizedBox(),
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              title: SizedBox(),
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.notification_important_outlined,
              ),
              title: SizedBox(),
              backgroundColor: Colors.blue,
            ),
          ],
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.grey[500],
          selectedFontSize: 14,
          unselectedFontSize: 14,
          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.orange,
          iconSize: 26,
          elevation: 5),
    );
  }
}
