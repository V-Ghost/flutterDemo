import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class devotion{
String content;
String time;
String topic;
String confession;
String furtherReading;
String verse;

devotion();

devotion.fromMap(Map<String,dynamic> data){
  //sets all private values to values of the input map
content = data['content'];

time = convertTimetoString(data['time']);
topic = data['topic'];
confession = data['confession'];
furtherReading = data['furtherReading'];
verse = data['verse'];
}

String convertTimetoString(Timestamp day){
     DateTime date = day.toDate();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(date);
    return formatted;
}
// Map<String, dynamic> toMap(){
// return{
//   'content' : content,
//   'time' : time,
//   'topic' : topic,
   
//    'key':key,
//    'verse':verse,
// };
// }









}