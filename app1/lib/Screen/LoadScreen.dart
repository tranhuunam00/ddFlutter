import 'dart:convert';

import 'package:app1/chat-app/model/message_model.dart';
import 'package:app1/main.dart';
import 'package:app1/model/friendUser.dart';
import 'package:app1/model/user_model.dart';
import 'package:app1/provider/message_provider.dart';
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
  int _counter = 0;
  bool isLoading = true;
  String jwt = "";
  UserModel userInit = UserModel(
      friend: [],
      friendConfirm: [],
      friendRequest: [],
      coverImg: [],
      avatarImg: [],
      hadMessageList: []);
  Map<String, List<MessageModel>> listMsgInit = {};
  Map<String, UserModel> listFrInit = {};
  Map<String, UserModel> listHadChat = {};

  @override
  void initState() {
    super.initState();
    _loadJwtAndUserInit();
  }

  //-------------------load jwt lưu trong local và chạy hàm gét userinit---------------------------
  void _loadJwtAndUserInit() async {
    final prefs = await SharedPreferences.getInstance();
    jwt = await (prefs.getString('jwt') ?? "");
    print("----jwt Init ----" + jwt);
    if (jwt != null && jwt != "") {
      var data = await Future.wait(
          [getUserJwt(jwt), getApi(jwt, "/user/allAvatarFr")]);
      userInit = data[0];
      print(userInit);
      if (userInit.userName != "") {
        var result = await Future.wait([
          getFriendUser(
              jwt, "/user/allAvatarFr/" + userInit.id, userInit.friend),
          getFriendUser(jwt, "/user/allInforHadChat", userInit.hadMessageList)
        ]);
        listMsgInit = await getAllMsgFr(jwt, 20, 0, "/message/allMsgFR",
            userInit.id, userInit.hadMessageList);
        listFrInit = result[0];
        listHadChat = result[1];
        setState(() {
          jwt = (prefs.getString('jwt') ?? "");
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final messageProvider =
        Provider.of<MessageProvider>(context, listen: false);

    Future.delayed(const Duration(milliseconds: 4000), () {
      setState(() {
        isLoading = false;
      });
    });
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
                      onPressed: isLoading == false
                          ? () async {
                              if (userInit.userName != "") {
                                userProvider.userLogin(userInit, jwt);
                                messageProvider.userMessage(listMsgInit);
                                userProvider.userFriends(listFrInit);
                                userProvider.userHadChats(listHadChat);
                              }
                              print(userProvider.userP.userName);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) =>
                                          userProvider.userP.userName != "" ||
                                                  userInit.userName != ""
                                              ? MainScreen()
                                              : LoginScreen())).then(
                                  (value) => setState(() {
                                        isLoading = true;
                                      }));
                            }
                          : null,
                      child: Image.asset(AppImages.nature)))
            ])));
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
        print("Data cover----");
        print(data["coverImg"]);
        UserModel user = UserModel(
            userName: data["userName"],
            email: data["email"],
            id: data["_id"],
            friendRequest: data["friendRequest"],
            friendConfirm: data["friendConfirm"],
            friend: data["friend"],
            hadMessageList: data["hadMessageList"],
            avatarImg: data["avatarImg"],
            coverImg: data["coverImg"]);

        return user;
      }
    }
  }

  return UserModel(
      friend: [],
      friendConfirm: [],
      friendRequest: [],
      coverImg: [],
      avatarImg: [],
      hadMessageList: []);
}

//--------------------lay tat ca tin nhan ----------------------
Future<Map<String, List<MessageModel>>> getAllMsgFr(String jwt, int limit,
    int offset, String path, String sourceUserId, List hadMessageList) async {
  Map<String, List<MessageModel>> chatHad = {};
  List<MessageModel> output = [];
  chatHad["1"] = output;
  print("------chạy get all msg fr---------");
  String apiPath =
      path + "?limit=" + limit.toString() + "&offset=" + offset.toString();
  print(apiPath);
  var result = await getApi(jwt, apiPath);
  print("ket qua la :");
  print(result);

  if (result != "error" && result != "not listFrjwt") {
    for (var i = 0; i < hadMessageList.length; i++) {
      List msg = result[sourceUserId + "/" + hadMessageList[i]];
      List<MessageModel> output = [];
      for (var j = 0; j < msg.length; j++) {
        MessageModel a = MessageModel(
            path: msg[j]["path"],
            time: msg[j]["time"],
            message: msg[j]["message"],
            targetId: msg[j]["targetId"],
            sourceId: msg[j]["sourceId"]);

        output.add(a);
      }
      output.sort((a, b) => a.time.compareTo(b.time));
      chatHad[sourceUserId + "/" + hadMessageList[i]] = output;
    }
    return chatHad;
  }
  return chatHad;
}

//----------------------lay thoong tin cua toan bo ban be---------------
Future<Map<String, UserModel>> getFriendUser(
    String jwt, String path, List listFr) async {
  Map<String, UserModel> chatFriend = {};

  print("------chạy get avatar---------");
  var result = await getApi(jwt, path);
  print("ket qua la :");
  print(result);
  if (result != "error" && result != "not jwt") {
    for (var i = 0; i < listFr.length; i++) {
      chatFriend[listFr[i]] = UserModel(
          friend: [],
          friendConfirm: [],
          friendRequest: [],
          coverImg: [],
          hadMessageList: [],
          id: result[listFr[i]][2],
          avatarImg: [result[listFr[i]][0]],
          realName: result[listFr[i]][1]);
    }
  }
  return chatFriend;
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
