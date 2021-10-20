import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OwnFileCard extends StatelessWidget {
  const OwnFileCard({Key? key, this.path, this.message}) : super(key: key);
  final String? path;
  final String? message;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Container(
          height: MediaQuery.of(context).size.height / 2.5,
          width: MediaQuery.of(context).size.width / 1.8,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.green[300]),
          child: Card(
            margin: EdgeInsets.all(3),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: path! != null
                ? Column(
                    children: [
                      Expanded(
                        child: Image.network(
                          "http://a96c-14-235-182-226.ngrok.io/upload/8d71630ab0b7047f44a1c8265743c3c7.jpg",
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      message != null ? Text(message!) : Container()
                    ],
                  )
                : Container(),
          ),
        ),
      ),
    );
  }
}
