import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainFeedScreen extends StatefulWidget {
  const MainFeedScreen({Key? key}) : super(key: key);

  @override
  _MainFeedScreenState createState() => _MainFeedScreenState();
}

class _MainFeedScreenState extends State<MainFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: ListView.builder(
            itemCount: 4,
            itemBuilder: (context, index) {
              if (index == 0) {
                return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 23,
                      backgroundImage: AssetImage('assets/images/load.gif'),
                      child: CircleAvatar(
                        radius: 23,
                        // backgroundImage: NetworkImage(pathImg),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    title: Text("Bài viết này là của"),
                    trailing: SizedBox(
                      height: 50,
                      width: 50,
                      child: InkWell(
                        child: Text("..."),
                      ),
                    ),
                    subtitle: Row(
                      children: [Text("time"), Text("rule")],
                    ));
              }
              if (index == 1) {
                return Text("message bài viết");
              }
              if (index == 2) {
                return Text("ảnh");
              }
              if (index == 3) {
                return Container(
                    child: Row(
                  children: [
                    Expanded(child: Text("Like")),
                    Expanded(child: Text("comment")),
                  ],
                ));
              }
              return Container();
            }),
      ),
    );
  }
}
