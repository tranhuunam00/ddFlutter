import 'package:app1/feed/model/feed_model.dart';
import 'package:app1/model/user_model.dart';
import 'package:app1/provider/Stream/user_stream.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

class UserProvider with ChangeNotifier {
  MyStream myStream = new MyStream();
  UserModel userP = UserModel(userName: "");
  String jwtP = "";
  List<FeedBaseModel> listFeedsP = [];
  Future userLogin(UserModel user, String jwt) async {
    try {
      userP = user;
      jwtP = jwt;
      myStream.setUser(user);
    } catch (e) {}
    notifyListeners();
  }

  Future userFeed(List<FeedBaseModel> newFeeds) async {
    try {
      listFeedsP = newFeeds;
      myStream.setFeed(newFeeds);
    } catch (e) {}
    notifyListeners();
  }

  Future UserLogOut() async {
    userP = UserModel();
  }
}
