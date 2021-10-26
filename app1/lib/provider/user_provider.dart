import 'package:app1/Stream/user_stream.dart';
import 'package:app1/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

class UserProvider with ChangeNotifier {
  MyStream myStream = new MyStream();
  UserModel userP = UserModel(userName: "");
  Future userLogin(UserModel user) async {
    try {
      userP = user;
      myStream.setUser(user);
    } catch (e) {}

    notifyListeners();
  }

  Future UserLogOut() async {
    userP = UserModel();
  }
}
