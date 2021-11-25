import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Notify_Card extends StatelessWidget {
  const Notify_Card({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: ListTile(
              leading: CustomPaint(
                child: CircleAvatar(
                  radius: 26,
                  child: CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.amber,
                  ),
                ),
              ),
              title: Text(
                "Nam đã gửi tin nhắn cho bạn",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              subtitle: Text(
                "Today at 8:00",
                style: TextStyle(color: Colors.grey[900], fontSize: 11),
              )),
        )
      ],
    );
  }
}
