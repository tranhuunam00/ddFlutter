import 'dart:convert';

import 'package:app1/Screen/Profile.dart';
import 'package:app1/Screen/SettingUser.dart';
import 'package:app1/chat-app/model/message_model.dart';

import 'package:app1/main.dart';
import 'package:app1/model/friendUser.dart';
import 'package:app1/model/user_model.dart';
import 'package:app1/provider/message_provider.dart';
import 'package:app1/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/text_input_style.dart';
import 'package:http/http.dart' as http;
import "../widgets/dismit_keybord.dart";
import '../widgets/app_button.dart';
import "../widgets/background.dart";
import '../ui.dart';
import "./RegisterScreen.dart";
import "./ForgotScreen.dart";
import 'MainScreen.dart';
import 'package:provider/provider.dart';
import '../auth_social/google_sign_in.dart';
import '../auth_social/facebook_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late FocusNode? myFocusNode;
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  var urlGetUserJwt = Uri.parse(SERVER_IP + '/user/userJwt');
  var urlLogin = Uri.parse(SERVER_IP + '/auth/login');
  bool isValidInput = false;
  Future<String> attemptLogIn(String userName, String password) async {
    var res = await http.post(urlLogin,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({"userName": userName, "password": password}));
    if (res.statusCode == 200 || res.statusCode == 201) {
      var jwt = (res.body);
      print(jwt);
      return jwt;
    }
    return "error";
  }

  Future<UserModel> getUserJwt(String jwt) async {
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
      if (data != "not jwt") {
        if (data["userName"] != null) {
          print(data);
          UserModel user = UserModel(
              userName: data["userName"],
              email: data["email"],
              id: data["_id"],
              realName: data["realName"],
              friend: data["friend"],
              friendRequest: data["friendRequest"],
              friendConfirm: data["friendConfirm"],
              avatarImg: data["avatarImg"],
              hadMessageList: data["hadMessageList"],
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

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final messageProvider =
        Provider.of<MessageProvider>(context, listen: false);
    print(userMain.userName);
    Size size = MediaQuery.of(context).size;

    String initText = "";
    // _passwordController.text = "hihi";
    var currentFocus;
    return Scaffold(
      body: DismissKeyboard(
        child: Background(
            Column: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: Text(
                  "Đăng nhập",
                  style: AppStyles.h2,
                ),
              ),
              CustomTextInput(
                textEditController: _userNameController,
                hintTextString: 'Tên đăng nhập',
                inputType: InputType.Default,
                enableBorder: true,
                themeColor: Theme.of(context).primaryColor,
                cornerRadius: 48.0,
                maxLength: 24,
                prefixIcon:
                    Icon(Icons.person, color: Theme.of(context).primaryColor),
                textColor: Colors.black,
                textInit: initText,
              ),
              CustomTextInput(
                textEditController: _passwordController,
                hintTextString: 'Mật khẩu',
                inputType: InputType.Default,
                enableBorder: true,
                themeColor: Theme.of(context).primaryColor,
                cornerRadius: 48.0,
                maxLength: 24,
                prefixIcon:
                    Icon(Icons.lock, color: Theme.of(context).primaryColor),
                textColor: Colors.black,
                textInit: initText,
              ),
              (_userNameController.text.length >= 6 == true &&
                      _passwordController.text.length >= 6 == true)
                  ? AppBTnStyle(
                      label: "Đăng nhập",
                      onTap: () async {
                        print(isValidInput);
                        var userName = _userNameController.text;
                        var password = _passwordController.text;
                        print(
                            "userName: " + userName + " password: " + password);
                        var jwt = await attemptLogIn(userName, password);

                        if (jwt != "" && jwt != "isLogin" && jwt != "error") {
                          print("jwt: " + jwt);
                          await storage.write(key: "jwt", value: jwt);
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setString('jwt', jwt);
                          UserModel user = await getUserJwt(jwt);
                          if (user.userName != "") {
                            userProvider.userLogin(user, jwt);
                            Map<String, List<MessageModel>> listMsgInit = {};
                            Map<String, UserModel> listFrInit = {};
                            Map<String, UserModel> listHadChat = {};

                            listMsgInit = await getAllMsgFr(
                                jwt,
                                20,
                                0,
                                "/message/allMsgFR",
                                user.id,
                                user.hadMessageList);
                            listFrInit = await getFriendUser(jwt,
                                "/user/allAvatarFr/" + user.id, user.friend);
                            listHadChat = await getFriendUser(jwt,
                                "/user/allInforHadChat", user.hadMessageList);
                            print("user lấy đc khi login---------" +
                                user.userName);
                            messageProvider.userMessage(listMsgInit);
                            userProvider.userFriends(listFrInit);
                            userProvider.userHadChats(listHadChat);
                            if (user.realName == "user") {
                              print("---chưa nhập thông tin---mới ");
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SettingUser()));
                            }
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainScreen()));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          }
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        }
                        // UserModel userTest = UserModel(userName: "linh tinh ");
                        // userProvider.userLogin(userTest);
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => MainScreen()));
                      })
                  : AppBTnStyle(
                      onTap: null,
                      color: Color.fromRGBO(255, 255, 255, 0.4),
                      label: "Đăng nhập",
                    ),
              Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: AppBTnStyle(
                    label: "Đăng nhập bằng facebook",
                    icon: Icons.facebook,
                    onTap: () {
                      final provider = Provider.of<GoogleSingInProvider>(
                          context,
                          listen: false);
                      provider.FacebookLogin();
                    }),
              ),
              AppBTnStyle(
                  label: "Đăng nhập bằng google",
                  icon: Icons.search,
                  onTap: () {
                    final provider = Provider.of<GoogleSingInProvider>(context,
                        listen: false);
                    provider.googleLogin();
                  }),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ForgotScreen()));
                    },
                    child: Text(
                      "quên mật khẩu",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    )),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => RegisterScreen()));
                  },
                  child: RichText(
                      text: TextSpan(
                          text: "bạn chưa có tài khoản     ",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          children: [
                        TextSpan(
                          text: "ĐĂNG KÝ",
                          style: TextStyle(color: Colors.orangeAccent),
                        )
                      ]))),
            ],
          ),
        )),
      ),
    );
  }
}

Future<Map<String, List<MessageModel>>> getAllMsgFr(String jwt, int limit,
    int offset, String path, String sourceUserId, List hadMessageList) async {
  Map<String, List<MessageModel>> chatHad = {};

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
