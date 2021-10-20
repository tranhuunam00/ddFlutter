import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
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
  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
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
              AppBTnStyle(
                  label: "Đăng nhập",
                  onTap: () async {
                    
                    var url = Uri.parse(
                        'https://b329-2401-d800-5f12-1851-88f5-2a21-5743-ed71.ngrok.io/user');
                    var response = await http.get(url);
                    print('Response status: ${response.statusCode}');
                    print('Response body: ${response.body}');
                  }),
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
