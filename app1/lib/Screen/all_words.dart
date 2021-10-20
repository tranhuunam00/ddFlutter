import 'package:app1/Screen/ControlScreen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import "../ui.dart";
import '../modals/EnglishTodayModal.dart';
import 'dart:math';
import "../widgets/app_button.dart";
import "./ControlScreen.dart";
import "package:app1/share_key.dart";
import 'package:shared_preferences/shared_preferences.dart';

class AllWordsScreen extends StatelessWidget {
  final List<EnglishToday> words;
  const AllWordsScreen({Key? key, required this.words}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("all -w"),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            focusColor: Colors.green,
            child: Text("btn")),
      ),
      body: GridView.count(
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        crossAxisCount: 2,
        children: words
            .map((e) => Container(
                decoration: BoxDecoration(
                  color: Colors.amber,
                ),
                alignment: Alignment.center,
                child: Text(e.noun ?? "")))
            .toList(),
      ),
    );
  }
}
