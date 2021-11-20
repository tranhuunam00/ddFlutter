import 'dart:convert';

import 'package:app1/main.dart';
import 'package:app1/model/user_model.dart';
import 'package:app1/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import "../ui.dart";
import 'package:shared_preferences/shared_preferences.dart';
import "LoginScreen.dart";

import '../Screen/MainScreen.dart';
import 'package:http/http.dart' as http;

class LoadScreen extends StatefulWidget {
  const LoadScreen({Key? key}) : super(key: key);

  @override
  State<LoadScreen> createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> {
  late Socket socket;
  int _counter = 0;
  String jwt = "";
  UserModel userInit = UserModel();

  @override
  void initState() {
    super.initState();
    _loadJwtAndUserInit();
  }

  //--------------------connect socket và đăng nhập nếu oki-----------------------
  void connect(String jwt, String id) {
    print("---------begin connect.. socket..................");
    socket = io(SERVER_IP, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      'cookie': "jwt=" + jwt,
    });
    socket.connect();
    print(socket.connected);
    socket.emit("signin", id);
    socket.onConnect((data) {
      print("connected");
      socket.on("test", (msg) {
        print(msg);
      });
    });
  }

  //-------------------load jwt lưu trong local và chạy hàm gét userinit---------------------------
  void _loadJwtAndUserInit() async {
    final prefs = await SharedPreferences.getInstance();
    jwt = await (prefs.getString('jwt') ?? "");
    print("----jwt Init ----" + jwt);
    var data =
        await Future.wait([getUserJwt(jwt), getApi(jwt, "/user/allAvatarFr")]);
    userInit = data[0];
    print(userInit);
    if (userInit.userName != "") {
      // connect(jwt, userInit.id);
      setState(() {
        jwt = (prefs.getString('jwt') ?? "");
      });
    }
  }

  //......................lấy dữ liệu user ban đầu-------------------------
  var urlGetUserJwt = Uri.parse(SERVER_IP + '/user/userJwt');
  Future<UserModel> getUserJwt(String jwt) async {
    print(jwt);
    var res = await http.get(
      urlGetUserJwt,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'cookie': "jwt=" + jwt,
      },
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      var data = json.decode(res.body);
      if (data != "not jwt" && data != "error") {
        if (data["userName"] != null) {
          print(data);
          UserModel user = UserModel(
              userName: data["userName"],
              email: data["email"],
              id: data["_id"],
              friend: data["friend"],
              avatarImg: data["avatarImg"],
              coverImg: data["coverImg"]);
          return user;
        }
      }
    }

    return UserModel();
  }

  Future<dynamic> getApi(String jwt, String pathApi) async {
    print("get Api " + pathApi);
    print(jwt);
    var res = await http.get(
      Uri.parse(SERVER_IP + pathApi),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'cookie': "jwt=" + jwt,
      },
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      var data = json.decode(res.body);
      print("result " + pathApi);
      print(data);
      return data;
    } else {
      return "error";
    }
  }

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
                        if (userInit.userName != "") {
                          userProvider.userLogin(userInit, jwt);
                        }
                        print(userProvider.userP.userName);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) =>
                                    userProvider.userP.userName != "" ||
                                            userInit.userName != ""
                                        ? MainScreen()
                                        : LoginScreen()));
                      },
                      child: Image.asset(AppImages.nature)))
            ])));
  }
}
