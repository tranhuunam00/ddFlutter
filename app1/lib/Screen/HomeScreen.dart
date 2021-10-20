import 'package:flutter/material.dart';
import '../ui.dart';
import '../widgets/card_feed.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListView(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Gốc gạo", style: AppStyles.h2),
                  Icon(Icons.message_sharp)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, right: 8.0),
                    child: CircleAvatar(
                      radius: 24,
                    ),
                  ),
                  SizedBox(
                      width: size.width - 150,
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: "Bạn đang nghĩ gì...",
                        ),
                      ))
                ],
              ),
            ),
            Divider(
              height: 40,
              color: Colors.black38,
            ),
            CardFeedStyle(),
            CardFeedStyle(),
            CardFeedStyle()
          ],
        ),
      ),
    ]);
  }
}
