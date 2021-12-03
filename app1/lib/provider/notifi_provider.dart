import 'package:app1/chat-app/model/message_model.dart';
import 'package:app1/feed/model/feed_model.dart';
import 'package:app1/model/friendUser.dart';
import 'package:app1/model/notifi_modal.dart';
import 'package:app1/model/user_model.dart';
import 'package:app1/provider/Stream/user_stream.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

class NotifiProvider with ChangeNotifier {
  MyStream myStream = new MyStream();

  List<NotifiModel> listNotifiP = [];
  Future userNotifi(List<NotifiModel> newNotifis) async {
    try {
      listNotifiP = newNotifis;
      myStream.setFeed(newNotifis);
    } catch (e) {}
    notifyListeners();
  }
}
