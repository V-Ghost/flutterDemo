import 'package:ceyca/model/message.dart';
import 'package:firebase_database/firebase_database.dart';

/*
  [MUST DO]
  #1 Writing Test
  #2 TypeChecking
  #3 Handling Errors
  #4 Document the Code
 */

class Group {
  String theName;
  String thePhoto;
  List<Message> theMessages;
  Set<String> theAdmins;
  Set<String> theUsers;

  Group({ this.theName, this.thePhoto, this.theMessages, this.theAdmins, this.theUsers });

  String get name => theName;
  String get photo => thePhoto;
  List<Message> get messages => theMessages;
  List<String> get users => theUsers.toList();
  List<String> get admins => theAdmins.toList();

  Group.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic> tempMap;
    theName = map ?? '';
    thePhoto = map["photo"] ?? '';
    tempMap = map["users"] ?? {};
    tempMap.forEach((String key, dynamic value){
      theUsers.add(key);
    });
    tempMap = map["admins"] ?? {};
    tempMap.forEach((String key, dynamic value){
      theAdmins.add(key);
    });
    tempMap = map["messages"] ?? {};
    tempMap.forEach((key, value) {
      theMessages.add(Message.fromSnapshot(value));
    });
  }

  Group.fromSnapshot(DataSnapshot snapshot) {
    Map<String, dynamic> map;
    print(snapshot.value);
    theName = snapshot.key ?? '';
    thePhoto = snapshot.value["photo"] ?? '';
    map = snapshot.value["users"] ?? {};
    map.forEach((String key, dynamic value){
      theUsers.add(key);
    });
    map = snapshot.value["admins"] ?? {};
    map.forEach((String key, dynamic value){
      theAdmins.add(key);
    });
    map = snapshot.value["messages"] ?? {};
    map.forEach((key, value) {
      theMessages.add(Message.fromSnapshot(value));
    });
  }

  toJson() {
    Map<String, dynamic> msgList;
    theMessages.forEach((msg) {
      msgList.addAll(msg.toJson());
    });
    return {
      theName : {
        "photo" : thePhoto,
        "users" : theUsers,
        "admins" : theAdmins,
        "messages" : theMessages,
      }
    };
  }
  
  
  // <<<<----------- ADD USER ------------->>>>
  void addUser(String id) {
    // Sets are faster. The use internal hash tables to search faster
    if ( id != null && !theUsers.contains(id) )
      theUsers.add(id);
  }
  
  
  // <<<<----------- ADD ADMIN ------------->>>>
  void addAdmin(String id) {
    // Sets are faster. The use internal hash tables to search faster
    if ( id != null && !theAdmins.contains(id) )
      theAdmins.add(id);
  }

  
  // <<<<---------- REMOVE USER ----------->>>>
  void removeUser(String id) {
    if ( id != null && id != '' && theUsers.contains(id) ) {
      theUsers.remove(id);
    }
  }


  // <<<<---------- REMOVE ADMIN ----------->>>>
  void removeAdmin(String id) {
    if ( id != null && id != '' && theAdmins.contains(id) ) {
      theAdmins.remove(id);
    }
  }
  

  // <<<<----------- ADD MESSAGES ----------->>>>
  void addMessage(Message message) {
    if ( message.valid() ) {
      theMessages.add(message);
    }
  }


  // <<<<----------- REMOVE MESSAGES ----------->>>>
  void removeMessage(String id) {
    if ( id != null && id != '' ) {
      theMessages.removeWhere((msg) => msg.id == id );
    }
  }


  bool valid() {
    return this != null && theName != '' && theName != null && thePhoto != null &&
           thePhoto != '' && theUsers != null && theAdmins != null && theMessages != null;
  }
}