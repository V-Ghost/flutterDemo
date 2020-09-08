import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoSession with ChangeNotifier {
  List<VideoStruct> _videoStructs = [];
  bool done = false;
  VideoSession() {
    setup();
  }

  void setup() {
    getVideos(() {
      _videoStructs.clear();
    }).then((items) {
      _videoStructs = items;
    }).catchError((e) {
      _videoStructs.clear();
    });
    notifyListeners();
  }

  List<VideoStruct> get videos => _videoStructs;
  VideoSession get instance => this;
}

class VideoStruct {
  final String id;
  final String title;
  final String description;
  final String thumbnail;
  final DateTime time;

  const VideoStruct(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.thumbnail,
      @required this.time})
      : assert(
            id != null && title != null && thumbnail != null && time != null);

  void display() {
    print(
        "id => $id\n title: $title\n description: $description\n thumbnail: $thumbnail\n");
  }

  @override
  String toString() {
    return "id: $id\n title: $title\n description: $description\n thumbnail: $thumbnail\n";
  }
}

class VideoPage extends StatefulWidget {
  VideoPage({Key key}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
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

    if (videos.length == 0) {
      return Center(child: CircularProgressIndicator());
    }
    try {
      return Container(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
              controller: _contoller,
              itemCount: videos.length + 1,
              itemBuilder: (BuildContext context, int index) {
                print("$index");
                videos[index].display();
                return VideoCard(videoStruct: videos[index]);
              }));
    } catch (e) {
      print(e);
      return Center(child: CircularProgressIndicator());
    }
  }
}

const List<String> months = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec"
];

class VideoCard extends StatelessWidget {
  final VideoStruct videoStruct;
  const VideoCard({Key key, @required this.videoStruct}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // List<VideoStruct> videos = Provider.of<Session>(context).videos;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 7.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            MediaQuery.of(context).size.height * 0.45 * 0.05),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.45,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                "${videoStruct.time.day.toString()} ${months[videoStruct.time.month - 1]} ${videoStruct.time.year.toString()}",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Flexible(
              child: Center(
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: videoStruct.thumbnail,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (BuildContext context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (BuildContext context, url, error) => Center(
                        child: const Icon(Icons.broken_image),
                      ),
                    ),
                    Center(
                      child: InkWell(
                          onTap: () {
                            print("Navigating to the video playing page");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VideoPlayerPage(
                                      videoStruct: videoStruct)),
                            );
                          },
                          hoverColor: Colors.blueAccent,
                          child: Container(
                            height: MediaQuery.of(context).size.height *
                                0.45 *
                                0.15,
                            width: MediaQuery.of(context).size.height *
                                0.45 *
                                0.15,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromRGBO(0, 0, 0, 10)),
                            child: Icon(Icons.play_arrow),
                          )),
                    )
                  ],
                ),
              ),
            ),
            Center(
              child: ListTile(
                leading: Icon(
                  Icons.bookmark_border,
                  color: Colors.blueAccent,
                ),
                title: Text(
                  videoStruct.title,
                  overflow: TextOverflow.ellipsis,
                ),
                isThreeLine: false,
                trailing: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerPage extends StatefulWidget {
  final VideoStruct videoStruct;

  VideoPlayerPage({Key key, @required this.videoStruct}) : super(key: key) {
    assert(videoStruct != null);
  }

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoStruct.id,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void listener() {}

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: new IconThemeData(color: Colors.black),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                child: Column(
                  children: [
                    YoutubePlayer(
                      controller: _controller,
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: Colors.blueAccent,
                      progressColors: ProgressBarColors(
                        playedColor: Colors.blue,
                        handleColor: Colors.blueAccent,
                      ),
                      onReady: () {
                        _controller.addListener(listener);
                        print(_controller.value);
                      },
                    ),
                    ExpansionTile(
                      leading: Icon(
                        Icons.live_tv,
                        color: Colors.blueAccent,
                      ),
                      title: Text(
                        widget.videoStruct.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: <Widget>[
                        Divider(
                          color: Colors.blueAccent,
                          height: 2.0,
                        ),
                        Center(
                          child: Text(
                            "Description",
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                decorationStyle: TextDecorationStyle.solid,
                                decorationThickness: 2.0),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(14.0),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.videoStruct.description,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal,
                              color: Colors.blue,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Container(),
              )
            ],
          ),
        ),
      );
    } catch (e) {
      print(e);
      return Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              ExpansionTile(
                leading: Icon(
                  Icons.error,
                  color: Colors.red,
                ),
                title: Text("ERROR"),
                children: <Widget>[
                  Text(e.toString()),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}

Future<List<VideoStruct>> getVideos(void Function() onError) async {
  final String url =
      "https://us-central1-chatme-1ee5c.cloudfunctions.net/helloWorld";

  List<VideoStruct> results = [];

  try {
    var reponse = await http.get(url);
    print("This function might be working");

    if (reponse.statusCode == 200) {
      Map<String, dynamic> jsonMap = jsonDecode(reponse.body);
      for (Map<String, dynamic> item in jsonMap["items"]) {
        results.add(
          VideoStruct(
            id: item["snippet"]["resourceId"]["videoId"],
            title: item["snippet"]["title"],
            description: item["snippet"]["description"],
            thumbnail: item["snippet"]["thumbnails"]["high"]["url"],
            time: DateTime.parse(item["snippet"]["publishedAt"]),
          ),
        );
      }

      return results;
    }
  } catch (_) {
    onError();
  }

  return [];
}
