import 'package:flutter/material.dart';
import '../ui.dart';
import '../widgets/text_input_style.dart';

import "../widgets/dismit_keybord.dart";
import '../widgets/app_button.dart';
import "../widgets/background.dart";

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
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();

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
              AppBTnStyle(
                  label: "Gửi",
                  onTap: () {
                    print(_passwordController.text);
                  }),
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
