import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:opicxo/Common/Constants.dart' as cnst;
import 'package:shared_preferences/shared_preferences.dart';

class AllImageSlideShow extends StatefulWidget {
  var albumData;

  AllImageSlideShow({this.albumData});

  @override
  _AllImageSlideShowState createState() => _AllImageSlideShowState();
}

class _AllImageSlideShowState extends State<AllImageSlideShow> {
  List imageList = new List();
  int _value;

  String _statusText = "";

  @override
  void initState() {
    getLocal();
    for (int i = 0; i < widget.albumData.length; i++) {
      imageList.add(cnst.ImgUrl + widget.albumData[i]["Photo"]);
    }
  }

  getLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String t = prefs.getString(cnst.Session.SlideShowSpeed);
    double time;
    print("tt ${t}");
    if (t == null || t == "") {
      time = 1.5;
    } else {
      time = double.parse(t);
    }
    setState(() {
      _value = (time * 1000).round();
    });
    print("_Value: ${_value}");
  }

  @override
  Widget build(BuildContext context) {
    print("data: ${widget.albumData.toString()}");
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
      },
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              leading: Container(),
              backgroundColor: Colors.black,
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.clear, color: Colors.white),
                )
              ],
            ),
            body: Center(
              child: Container(
                //height: MediaQuery.of(context).size.height / 1.2,
                width: MediaQuery.of(context).size.width,
                child: Carousel(
                  autoplayDuration: Duration(milliseconds: _value),
                  defaultImage: "assets/loading.gif",
                  images: imageList.map((url) {
                    return Image(
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Image.asset("assets/loading.gif");
                        },
                        image: NetworkImage(url));
                  }).toList(),
                  showIndicator: false,
                  borderRadius: true,
                  noRadiusForIndicator: true,
                  overlayShadow: false,
                ),
              ),
            )),
      ),
    );
  }
}
