import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:app1/share_key.dart";

class Control extends StatefulWidget {
  Control({Key? key}) : super(key: key);

  @override
  _ControlState createState() => _ControlState();
}

class _ControlState extends State<Control> {
  double sliderValue = 5.0;

  @override
  void initState() {
    getInitSliderValue();
  }

  getInitSliderValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int value = prefs.getInt(ShareKey.counter) ?? 5;
    setState(() {
      sliderValue = value.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Control"),
          leading: InkWell(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setInt(ShareKey.counter, sliderValue.toInt());
                Navigator.pop(context);
              },
              child: Text(
                "back",
                style: TextStyle(fontSize: 24),
              )),
        ),
        body: Column(
          children: [
            Spacer(),
            Text('${sliderValue.toInt()}'),
            Slider(
                value: sliderValue,
                min: 5,
                max: 100,
                divisions: 95,
                onChanged: (value) {
                  print(value);
                  setState(() {
                    sliderValue = value;
                  });
                }),
            Spacer(),
          ],
        ));
  }
}
