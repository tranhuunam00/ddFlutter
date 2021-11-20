import 'dart:async';

import 'package:app1/feed/model/feed_model.dart';
import 'package:app1/model/user_model.dart';

class MyStream {
  UserModel userS = UserModel();
  List<FeedBaseModel> listFeedsS = [];
  StreamController<UserModel> userController =
      new StreamController<UserModel>.broadcast();

  StreamController<List<FeedBaseModel>> feedController =
      new StreamController<List<FeedBaseModel>>.broadcast();

  Stream<UserModel> get userStream => userController.stream;
  Stream<List<FeedBaseModel>> get feedStream => feedController.stream;
  void setUser(user) {
    print("setUser");
    userController.sink.add(user);
  }

  void setFeed(feed) {
    feedController.sink.add(feed);
  }

  void clearUser() {
    print("clearUser");
    userController.sink.add(UserModel());
  }

  void dispose() {
    userController.close();
  }
}
