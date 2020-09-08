import 'package:firebase_database/firebase_database.dart';

/*
  [MUST DO]
  #1 Writing Test
  #2 TypeChecking
  #3 Handling Errors
  #4 Document the Code
 */

class User {
  String theName;
  String theEmail;
  String thePhoto;
  String thePhone;

  User({this.theName, this.theEmail, this.thePhoto, this.thePhone});

  String get name => theName;
  String get email => theEmail;
  String get photo => thePhoto;
  String get phone => thePhone;

  User.fromMap(Map<String, String> map)://This function creates a user model from a map
    theName = map["name"] ?? '',
    theEmail = map["email"] ?? '',
    thePhoto = map["photo"] ?? '',
    thePhone = map["phone"] ?? '';

  User.fromSnapshot(DataSnapshot snapshot)://This function creates a user model from a Snapshot
    thePhone = snapshot.key ?? '',
    theName = snapshot.value["name"] ?? '', 
    theEmail = snapshot.value["email"] ?? '',
    thePhoto = snapshot.value["photo"] ?? ''; 

  Map<String, dynamic> toJson() {
    return {//This function turns
      thePhone: {
        "name": theName,
        "email" : theEmail,
        "photo" : thePhoto
      }    
    };
  }

  bool valid() {
    return this != null &&
           theEmail != '' && theEmail != null && thePhone != '' && thePhone != null
           && theName != '' && theName != null && thePhoto != '' && thePhoto != null;
  }
}