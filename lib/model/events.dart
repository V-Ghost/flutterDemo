import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:time_formatter/time_formatter.dart';

class events{
 String time;
 String name;
 String location;
 String description;
 String timestamp;
 String days;
 List pictures;
 List videos;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

 events();

 events.fromMap(Map<String,dynamic> data){
   final String formatted = formatter.format(data['time'].toDate()).toString();
   String t = formatTime(data['time'].toDate().millisecondsSinceEpoch);

  //  print(t);
 
  //sets all private values to values of the input map
days = t;
time = formatted;
timestamp = DateTimeFormat.format(data['time'].toDate(), format: DateTimeFormats.american);
location = data['location'];
name = data['name'];
description = data['description'];
pictures = data['pictures'];
videos = data['videos'];
}

// events.map(Map<String,dynamic> data){
//   events e = events.fromMap(data);
//   data['time'] = [e];
// }

// Map<String, dynamic> toMap(){
// return{
//   'time' : time,
//   'location' : location,
//   'name' : name,
//   'pictures' : pictures,
//    'videos':videos,
//    };
}




