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
                ? Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 2.5,
                        width: MediaQuery.of(context).size.width / 1.8,
                        child: Image.network(
                          'http://5c35-2401-d800-2103-90fe-601c-87d7-d826-193e.ngrok.io/upload/' +
                              path!,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      message != ""
                          ? Positioned(
                              bottom: 0,
                              child: Text(
                                message.toString(),
                                style: TextStyle(color: Colors.amber),
                              ))
                          : Container()
                    ],
                  )
                : Container(),
          ),
        ),
      ),
    );
  }
}
