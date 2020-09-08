
import 'package:ceyca/widget/app_clipper.dart';
import 'package:ceyca/widget/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:ceyca/Notifiers/DevotionNotifier.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;



class DetailPage extends StatefulWidget {
  int index;
  DetailPage();
  DetailPage.fromDevotion(this.index);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final GlobalKey _cardKey = GlobalKey();
  Size cardSize;
  Offset cardPosition;
  List<Color> color = [
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.pink,
    Colors.green,
    Colors.red,
    Colors.lightBlueAccent,
    Colors.teal
  ];
  DevotionNotifier d;
  double height;
  double addedSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getSizeAndPosition());
  }

  getSizeAndPosition() {
    RenderBox _cardBox = _cardKey.currentContext.findRenderObject();
    cardSize = _cardBox.size;
    cardPosition = _cardBox.localToGlobal(Offset.zero);
    print(cardSize.height);
    print(height);
    if (height > cardSize.height) {
      addedSize = (height - cardSize.height) + cardSize.height;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    d = Provider.of<DevotionNotifier>(context, listen: true);
    height = MediaQuery.of(context).size.height;
    // if(MediaQuery.of(context).size.height < height){
    //   print("add more");
    // }
    // print(cardPosition);
    return Scaffold(
      backgroundColor: color[widget.index],
      appBar: AppBar(
        backgroundColor: color[widget.index],
        elevation: 0,
        title: Text("${d.currentdevotion.time}"),
        leading: IconButton(
          icon: Icon(FontAwesome.angle_left),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              key: _cardKey,
              height: addedSize ?? null,
              width: MediaQuery.of(context).size.width,
              child: ClipPath(
                clipper: AppClipper(
                  cornerSize: 50,
                  diagonalHeight: 180,
                  roundedBottom: false,
                ),
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(top: 180, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Text(
                          "${d.currentdevotion.topic}",
                          style: TextStyle(
                            fontSize: 32,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      
                      SizedBox(height: 24),
                      Center(
                        child: Text(
                          "${d.currentdevotion.verse}",
                          style: TextStyle(
                            fontFamily: 'bellota',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Center(
                        // height: addedSize ?? null,
                        child: Text(
                          "${d.currentdevotion.content}",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black38,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Center(
                        child: Text(
                          "Prayer",
                          style: TextStyle(
                            fontFamily: 'Merriweather',
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          "${d.currentdevotion.confession}",
                          style: TextStyle(
                            fontFamily: 'Merriweather',
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Center(
                        child: Text(
                          "FURTHER STUDY :",
                          style: TextStyle(
                            fontFamily: 'bellota',
                            letterSpacing: 5,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          "${d.currentdevotion.furtherReading}",
                          style: TextStyle(
                            fontFamily: 'bellota',
                            fontSize: 18,
                            color: Colors.black38,
                          ),
                        ),
                      ),

                     
                    ],
                  ),
                ),
              ),
            ),
            // Positioned(
            //   bottom: 0,
            //   // child: _buildBottom(),
            // ),
            Positioned(
              top: -50,
              right: 15,
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Hero(
                  tag: "assets/images/CEYC1.png" + "${widget.index.toString()}",
                  child: Image(
                    width: MediaQuery.of(context).size.width * .30,
                    image: AssetImage("assets/images/CEYC1.png"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottom() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 1,
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "PRICE",
                style: TextStyle(
                  color: Colors.black26,
                ),
              ),
              Text(
                "1",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 50,
            ),
            decoration: BoxDecoration(
              color: AppColors.greenColor,
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
            ),
            child: Text(
              "ADD CART",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorOption(Color color) {
    return Container(
      width: 20,
      height: 20,
      margin: EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
      ),
    );
  }

  
}
