import 'dart:convert';

import 'package:app1/main.dart';
import 'package:app1/provider/notifi_provider.dart';
import 'package:app1/widgets/Notify_card.dart';
import 'package:app1/widgets/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class NotifiScreen extends StatefulWidget {
  const NotifiScreen({Key? key}) : super(key: key);

  @override
  _NotifiScreenState createState() => _NotifiScreenState();
}

class _NotifiScreenState extends State<NotifiScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final notifiProvider = Provider.of<NotifiProvider>(context, listen: false);
    return Consumer<NotifiProvider>(builder: (context, notifiProvider, child) {
      return Scaffold(
          appBar: AppBar(title: Text("Thông báo")),
          body: ListView.builder(
              itemCount: notifiProvider.listNotifiP.length,
              itemBuilder: (context, index) {
                return Notify_Card(
                  idUserSource: notifiProvider.listNotifiP[index].sourceIdUser,
                  realNameSource:
                      notifiProvider.listNotifiP[index].sourceRealnameUser,
                  isSeen: notifiProvider.listNotifiP[index].isSeen,
                  createdAt: notifiProvider.listNotifiP[index].createdAt,
                  content: notifiProvider.listNotifiP[index].content,
                  pathImgSource:
                      notifiProvider.listNotifiP[index].sourceUserPathImg,
                  type: notifiProvider.listNotifiP[index].type,
                );
              }));
    });
  }
}

Future<dynamic> getApi(String jwt, String pathApi) async {
  print("get Api " + pathApi);
  print(jwt);
  var res = await http.get(
    Uri.parse(SERVER_IP + pathApi),
    headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'cookie': "jwt=" + jwt,
    },
  );
  if (res.statusCode == 200 || res.statusCode == 201) {
    var data = json.decode(res.body);
    print("result " + pathApi);
    print(data);
    return data;
  } else {
    return "error";
  }
}
