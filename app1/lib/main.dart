import 'package:app1/chat-app/screens_chat/CameraScreen.dart';
import 'package:app1/chat-app/screens_chat/LoginScreen.dart';
import 'package:app1/chat-app/screens_chat/home.dart';
import 'package:app1/feed/screen/comment.dart';
import 'package:app1/model/user_model.dart';
import 'package:app1/provider/feed_provider.dart';
import 'package:app1/provider/message_provider.dart';
import 'package:app1/provider/notifi_provider.dart';
import 'package:app1/provider/user_provider.dart';
import 'package:app1/test_emoji.dart';
import 'package:app1/widgets/search.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import "package:app1/ui.dart";
import "Screen/LoadScreen.dart";
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'auth_social/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:provider/provider.dart';

final storage = FlutterSecureStorage();
final UserModel userMain = UserModel(
    friend: [],
    friendConfirm: [],
    friendRequest: [],
    coverImg: [],
    avatarImg: [],
    hadMessageList: []);
const SERVER_IP = 'http://a8bd-123-18-252-204.ngrok.io';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print("start");
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) {
            return UserProvider();
          }),
          ChangeNotifierProvider(create: (context) {
            return MessageProvider();
          }),
          ChangeNotifierProvider(create: (context) {
            return FeedProvider();
          }),
          ChangeNotifierProvider(create: (context) {
            return NotifiProvider();
          })
        ],
        child: MaterialApp(
            title: "app1",
            // home: ChatLoginScreen()
            home: LoadScreen()
            //  home: Search()
            // home: Test()
            // home: Test()

            ));
  }
}
