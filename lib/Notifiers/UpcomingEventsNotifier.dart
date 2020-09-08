import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ceyca/model/events.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:intl/intl.dart';

class UpcomingEventsNotifier extends ChangeNotifier{
// List<events> _eventsList = [];
 List<events> _eventsList = [];
 Map<DateTime,events> _eventsMap ;
 Map<DateTime,List> _holidays ;
events _currentEvents;
bool alreadyLoaded = false;

UpcomingEventsNotifier(){}



Future< QuerySnapshot> getEvents() async {
 QuerySnapshot  snapshot =
        await Firestore.instance.collection('events').getDocuments();
        return snapshot;
    }


UpcomingEventsNotifier get instance => this; 

UnmodifiableListView<events> get eventsList => UnmodifiableListView(_eventsList);

Map<DateTime,events> get eventsMap => _eventsMap;

 Map<DateTime,List> get holidays => _holidays;

events get currentEvents => _currentEvents;

set eventsMap(Map<DateTime,events> eventsMap ){
  _eventsMap= eventsMap;
  notifyListeners();
}

 set holidays(Map<DateTime,List> holidays ){
   _holidays= holidays;
   notifyListeners();
 }

  set eventsList(List<events> eventsList ) {
    _eventsList = eventsList ;
   
    notifyListeners();
  }

  set currentEvents(events events) {
    _currentEvents = events;
   
    notifyListeners();
  }

}