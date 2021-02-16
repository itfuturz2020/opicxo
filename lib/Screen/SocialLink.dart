import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opicxo/Common/Services.dart';
import 'package:opicxo/Common/Constants.dart' as cnst;
import 'package:opicxo/Components/LoadinComponent.dart';
import 'package:opicxo/Components/NoDataComponent.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialLink extends StatefulWidget {
  @override
  _SocialLinkState createState() => _SocialLinkState();
}

class _SocialLinkState extends State<SocialLink> {
  bool isLoading = false;
  List _socialLinkData = [];

  @override
  void initState() {
    getSocialLinks();
  }

  getSocialLinks() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.GetStudioSocialLinkList();
        res.then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              _socialLinkData = data;
            });
            print("'yash : " + _socialLinkData.toString());
          } else {}
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : $e");
          showMsg("$e");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Error"),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[
                cnst.appPrimaryMaterialColorYellow,
                cnst.appPrimaryMaterialColorPink
              ],
            ),
          ),
        ),
        title: Text("Social Links",
            style: GoogleFonts.aBeeZee(
                textStyle: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                    color: Colors.white))),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                "images/social.png",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.fill,
              ),
            ),
          ),
          isLoading
              ? LoadinComponent()
              : _socialLinkData.length > 0
                  ? Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            "images/connection.png",
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: _socialLinkData.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin: EdgeInsets.only(
                                      left: 7, bottom: 7, right: 7, top: 12),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "${_socialLinkData[index]["StudioName"]}",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      /*Padding(padding: EdgeInsets.only(top: 40)),*/
                                      _socialLinkData[index]["SocialLinkList"]
                                                  .length > 0
                                          ? ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: _socialLinkData[index]
                                                      ["SocialLinkList"]
                                                  .length,
                                              physics: ClampingScrollPhysics(),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int i) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    _launchURL(
                                                        "${_socialLinkData[index]["SocialLinkList"][i]["Link"]}");
                                                  },
                                                  child: Column(
                                                    children: <Widget>[
                                                      Card(
                                                        margin:
                                                            EdgeInsets.all(8),
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(7),
                                                          child: Row(
                                                            children: <Widget>[
                                                              _socialLinkData[index]["SocialLinkList"]
                                                                              [i]
                                                                          ["Image"] != null
                                                                  ? FadeInImage.assetNetwork(
                                                                      placeholder:
                                                                          'images/instagram.png',
                                                                      image:
                                                                          "${cnst.ImgUrl}${_socialLinkData[index]["SocialLinkList"][i]["Image"]}",
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      height:
                                                                          35,
                                                                      width: 35)
                                                                  : Image.asset(
                                                                      'images/insta_placeholder.png',
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      height:
                                                                          35,
                                                                      width: 35,
                                                                    ),
                                                              Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              15)),
                                                              Text(
                                                                  "${_socialLinkData[index]["SocialLinkList"][i]["Title"]}",
                                                                  style: GoogleFonts.aBeeZee(
                                                                      textStyle: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          color:
                                                                              Colors.grey[800]))),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            )
                                          : Center(child: NoDataComponent()),
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ],
                    )
                  : Center(child: NoDataComponent()),

        ],
      ),
    );
  }
}
