import 'package:ceyca/Notifiers/DevotionNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:ceyca/pages/detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ceyca/widget/app_clipper.dart';
import 'package:ceyca/widget/const.dart';

import 'package:flutter_icons/flutter_icons.dart';

import 'dart:math' as math;
import 'package:ceyca/pages/video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:ceyca/Notifiers/UpcomingEventsNotifier.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DailyDevotionPage extends StatefulWidget {
  @override
  _DailyDevotionPageState createState() => _DailyDevotionPageState();
}

class _DailyDevotionPageState extends State<DailyDevotionPage> {
  final scrollController = ScrollController();
  var l;
  
  ScrollController controller;
  List<Color> color = [
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.pink,
    Colors.green,
    Colors.red,
    Colors.lightBlueAccent,
    Colors.teal
  ];
  DevotionNotifier d;
  @override
  void initState() {
    UpcomingEventsNotifier _eventsNotifier =
        Provider.of<UpcomingEventsNotifier>(context, listen: false);
    // _eventsNotifier.getEvents();
    // getDevotions();
    //  double current = scrollController.position.pixels;
    // double delta = MediaQuery.of(context).size.width;
    // double max =scrollController.position.maxScrollExtent;
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (d.hasMore && !d.isLoading) {
          setState(() {});
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    d = Provider.of<DevotionNotifier>(context, listen: true);
    // getDevotions(_devotionNotifier);
    double width = MediaQuery.of(context).size.width;
    String url = "https://picsum.photos/412/700";
    print(getVideoID("https://www.youtube.com/watch?v=GOPQPtaZFLM"));
    // var devotionFuture = getDevotions();

    return Scaffold(
     
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Devotional",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
                // IconButton(
                //   icon: Icon(FlutterIcons.search, color: Colors.black26),
                //   onPressed: null,
                // ),
              ],
            ),
          ),
          Container(
            height: 300,
            margin: EdgeInsets.symmetric(vertical: 16),
            child: FutureBuilder(
                future: d.getDevotions(),
                builder: (context, snapshot) {
                  if ((snapshot.connectionState == ConnectionState.done)) {
                    return ListView.builder(
                        controller: scrollController,
                        itemCount: d.devotionList.length + 1,
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) {
                          if (index < d.devotionList.length) {
                            return GestureDetector(
                              onTap: () {
                                // d.hasMore = true;
                                d.currentdevotion = d.devotionList[index];

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        DetailPage.fromDevotion(index),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(-1, 1),
                                        blurRadius: 10,
                                      )
                                    ]),
                                width: 230,
                                margin: EdgeInsets.only(right: 16),
                                child: Stack(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: 25),
                                      child: _buildBackground(index, 230),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Hero(
                                        tag: "assets/images/CEYC1.png" +
                                            index.toString(),
                                        child: Image(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .15,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .15,
                                          image: AssetImage(
                                              "assets/images/CEYC1.png"),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else if (d.hasMore) {
                            return Center(
                              child: Center(child: CircularProgressIndicator()),
                            );
                          } else {
                            return Center(
                              child: Text("no more devotions"),
                            );
                          }
                        });
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Icon(Icons.broken_image),
                    );
                  } else if ((snapshot.connectionState ==
                      ConnectionState.waiting)) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    );
                  }
                  return Container();
                }),
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FutureBuilder(
                    future: d.getEvents(),
                    builder: (context, snapshot) {
                      if ((snapshot.connectionState == ConnectionState.done)) {
                        return Column(
                          children: [
                            Text(
                              "News Feed",
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "${d.eventsList[0].days}",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              // padding: EdgeInsets.only(left: 40, right: 40),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              child: CachedNetworkImage(
                                fadeInDuration:
                                    const Duration(milliseconds: 5000),
                                fit: BoxFit.cover,
                                imageUrl:
                                    "https://source.unsplash.com/700x500/?",
                                // another + _devotionNotifier.devotionList[index].key+ ' ' +index.toString(),
                                //  imageUrl : '',5
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                ),
                                errorWidget: (context, url, error) => Container(
                                    constraints: BoxConstraints.expand(),
                                    child: Container(
                                      padding: EdgeInsets.only(top: 20),
                                      alignment: Alignment.topLeft,
                                      color: Colors.blue,
                                      child: Icon(Icons.error),
                                    )),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(30),
                              child: Column(
                                children: [
                                  Center(
                                    child: Text(
                                      "${d.eventsList[0].name}",
                                      style: TextStyle(
                                        fontFamily: 'Merriweather',
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      "${d.eventsList[0].description}",
                                      style: TextStyle(
                                        fontFamily: 'Merriweather',
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      "dateTime : ${d.eventsList[0].timestamp}",
                                      style: TextStyle(
                                        fontFamily: 'Merriweather',
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                           
                            Container(
                              height: 100,
                              margin: EdgeInsets.symmetric(vertical: 16),
                              child: ListView.builder(
                                itemCount: d.eventsList[0].pictures.length,
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    padding:
                                        EdgeInsets.only(right: 10, left: 10),
                                    child: CachedNetworkImage(
                                      fadeInDuration:
                                          const Duration(milliseconds: 3000),

                                      width: (width / 2 - 30),
                                      fit: BoxFit.contain,
                                      imageUrl:
                                          "${d.eventsList[0].pictures[index]}",
                                      // another + _devotionNotifier.devotionList[index].key+ ' ' +index.toString(),
                                      //  imageUrl : '',5
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                              constraints:
                                                  BoxConstraints.expand(),
                                              child: Container(
                                                padding:
                                                    EdgeInsets.only(top: 20),
                                                alignment: Alignment.topLeft,
                                                color: Colors.blue,
                                                child: Icon(Icons.error),
                                              )),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Icon(Icons.broken_image),
                        );
                      } else if ((snapshot.connectionState ==
                          ConnectionState.waiting)) {
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        );
                      }
                      return Container();
                    }),
              ],
            ),
          ),
          SizedBox(height: 24),
          Center(
            child: Text(
              "Latest Videos",
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
           SizedBox(height: 15),
            Video(),
        ],
      ),
    );
  }

  Widget _buildBackground(int index, double width) {
    int i = index % color.length;

    return ClipPath(
      clipper: AppClipper(cornerSize: 25, diagonalHeight: 100),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            color[i].withOpacity(0.8),
            color[i],
          ], begin: Alignment.topRight, end: Alignment.bottomLeft),
        ),
//        color: color[i],

        width: width,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Align(
                      alignment: Alignment(-1, 0),
                      child: Text(
                        "Topic :",
                        style: TextStyle(
                          fontFamily: 'Merriweather',
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: [
                      Center(
                        child: Text(
                          "${d.devotionList[index].topic}",
                          style: TextStyle(
                            fontFamily: 'Merriweather',
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: SizedBox()),
                  Container(
                    width: 125,
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      " ${d.devotionList[index].time}",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getVideoID(String url) {
    url = YoutubePlayer.convertUrlToId(
        "https://www.youtube.com/watch?v=BBAyRBTfsOU");

    return url;
  }
}

class Video extends StatefulWidget {
  Video({Key key}) : super(key: key);

  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  ScrollController _contoller;
  List<VideoStruct> videos = [];

  @override
  void initState() {
    super.initState();
    _contoller = ScrollController();
  }

  @override
  void dispose() {
    _contoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    videos.clear();
    videos.addAll(Provider.of<VideoSession>(context).videos ?? []);
    VideoSession v = Provider.of<VideoSession>(context);
    if (videos.length == 0) {
      return Center(child: CircularProgressIndicator());
    }

    try {
      return Container(
        child: VideoCard(videoStruct: videos[0]),
      );
    } catch (e) {
      print(e);
      return Center(child: CircularProgressIndicator());
    }
  }
}
