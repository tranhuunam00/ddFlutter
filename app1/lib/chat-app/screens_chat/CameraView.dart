import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CameraViewPage extends StatelessWidget {
  const CameraViewPage({Key? key, this.path, this.onImageSend})
      : super(key: key);
  final String? path;
  final Function? onImageSend;
  static TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black12,
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: [
            IconButton(
                onPressed: () {}, icon: Icon(Icons.crop_rotate, size: 27)),
            IconButton(
                onPressed: () {},
                icon: Icon(Icons.emoji_emotions_outlined, size: 27)),
            IconButton(onPressed: () {}, icon: Icon(Icons.title, size: 27)),
            IconButton(onPressed: () {}, icon: Icon(Icons.edit, size: 27))
          ],
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 150,
                child: Image.file(
                  File(path!),
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  color: Colors.black38,
                  padding:
                      EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
                  width: MediaQuery.of(context).size.width,
                  //text input camera ...........................................
                  child: TextFormField(
                      controller: _controller,
                      maxLines: 6,
                      minLines: 1,
                      style: TextStyle(color: Colors.white, fontSize: 17),
                      decoration: InputDecoration(
                          hintText: "Add Caption ... ",
                          prefixIcon: Icon(Icons.add_photo_alternate,
                              color: Colors.white),
                          suffixIcon: InkWell(
                            onTap: () => {
                              onImageSend!(path, _controller.text),
                              _controller.clear()
                            },
                            child: CircleAvatar(
                                radius: 27,
                                backgroundColor: Colors.tealAccent,
                                child: Icon(Icons.check, size: 27)),
                          ),
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 17),
                          border: InputBorder.none)),
                ),
              )
            ])));
  }
}
