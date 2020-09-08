import 'package:ceyca/Notifiers/DevotionNotifier.dart';
import 'package:ceyca/Notifiers/UpcomingEventsNotifier.dart';
import 'package:ceyca/pages/upcomingEvents.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ceyca/pages/home.dart';
import 'package:ceyca/pages/dailyDevotion.dart';
import 'package:ceyca/pages/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/video.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: DevotionNotifier().instance,
        ),
        ChangeNotifierProvider.value(
          value: VideoSession().instance,
        ),
        ChangeNotifierProvider.value(
          value: UpcomingEventsNotifier().instance,
        ),
        ChangeNotifierProvider.value(
          value: DevotionNotifier().instance,
        ),
      ],
      child: MaterialApp(
        home: MyHomePage(),
        title: 'Christ Embassy Youth Church',
        theme: ThemeData(primarySwatch: Colors.blue),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
