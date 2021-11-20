import 'package:app1/chat-app/screens_chat/CameraScreen.dart';
import 'package:app1/chat-app/screens_chat/LoginScreen.dart';
import 'package:app1/chat-app/screens_chat/home.dart';
import 'package:app1/model/user_model.dart';
import 'package:app1/provider/user_provider.dart';
import 'package:app1/test_emoji.dart';
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
final UserModel userMain = UserModel();
const SERVER_IP = 'http://3afb-2401-d800-f133-7919-56a-c92b-7c2d-9236.ngrok.io';

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
    return ChangeNotifierProvider(
        create: (context) {
          // return GoogleSingInProvider();
          return UserProvider();
        },
        child: MaterialApp(
            title: "app1",
            // home: ChatLoginScreen()
            home: LoadScreen()

            // home: Test()
            // home: Test()

            ));
  }
}
