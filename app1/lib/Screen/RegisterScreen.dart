import 'package:flutter/material.dart';
import '../widgets/text_input_style.dart';

import "../widgets/dismit_keybord.dart";
import '../widgets/app_button.dart';
import "../widgets/background.dart";
import '../ui.dart';
import './LoginScreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                  "Đăng ký",
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
                textEditController: _passwordController,
                hintTextString: 'Mật khẩu',
                inputType: InputType.Password,
                enableBorder: true,
                themeColor: Theme.of(context).primaryColor,
                cornerRadius: 48.0,
                maxLength: 24,
                prefixIcon:
                    Icon(Icons.lock, color: Theme.of(context).primaryColor),
                textColor: Colors.black,
                textInit: initText,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: TextField(
                    controller: _rePasswordController,
                    decoration: InputDecoration(
                      hintText: "Nhập lại mật khẩu",
                      errorText: _isValidate ? null : validationMessage,
                      counterText: '',
                      border: getBorder(),
                      enabledBorder: getBorder(),
                      focusedBorder: getBorder(),
                      labelText: "Nhập lại mật khẩu",
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Theme.of(context).primaryColor,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _visibility = !_visibility;
                          setState(() {});
                        },
                        icon: Icon(
                          _visibility ? Icons.visibility : Icons.visibility_off,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    obscureText: !_visibility,
                    onChanged: (String textInput) {
                      setState(() {
                        _isValidate = textInput == _passwordController.text;
                        validationMessage = 'Mật khẩu nhập lại không chính xác';
                      });
                    }),
              ),
              AppBTnStyle(
                  label: "Đăng ký",
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
            ],
          ),
        )),
      ),
    );
  }
}
