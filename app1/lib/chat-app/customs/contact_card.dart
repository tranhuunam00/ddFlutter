import 'package:app1/chat-app/model/chat_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({Key? key, this.contact}) : super(key: key);
  final ChatModel? contact;

  @override
  Widget build(BuildContext context) {
    print("render...1.");
    print(contact!.isSelect);
    print(contact!.userName);

    return ListTile(
        leading: Container(
          height: 50,
          width: 50,
          child: Stack(children: [
            CircleAvatar(
              radius: 23,
              child: Image.asset("assets/icons/man.png", height: 30, width: 30),
              backgroundColor: Colors.blueGrey[200],
            ),
            (contact!.isSelect == true)
                ? Positioned(
                    bottom: 4,
                    right: 3,
                    child: CircleAvatar(
                        backgroundColor: Colors.teal,
                        radius: 9,
                        child:
                            Icon(Icons.check, color: Colors.white, size: 18)),
                  )
                : Container()
          ]),
        ),
        title: Text(
          contact!.userName,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(contact!.status, style: TextStyle(fontSize: 13)));
  }
}
