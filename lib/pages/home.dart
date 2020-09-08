import 'package:ceyca/pages/dailyDevotion.dart';
import 'package:ceyca/pages/upcomingEvents.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'video.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_messaging/firebase_messaging.dart';



class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    super.initState();
     print("hi");
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        // final notification = message['notification'];
        print("onMessage: $message");
        String n = message['notification']['title'];
        print(n);
        showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(message['notification']['title']),
          content: new Text(message['notification']['body']),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
        // final snackBar = SnackBar(
        //   content: Text("hiiii"),
        //   action: SnackBarAction(
        //     label: 'Undo',
        //     onPressed: () {
        //       // Some code to undo the change.
        //     },
        //   ),
        // );
        // Scaffold.of(context).showSnackBar(snackBar);
      },
      onLaunch: (Map<String, dynamic> message) async {
        // final notification = message['data'];
        print("onMessage: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        //  final notification = message['data'];
        print("onMessage: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }
  

  
  @override
  void dispose() {
    super.dispose();
  }
  
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    DailyDevotionPage(),
    UpcomingEvents(),
    VideoPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.bodyText2;
    final List<Widget> aboutBoxChildren = <Widget>[
      SizedBox(height: 24),
      RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                style: textStyle,
                text:
                    'LoveWorld Incorporated, is a global ministry with a vision of taking God’s divine presence to the nations of the world and to demonstrate the character of the Holy Spirit. This is achieved through every available means, as the Ministry is driven by a passion to see men and women all over the world, come to the knowledge of the divine life made available in Christ Jesus. '),
            TextSpan(
              style: textStyle.copyWith(color: Theme.of(context).accentColor),
              text: 'https://ceycairportcity.org/',
              recognizer: new TapGestureRecognizer()
                ..onTap = () {
                  launch('https://ceycairportcity.org/');
                },
            ),
            TextSpan(style: textStyle, text: '.'),
          ],
        ),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: new IconThemeData(color: Colors.black),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(''),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(
                      image: AssetImage("assets/images/devotion.png"),
                      fit: BoxFit.cover)),
            ),
            ListTile(
              title: Text('Instagram'),
              leading: ImageIcon(
                AssetImage("assets/images/instagram.png"),
                // color: Color(0xFF3A5A98),
              ),
              onTap: () {
                launch('https://www.instagram.com/ceyc_airportcity/');
              },
            ),
            ListTile(
              title: Text('Twitter'),
              leading: ImageIcon(
                AssetImage("assets/images/twitter.png"),
                // color: Color(0xFF3A5A98),
              ),
              onTap: () {
                launch('https://twitter.com/CEYCAirportCity');
              },
            ),
            // ListTile(
            //   title: Text('Facebook'),
            //   leading: ImageIcon(
            //     AssetImage("assets/images/instagram.png"),
            //     // color: Color(0xFF3A5A98),
            //   ),
            //   onTap: () {
            //     launch('https://flutter.dev');
            //   },
            // ),
            AboutListTile(
              icon: Icon(Icons.info),
              applicationIcon: ImageIcon(
                AssetImage("assets/images/CEYC1.png"),
                // color: Color(0xFF3A5A98),
              ),
              applicationName: 'CEYC',
              applicationVersion: 'August 2020',
              applicationLegalese: '© 2020 Timisu',
              aboutBoxChildren: aboutBoxChildren,
            ),
          ],
        ), // Populate the Drawer in the next step.
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesome5Solid.book_reader),
            title: Text('Devotional'),
          ),
          BottomNavigationBarItem(
            icon: Icon(AntDesign.calendar),
            title: Text('Calendar'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            title: Text('Video'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black26,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        onTap: _onItemTapped,
      ),
    );
  }
}
