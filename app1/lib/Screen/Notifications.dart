import 'package:app1/widgets/Notify_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotifiScreen extends StatefulWidget {
  const NotifiScreen({Key? key}) : super(key: key);

  @override
  _NotifiScreenState createState() => _NotifiScreenState();
}

class _NotifiScreenState extends State<NotifiScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Thông báo")),
        body: ListView.builder(
            itemCount: 4,
            itemBuilder: (context, index) {
              return Notify_Card();
            }));
  }
}
