import 'dart:async';

import 'package:app1/model/user_model.dart';

class MyStream {
  int counter = 0;
  UserModel userS = UserModel();
  StreamController counterController = new StreamController<int>();
  StreamController<UserModel> userController =
      new StreamController<UserModel>.broadcast();

  Stream get counterStream => counterController.stream;
  Stream<UserModel> get userStream => userController.stream;

  void increment() {
    counter += 1;
    counterController.sink.add(counter);
  }

  void setUser(user) {
    print("setUser");

    userController.sink.add(user);
  }

  void clearUser() {
    print("clearUser");
    userController.sink.add(UserModel());
  }

  void dispose() {
    counterController.close();
    userController.close();
  }
}
