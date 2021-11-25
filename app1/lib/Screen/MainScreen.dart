import 'dart:convert';

import 'package:app1/Screen/Notifications.dart';
import 'package:app1/Screen/SearchScreen.dart';
import 'package:app1/chat-app/screens_chat/LoginScreen.dart';
import 'package:app1/feed/model/feed_model.dart';
import 'package:app1/main.dart';
import 'package:app1/model/user_model.dart';
import 'package:app1/provider/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import './Profile.dart';
import './HomeScreen.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key? key,
  }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  int _numberNotifications = 0;
  late Socket socket;
  //----------connetc socket--------------------------------------------
  void connect(String jwt, String id) {
    print("begin connect....................");
    socket = io(SERVER_IP, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      'cookie': "jwt=" + jwt,
    });
    socket.connect();
    print(socket.connected);
    socket.emit("signin", id);
    socket.onConnect((data) {
      socket.on("test", (msg) {
        if (mounted) {
          setState(() {
            print("---chạy setstate- số thông báo--");
            _numberNotifications = _numberNotifications + 1;
          });
          print(msg);
        }
      });
      socket.on("message", (msg) {
        if (mounted) {
          setState(() {
            print("---chạy setstate- số thông báo--");
            _numberNotifications = _numberNotifications + 1;
          });
          print(msg);
        }
      });
      socket.on("likeFeed", (msg) {});
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index == 4) {
        _numberNotifications = 0;
      }
      ;
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final prefs = await SharedPreferences.getInstance();
      String jwt = await (prefs.getString('jwt') ?? "");
      connect(jwt, userProvider.userP.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_numberNotifications.toString());
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Widget> _widgetOptions = [
      HomeScreen(),
      Profile(),
      SearchScreen(),
      ChatLoginScreen(),
      NotifiScreen()
    ];
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
              title: _numberNotifications != 0
                  ? CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 9,
                      child: Text(_numberNotifications.toString()),
                    )
                  : SizedBox(),
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
