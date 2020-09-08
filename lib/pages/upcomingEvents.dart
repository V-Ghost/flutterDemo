import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:ceyca/Notifiers/UpcomingEventsNotifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ceyca/model/events.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:ceyca/Notifiers/DevotionNotifier.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:math';

class UpcomingEvents extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UpcomingEventsState();
  }
}

DevotionNotifier d;
events _selectedEvents;

Map<DateTime, List> _holidays;
bool noEvents = true;
UpcomingEventsNotifier _eventsNotifier;

class UpcomingEventsState extends State<UpcomingEvents>
    with TickerProviderStateMixin {
  bool isTodayDate(DateTime other) {
    return DateTime.now().year == other.year &&
        DateTime.now().month == other.month &&
        DateTime.now().day == other.day;
  }

  Future<List<events>> getEvents() async {
    QuerySnapshot snapshot = await _eventsNotifier.getEvents();

    // await Firestore.instance.collection('events').getDocuments();

    List<events> _eventsList = [];
    Map<DateTime, events> _eventsMap = {};
    Map<DateTime, List> _holidays = {};
    if (snapshot.documents == null) {
      throw new Exception("data not found");
    } else {
      snapshot.documents.forEach((document) {
        events d1 = events.fromMap(document.data);
        _eventsMap.putIfAbsent(document.data['time'].toDate(), () => d1);
        _eventsList.add(d1);
      });

      snapshot.documents.forEach((document) {
        events d2 = events.fromMap(document.data);
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        final String formatted =
            formatter.format(document.data['time'].toDate());
        var parsedDate = DateTime.parse(formatted);
        _holidays.putIfAbsent(parsedDate, () => [d2.name]);
      });
      _eventsMap.forEach((key, value) {
        if (isTodayDate(key)) {
          _selectedEvents = value;

          noEvents = false;
        }
      });
      _eventsNotifier.eventsList = _eventsList;
      _eventsNotifier.eventsMap = _eventsMap;
      _eventsNotifier.holidays = _holidays;

      return _eventsList;
    }
  }

  // getImages() async{
  //   final StorageReference storageRef =
  //       FirebaseStorage.instance.ref().child('Gallery').child('Images');
  //   storageRef.listAll().then((result) {
  //     print("result is $result");
  //   });
  // }

  @override
  void initState() {
    _eventsNotifier =
        Provider.of<UpcomingEventsNotifier>(context, listen: false);
    //  _eventsNotifier.getEvents();
    //  d =
    //     Provider.of<DevotionNotifier>(context, listen: false);
    // devotionEvent = getEvents();
    // print("PPP");
    // print(d.devotionList.length);

    controller = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();

    super.initState();
  }

  CalendarController controller;

  AnimationController _animationController;
  final _selectedDay = DateTime.now();

  Map<DateTime, List> _events = {
    DateTime(2019, 1, 1): ['New Year\'s Day'],
    DateTime(2019, 1, 6): ['Epiphany'],
    DateTime(2019, 2, 14): ['Valentine\'s Day'],
    DateTime(2019, 9, 29): ['Easter Sunday'],
    DateTime(2020, 7, 12): [
      'Event A0',
      'Event B0',
    ],
  };

  void _onDaySelected(DateTime day, List events) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final formatted = formatter.format(day);

    var parsedDate = DateTime.parse(formatted);
    setState(() {
      if (_eventsNotifier.eventsMap[parsedDate] != null) {
        _selectedEvents = _eventsNotifier.eventsMap[parsedDate];
        noEvents = false;
      } else {
        noEvents = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    
    // print(loadImage().toString());

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    SolidController _controller = SolidController();

    return Scaffold(
      backgroundColor: Colors.white,
     
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin:
                  const EdgeInsets.only(top: 15, left: 8, right: 8, bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  gradient: LinearGradient(colors: [
                    Colors.white,
                    Colors.white,
                  ], begin: Alignment.topRight, end: Alignment.bottomLeft),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 8),
                      blurRadius: 8,
                    )
                  ]),
              child: buildCalendar(),
            ),
          ),
         
        ],
      ),
      bottomSheet: SolidBottomSheet(
          controller: _controller,
          elevation: 100,
          maxHeight: height * 0.7,
          toggleVisibilityOnTap: false,
          headerBar: GestureDetector(
            onTap: () => {
              _controller.isOpened ? _controller.hide() : _controller.show(),
            },
            child: Container(
              color: Theme.of(context).primaryColor,
              height: 50,
              child: Center(
                child: FutureBuilder(
                  future: getEvents(), //getEventsToday
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return noEvents
                          ? Column(
                            children: [
                              SizedBox(height: 5),
                              Icon(FontAwesome5Solid.angle_up),
                              Text('no events today'),
                            ],
                          )
                          : Column(
                            children: [
                              SizedBox(height: 5),
                              Icon(FontAwesome5Solid.angle_up),
                              Text(_selectedEvents.name),
                            ],
                          );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Icon(Icons.broken_image),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: FutureBuilder(
                future: getEvents(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return noEvents
                        ? Center(
                            child: Text("no event today"),
                          )
                        : Column(
                            children: <Widget>[
                              SizedBox(
                                height: 20,
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
                                  imageUrl: "${_selectedEvents.pictures[0]}",
                                  // another + _devotionNotifier.devotionList[index].key+ ' ' +index.toString(),
                                  //  imageUrl : '',5
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                          constraints: BoxConstraints.expand(),
                                          child: Container(
                                            padding: EdgeInsets.only(top: 20),
                                            alignment: Alignment.topLeft,
                                            color: Colors.blue,
                                            child: Icon(Icons.error),
                                          )),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                padding: EdgeInsets.all(30),
                                child: Column(
                                  children: [
                                    Center(
                                      child: Text(
                                        "${_selectedEvents.name}",
                                        style: TextStyle(
                                          fontFamily: 'Merriweather',
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        "${_selectedEvents.description}",
                                        style: TextStyle(
                                          fontFamily: 'Merriweather',
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        "dateTime : ${_selectedEvents.timestamp}",
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
                                      itemCount: _selectedEvents.pictures.length,
                                      physics: BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          padding: EdgeInsets.only(
                                              right: 10, left: 10),
                                          child: CachedNetworkImage(
                                            fadeInDuration: const Duration(
                                                milliseconds: 3000),
                                            height: 150,
                                            width: (width / 2 - 30),
                                            fit: BoxFit.contain,
                                            imageUrl:
                                                "${_selectedEvents.pictures[index]}",
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
                                                      padding: EdgeInsets.only(
                                                          top: 20),
                                                      alignment:
                                                          Alignment.topLeft,
                                                      color: Colors.blue,
                                                      child: Icon(Icons.error),
                                                    )),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  SizedBox(
                                    width: 10,
                                  ),
                                  //     Expanded(
                                  //       child: CachedNetworkImage(
                                  //         height: 200,
                                  //         width: (width / 2 - 30),
                                  //         fit: BoxFit.contain,
                                  //         imageUrl:
                                  //             "https://source.unsplash.com/700x500/?",
                                  //         // another + _devotionNotifier.devotionList[index].key+ ' ' +index.toString(),
                                  //         //  imageUrl : '',5
                                  //         placeholder: (context, url) =>
                                  //             CircularProgressIndicator(
                                  //           backgroundColor: Colors.white,
                                  //         ),
                                  //         errorWidget: (context, url, error) =>
                                  //             Container(
                                  //                 constraints:
                                  //                     BoxConstraints.expand(),
                                  //                 child: Container(
                                  //                   padding:
                                  //                       EdgeInsets.only(top: 20),
                                  //                   alignment: Alignment.topLeft,
                                  //                   color: Colors.blue,
                                  //                   child: Icon(Icons.error),
                                  //                 )),
                                  //       ),
                                  //     ),
                                  //     SizedBox(
                                  //       width: 10,
                                  //     ),
                               
                             
                            ],
                          );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Icon(Icons.broken_image),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    );
                  }
                }),
          )),
    );
  }

 

  Widget buildCalendar() {
    return FutureBuilder(
        future: getEvents(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return TableCalendar(
              calendarController: controller,
              calendarStyle: CalendarStyle(
                todayColor: Colors.white,
                selectedColor: Colors.grey,
                todayStyle: new TextStyle(color: Colors.grey),
                markersColor: Colors.black,
                markersMaxAmount: 1,
//
              ),
              builders: CalendarBuilders(
                selectedDayBuilder: (context, date, _) {
                  return FadeTransition(
                    opacity: Tween(begin: 0.0, end: 1.0)
                        .animate(_animationController),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      margin: const EdgeInsets.all(4.0),
                      padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                      width: 100,
                      height: 100,
                      child: Text(
                        '${date.day}',
                        style: TextStyle().copyWith(fontSize: 16.0),
                      ),
                    ),
                  );
                },
                todayDayBuilder: (context, date, _) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    margin: const EdgeInsets.all(4.0),
                    padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                    width: 100,
                    height: 100,
                    child: Text(
                      '${date.day}',
                      style: TextStyle().copyWith(fontSize: 16.0),
                    ),
                  );
                },
                markersBuilder: (context, date, events, holidays) {
                  final children = <Widget>[];

                  if (holidays.isNotEmpty) //manipulate holidays
                  {
                    children.add(
                      Center(
                        child: _buildHolidaysMarker(date),
                      ),
                    );
                  }

                  return children;
                },
              ),
              holidays: _eventsNotifier.holidays,
              onDaySelected: _onDaySelected,
              events: _events,
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Icon(Icons.broken_image),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            );
          }
        });
  }

  Widget _buildHolidaysMarker(date) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      margin: const EdgeInsets.all(4.0),
      padding: const EdgeInsets.only(top: 5.0, left: 6.0),
      width: 100,
      height: 100,
      child: Stack(
        children: <Widget>[
          Text(
            '${date.day}',
            style: TextStyle().copyWith(fontSize: 16.0),
          ),
          Positioned(
            bottom: -1,
            right: -2,
            child: Icon(
              Icons.message,
              size: 20.0,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
