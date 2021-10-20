import 'package:app1/chat-app/screens_chat/CameraScreen.dart';
import 'package:app1/chat-app/screens_chat/LoginScreen.dart';
import 'package:app1/chat-app/screens_chat/home.dart';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import "package:app1/ui.dart";
import "Screen/LoadScreen.dart";
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'auth_social/google_sign_in.dart';
import 'package:flutter/foundation.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:provider/provider.dart';

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
  void initState() {
    IO.Socket socket = IO.io('http://localhost:3000');
    socket.onConnect((_) {
      print('connect');
      socket.emit('msg', 'test');
    });
    socket.on('msg', (data) => print(data));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) {
          return GoogleSingInProvider();
        },
        child: MaterialApp(
            title: "app1",
            // home: LoadScreen())
            home: ChatLoginScreen()));
  }
}
