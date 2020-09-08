// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// import 'package:ceyca/Notifiers/DevotionNotifier.dart';


// class Devotiontile extends StatefulWidget {
//   DevotionNotifier d;
//   int index;

//   Devotiontile(this.d, this.index);
//   @override
//   _DevotiontileState createState() => _DevotiontileState();
// }

// class _DevotiontileState extends State<Devotiontile> {
//   @override
//   Widget build(BuildContext context) {
//     DevotionNotifier _devotionNotifier = widget.d;
//     int index = widget.index;
//     String another = "https://source.unsplash.com/412x500/?";
//     String imageUrl = another +
//         _devotionNotifier.devotionList[index].key +
//         ' ' +
//         index.toString();
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     print("$index");
//     // // bool overFlowRight = true;
//     // // bool overFlowLeft = true;
//     // if (index == _devotionNotifier.devotionList.length - 1) {
//     //   overFlowRight = false;
//     //   print(
//     //       "right disabled because $index is greater than $_devotionNotifier.devotionList.length-1");
//     // }
//     // if (index == 0) {
//     //   overFlowLeft = false;
//     //   print("left disabled because $index is less than than 0");
//     // }
//     final _scaffoldKey = GlobalKey<ScaffoldState>();
//     _displaySnackBar(BuildContext context) {
//       final snackBar = SnackBar(content: Text('Are you talkin\' to me?'));
//       _scaffoldKey.currentState.showSnackBar(snackBar);
//     }

//     return WillPopScope(
//       onWillPop: (){
//         Navigator.popUntil(context, ModalRoute.withName('/'));
        
//       },
//           child: Scaffold(
//           key: _scaffoldKey,
//           body: SingleChildScrollView(
//             child: Column(
//               children: <Widget>[
//                 SafeArea(
//                   child: Container(
//                     width: width,
//                     child: Column(
//                       children: <Widget>[
//                         Hero(
//                           tag: 'h' + index.toString(),
//                           child: Stack(
//                             children: <Widget>[
//                               Container(
//                                 height: height * (0.4),

//                                 // constraints: BoxConstraints.expand(),
//                                 child: CachedNetworkImage(
//                                   width: width,
//                                   height: height * (0.4),
//                                   fit: BoxFit.fill,
//                                   imageUrl: imageUrl,
//                                   // another + _devotionNotifier.devotionList[index].key+ ' ' +index.toString(),
//                                   //  imageUrl : '',
//                                   // placeholder: (context, url) => spinKit(),
//                                   errorWidget: (context, url, error) => Container(
//                                       constraints: BoxConstraints.expand(),
//                                       child: Container(
//                                         alignment: Alignment.topLeft,
//                                         color: Colors.blue,
//                                         child: Center(child: Icon(Icons.error)),
//                                       )),
//                                 ),
//                               ),
//                               SafeArea(
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     Navigator.popUntil(context, ModalRoute.withName('/'));
                                  
//                                   },
//                                   child: Container(
//                                     alignment: Alignment.topLeft,
//                                     padding: const EdgeInsets.all(5),
//                                     child: Icon(
//                                       Icons.arrow_back_ios,
//                                       size: 40,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 navBar(width, _devotionNotifier, index, context, _scaffoldKey),
//                 Row(
//                   children: <Widget>[
//                     Expanded(
//                       child: Container(
//                         alignment: Alignment.centerLeft,
//                         padding: const EdgeInsets.all(10),
//                         child: Text(
//                           'Memory Verse :' +
//                               _devotionNotifier.devotionList[index].verse,
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 15.0,
//                             fontFamily: 'Merriweather',
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 25,
//                     ),
//                     Expanded(
//                       child: Container(
//                         alignment: Alignment.centerRight,
//                         padding: const EdgeInsets.all(10),
//                         child: Text(
//                           'Date :'
//                           style: TextStyle(
//                             fontSize: 15.0,
//                             fontFamily: 'Merriweather',
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       left: 12, right: 12, bottom: 20, top: 12),
//                   child: Center(
//                     child: Text(
//                       _devotionNotifier.devotionList[index].content,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 20.0,
//                         fontWeight: FontWeight.w600,
//                         fontFamily: 'Bellota',
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )),
//     );
//   }
// }



// Widget navBar(width, _devotionNotifier, index, context, _scaffoldKey) {
//   print("$index");
//   bool overFlowRight = true;
//   bool overFlowLeft = true;
//   if (index == _devotionNotifier.devotionList.length - 1) {
//     overFlowRight = false;
//     print(
//         "right disabled because $index is greater than $_devotionNotifier.devotionList.length-1");
//   }
//   if (index == 0) {
//     overFlowLeft = false;
//     print("left disabled because $index is less than than 0");
//   }
//   return Container(
//       width: width,
//       color: Colors.black,
//       child: Row(
//         children: <Widget>[
//           GestureDetector(
//             onTap: overFlowRight
//                 ? () {
//                     Navigator.of(context)
//                         .push(_createRoute2(_devotionNotifier, index + 1));
//                   }
//                 : () => _scaffoldKey.currentState.showSnackBar(new SnackBar(
//                         content: Text(
//                       'No more devotions here',
//                       style: TextStyle(),
//                     ))),
//             child: Container(
//               padding: const EdgeInsets.only(left: 5),
//               child: Icon(
//                 Icons.arrow_left,
//                 size: 50,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.only(left: 0, right: 0),
//               child: Text(
//                 _devotionNotifier.devotionList[index].topic,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 30.0,
//                   fontFamily: 'Pacifico',
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//           GestureDetector(
//             onTap: overFlowLeft
//                 ? () {
//                     Navigator.of(context)
//                         .push(_createRoute(_devotionNotifier, index - 1));
//                   }
//                 : () => _scaffoldKey.currentState.showSnackBar(new SnackBar(
//                         content: Text(
//                       'No more devotions here',
//                       style: TextStyle(),
//                     ))),
//             child: Container(
//               padding: const EdgeInsets.only(right: 5),
//               child: Icon(
//                 Icons.arrow_right,
//                 size: 50,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ],
//       ));
// }

// Route _createRoute(_devotionNotifier, int index) {
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) =>
//         Devotiontile(_devotionNotifier, index),
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       var begin = Offset(1.0, 0.0);
//       var end = Offset.zero;
//       var curve = Curves.ease;

//       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

//       return SlideTransition(
//         position: animation.drive(tween),
//         child: child,
//       );
//     },
//   );
// }

// Route _createRoute2(_devotionNotifier, int index) {
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) =>
//         Devotiontile(_devotionNotifier, index),
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       var begin = Offset(-1.0, 0.0);
//       var end = Offset.zero;
//       var curve = Curves.ease;

//       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

//       return SlideTransition(
//         position: animation.drive(tween),
//         child: child,
//       );
//     },
//   );
// }

// // Future<bool> _onBackPressed(context){
// //   Navigator.popUntil(context, ModalRoute.withName('/'));
// // }
