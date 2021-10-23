import 'dart:convert';

import 'package:app1/chat-app/model/message_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  late List data;
  int i = 0;
  late List<MessageModel> messages = [];
  late MessageModel a;
  late List<int> b = [];

  Future fetchData() async {
    http.Response response;
    List<MessageModel> data1 = [];
    response = await http
        .get(Uri.parse('http://4698-14-235-182-226.ngrok.io/message'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else
      return [];
  }

  getMessage() async {
    List<int> c;
    List data = await fetchData();
    print("gia tri cua a");
    print(data);
    for (i = 0; i < data.length; i++) {
      a = MessageModel(
          type: "type",
          message: "message",
          path: "path",
          time: DateTime.now().toString().substring(10, 16));
      print('messageModel');
      print(a);
      b.add(i);
      messages.add(a);
      print("...................");
      print(messages);
      print(b);
    }
    print(messages[0].time);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getMessage();
  }

  @override
  Widget build(BuildContext context) {
    print("b laf");
    print(b);
    if (messages.length > 0) {}
    return Container(
      child: Text(messages.length > 0 ? messages[0].message : "hihi"),
    );
  }
}
