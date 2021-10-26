import 'package:app1/main.dart';
import 'package:app1/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "../ui.dart";

import "LoginScreen.dart";
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Screen/MainScreen.dart';

class LoadScreen extends StatelessWidget {
  const LoadScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    print(userProvider.userP.userName);
    return Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(children: [
              Expanded(
                  child: Container(
                alignment: Alignment.centerLeft,
                child: Text("Xin chào!!!", style: TextStyle(fontSize: 42)),
              )),
              Expanded(
                  child: Container(
                      color: Colors.blue,
                      child: Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: Text("English",
                                  style: TextStyle(fontSize: 60))),
                          Padding(
                            padding: const EdgeInsets.only(right: 30),
                            child: Text("Qoutes", style: AppStyles.h2),
                          ),
                        ],
                      ))),
              Expanded(
                  child: RawMaterialButton(
                      shape: CircleBorder(),
                      fillColor: Colors.green,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) =>
                                    userProvider.userP.userName == ""
                                        ? LoginScreen()
                                        : MainScreen()));
                      },
                      child: Image.asset(AppImages.nature)))
            ])));
  }
}
