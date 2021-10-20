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
import "all_words.dart";

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  late PageController _pageController;
  List<EnglishToday> words = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  //ramdom
  List<int> fixedListRandom({int len = 1, int max = 100, int min = 1}) {
    if (len > max || len < min) {
      return [];
    }
    List<int> newList = [];
    Random random = Random();
    int count = 0;
    while (count < len) {
      int val = random.nextInt(max);
      if (newList.contains(val)) {
        continue;
      } else {
        newList.add(val);
        count++;
      }
    }
    return newList;
  }

  getEnglishToday() async {
    int onlLen = 5;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lenWords = prefs.getInt(ShareKey.counter) ?? 5;
    print('couter  ${lenWords}');
    List<String> newList = [];
    List<int> rans = fixedListRandom(len: lenWords, max: nouns.length);
    rans.forEach((index) {
      newList.add(nouns[index]);
    });
    words = newList.map((e) => EnglishToday(noun: e)).toList();
    setState(() {});
  }

  @override
  void initState() {
    getEnglishToday();
    _pageController = PageController(viewportFraction: 0.9);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("home"),
        leading: InkWell(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            focusColor: Colors.green,
            child: Text("btn")),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.centerLeft,
                color: Colors.green,
                height: size.height * 1 / 10,
                child: Text("text")),
            Container(
                height: size.height * 2 / 3,
                child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemCount: words.length > 5 ? 6 : words.length,
                    itemBuilder: (context, index) {
                      String letter =
                          words[index].noun != null ? words[index].noun! : "";
                      String firstLetter =
                          letter != "" ? letter.substring(0, 1) : "";
                      String leftLetter = letter != ""
                          ? letter.substring(1, letter.length)
                          : "";

                      return InkWell(
                        onDoubleTap: () {
                          setState(() {
                            words[index].isFavorite = !words[index].isFavorite;
                          });
                        },
                        child: Container(
                            margin: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24)),
                            ),
                            child: index >= 5
                                ? InkWell(
                                    onTap: () {
                                      print("show mỏe");
                                    },
                                    child:
                                        Text("Show more", style: AppStyles.h2))
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          alignment: Alignment.centerRight,
                                          child: Text("tym",
                                              style: TextStyle(
                                                fontSize: 30,
                                                color: words[index].isFavorite
                                                    ? Colors.red
                                                    : Colors.white,
                                              ))),
                                      RichText(
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(
                                              text: firstLetter,
                                              style: TextStyle(
                                                  fontSize: 80,
                                                  shadows: [
                                                    BoxShadow(
                                                        color: Colors.black,
                                                        offset: Offset(3, 6),
                                                        blurRadius: 6),
                                                  ]),
                                              children: [
                                                TextSpan(
                                                  text: leftLetter,
                                                  style: TextStyle(
                                                      fontSize: 56,
                                                      shadows: []),
                                                )
                                              ])),
                                      AutoSizeText(
                                          "think of all the beauty still left around you",
                                          style: TextStyle(letterSpacing: 1))
                                    ],
                                  )),
                      );
                    })),
            //
            (_currentIndex >= 5)
                ? buildShowMore()
                : Container(
                    height: 8,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return buildIndicator(index == _currentIndex, size);
                        }))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            getEnglishToday();
          },
          child: Text("btn")),
      drawer: Drawer(
          child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Text("your mind"),
            ),
            AppBTnStyle(
                label: "Favorite",
                onTap: () {
                  print("favo");
                }),
            AppBTnStyle(
                label: "Control",
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => Control()));
                }),
          ],
        ),
      )),
    );
  }

  Widget buildIndicator(bool isActive, Size size) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        height: 8,
        width: isActive ? size.width * 1 / 5 : 24,
        decoration: BoxDecoration(
            color: isActive ? Colors.black : Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black38, offset: Offset(2, 3), blurRadius: 3)
            ]));
  }

  Widget buildShowMore() {
    return Container(
        padding:
            const EdgeInsets.only(top: 12, bottom: 12, right: 24, left: 24),
        alignment: Alignment.centerLeft,
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: Colors.orange,
          elevation: 4,
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AllWordsScreen(words: this.words)));
            },
            borderRadius: BorderRadius.all(Radius.circular(16)),
            overlayColor: MaterialStateProperty.all(Colors.amber),
            child: Container(
                padding: const EdgeInsets.only(
                    top: 12, bottom: 12, right: 24, left: 24),
                child: Text("Show more")),
          ),
        ));
  }
}
