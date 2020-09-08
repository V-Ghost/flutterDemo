import 'package:firebase_database/firebase_database.dart';

/*
  [MUST DO]
  #1 Writing Test
  #2 TypeChecking
  #3 Handling Errors
  #4 Document the Code
 */


class Message {
  String theId;
  String theMessage;
  String theUser;

  Message({this.theId, this.theMessage, this.theUser });

  String get id => theId;
  String get message => theMessage;
  String get user => theUser;

  Message.fromSnapshot(DataSnapshot snapshot) :
        theId = snapshot.key ?? '',
        theMessage = snapshot.value["message"] ?? '', 
        theUser = snapshot.value["user"] ?? '';

  toJson() {
    return {
      theId : {
        "message": theMessage,
        "user" : theUser
      }
    };
  }

  bool valid() {
    return this != null && theId != null && theId != '' && theMessage != null &&
           theMessage != '' && theMessage != null && theUser != '' && theUser != null;
  }
}