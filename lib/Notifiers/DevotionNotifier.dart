import 'dart:async';
import 'dart:collection';
import 'package:ceyca/model/events.dart';
import 'package:ceyca/model/devotion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DevotionNotifier extends ChangeNotifier {
  List<devotion> _devotionList = [];
  devotion _currentDevotion;
  List<events> _eventsList = [];
  DocumentSnapshot _lastDocument;
  final int per_page = 30;
  int length;
  bool hasMore = true;
  bool isLoading = false;
  bool eve = true;
  bool firstTime = true;

  Future<List<events>> getEvents() async {
    if(eve){
 QuerySnapshot snapshot =
        await Firestore.instance.collection('events').getDocuments();
    if (snapshot.documents == null) {
      throw new Exception("server error");
    } else {
      snapshot.documents.forEach((document) {
        events d1 = events.fromMap(document.data);
        _eventsList.add(d1);
      });

      print(snapshot.documents.length);
      print(_eventsList);
      print("length");
      print(_eventsList[0].pictures.length);
       eve = false;

      return _eventsList;
    }
    }else{
      print("already");
       return _eventsList;
    }
   
  }

  Future<void> getDevotions() async {
    if (firstTime) {
      print("intial");
      QuerySnapshot snapshot = await Firestore.instance
          .collection('devotions')
          .orderBy('time', descending: true)
          .limit(per_page)
          .getDocuments();
      if (snapshot.documents == null) {
        throw new Exception("server error");
      } else {
        if (snapshot.documents.length != 0) {
          _lastDocument = snapshot.documents[snapshot.documents.length - 1];
        } else {
          hasMore = false;
        }

        snapshot.documents.forEach((document) {
          devotion d1 = devotion.fromMap(document.data);
          _devotionList.add(d1);
        });

        print(snapshot.documents.length);
        print(_devotionList);
        firstTime = false;

        return _eventsList;
      }
    } else {
      print("second time");
      isLoading = true;
      QuerySnapshot snapshot = await Firestore.instance
          .collection('devotions')
          .orderBy('time', descending: true)
          .startAfter([_lastDocument['time']])
          .limit(per_page)
          .getDocuments();
      isLoading = false;
      if (snapshot.documents == null) {
        throw new Exception("server error");
      } else {
        if (snapshot.documents.length != 0) {
          _lastDocument = snapshot.documents[snapshot.documents.length - 1];
        } else {
          hasMore = false;
        }
        snapshot.documents.forEach((document) {
          devotion d1 = devotion.fromMap(document.data);
          _devotionList.add(d1);
        });
        print(snapshot.documents.length);
        print(_devotionList);
        firstTime = false;

        return _devotionList;
      }
    }
  }

  refresh() {
    devotionList = [];
    hasMore = true;
    isLoading = false;
    firstTime = true;
    getDevotions();
  }

  DevotionNotifier get instance => this;

  UnmodifiableListView<devotion> get devotionList =>
      UnmodifiableListView(_devotionList);

  UnmodifiableListView<events> get eventsList =>
      UnmodifiableListView(_eventsList);

  devotion get currentdevotion => _currentDevotion;

  set devotionList(List<devotion> devotionList) {
    _devotionList = devotionList;
  }

   set eventsList(List<events> eventsList) {
    _eventsList = eventsList;
  }

  set currentdevotion(devotion devotion) {
    _currentDevotion = devotion;
  }
}
