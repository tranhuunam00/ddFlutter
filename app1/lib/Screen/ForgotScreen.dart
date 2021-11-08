import 'dart:convert';

import 'package:app1/Screen/AgainPassword.dart';
import 'package:app1/main.dart';
import 'package:app1/model/create_user.dart';
import 'package:app1/model/forgot_user.dart';
import 'package:flutter/material.dart';
import '../ui.dart';
import '../widgets/text_input_style.dart';

import "../widgets/dismit_keybord.dart";
import '../widgets/app_button.dart';
import "../widgets/background.dart";
import 'package:http/http.dart' as http;

import './LoginScreen.dart' '';
import './RegisterScreen.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({Key? key}) : super(key: key);

  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  late FocusNode? myFocusNode;
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  bool _isValidate = true;
  String validationMessage = "";
  bool _visibility = true;
  @override
  Widget build(BuildContext context) {
    OutlineInputBorder getBorder() {
      return OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(48.0)),
        borderSide: BorderSide(width: 2, color: Theme.of(context).primaryColor),
        gapPadding: 2,
      );
    }

    var urlRegisterConfirm = Uri.parse(SERVER_IP + '/auth/forgotPassword');

    Future<UserForgotModel> forgotPwFunction(
        String userName, String email) async {
      http.Response response;
      response = await http.post(urlRegisterConfirm,
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({"userName": userName, "email": email}));

      print("da lay thanh cong");
      var a = json.decode(response.body);

      if (a == "error") {
        return new UserForgotModel();
      }
      UserForgotModel b = new UserForgotModel(
        userName: a["userName"],
        email: a["email"],
        token: a["token"].toString(),
      );

      return b;
    }

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
                padding: const EdgeInsets.only(top: 100, bottom: 60),
                child: Text(
                  "Quên mật khẩu",
                  style: AppStyles.h2,
                ),
              ),
              CustomTextInput(
                textEditController: _userNameController,
                hintTextString: 'Tên người dùng',
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
                textEditController: _emailController,
                hintTextString: 'Email',
                inputType: InputType.Email,
                enableBorder: true,
                themeColor: Theme.of(context).primaryColor,
                cornerRadius: 48.0,
                maxLength: 24,
                prefixIcon:
                    Icon(Icons.person, color: Theme.of(context).primaryColor),
                textColor: Colors.black,
                textInit: initText,
              ),
              (_userNameController.text.length >= 6 == true &&
                      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(_emailController.text))
                  ? AppBTnStyle(
                      label: "Gửi",
                      onTap: () async {
                        UserForgotModel a = await forgotPwFunction(
                            _userNameController.text, _emailController.text);
                        if (a.userName != "") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (builder) => AgainForgotScreen(
                                    userName: a.userName,
                                    email: a.email,
                                    token: a.token),
                              ));
                        } else {
                          print("sai");
                        }
                      })
                  : AppBTnStyle(
                      label: "Gửi",
                      onTap: null,
                      color: Color.fromRGBO(255, 255, 255, 0.4),
                    ),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => LoginScreen()));
                  },
                  child: RichText(
                      text: TextSpan(
                          text: "bạn đã có tài khoản     ",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          children: [
                        TextSpan(
                          text: "ĐĂNG NHẬP",
                          style: TextStyle(color: Colors.orangeAccent),
                        )
                      ]))),
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
