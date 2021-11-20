import 'package:app1/chat-app/model/chat_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AvatarCard extends StatelessWidget {
  const AvatarCard({Key? key, this.contact}) : super(key: key);
  final ChatModel? contact;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(children: [
            CircleAvatar(
              radius: 23,
              child: Image.asset("assets/icons/man.png", height: 30, width: 30),
              backgroundColor: Colors.blueGrey[200],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 9,
                  child: Icon(Icons.clear, color: Colors.white, size: 18)),
            )
          ]),
          SizedBox(
            height: 2,
          ),
          Text(contact!.userName, style: TextStyle(fontSize: 12))
        ],
      ),
    );
  }
}
