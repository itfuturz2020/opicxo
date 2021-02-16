import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opicxo/Common/Constants.dart';
import 'package:opicxo/Common/Services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Common/Constants.dart' as cnst;
import 'OfferDetailScreen.dart';

class Offers extends StatefulWidget {
  @override
  _OffersState createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  String dropdownValue, photographerId = "";
  List PhotographerList = [];

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
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

  @override
  void initState() {
    GetPhotogrpaherOffers();
  }

  GetPhotogrpaherOffers() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      photographerId = prefs.getString(Session.StudioId);
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetPhotogrpaherOffers(photographerId.toString());
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              PhotographerList = data;
            });
            print("PhotographerList");
            print(PhotographerList);
          } else {
            setState(() {
              PhotographerList.clear();
            });
            //showMsg("Try Again.");
          }
        }, onError: (e) {
          print("Error : on Login Call $e");
          //showMsg("$e");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        automaticallyImplyLeading: false,
        title: Text(
          "Offers",
          style: GoogleFonts.aBeeZee(
            textStyle: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
        actions: <Widget>[
          // Padding(
          //   padding: const EdgeInsets.only(right:8.0),
          //   child: GestureDetector(
          //     onTap: (){
          //       setState(() {
          //         EditName.text = name;
          //         EditMobile.text = mobile;
          //         EditEmail.text = email;
          //         editpressed = true;
          //       });
          //     },
          //       child: !editpressed ||updatepressed? Icon(
          //           Icons.edit,
          //       ) : GestureDetector(
          //         onTap: (){
          //           setState(() {
          //             name  =EditName.text;
          //             mobile = EditMobile.text;
          //             email = EditEmail.text;
          //           });
          //           _updateProfile();
          //           setState(() {
          //             updatepressed = true;
          //           });
          //         },
          //         child: Icon(
          //           Icons.update,
          //         ),
          //       ),
          //   ),
          // ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 15.0, left: 15, top: 15),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  // scrollDirection: Axis.horizontal,
                  itemCount: PhotographerList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OfferDetailScreen(
                                          PhotographerList: PhotographerList,
                                          index: index)));
                            },
                            child: Container(
                              height: 179,
                              width: MediaQuery.of(context).size.width,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  "${PhotographerList[index]["Image"]}",
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0.0,
                            left: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(12.0),
                                      topRight: Radius.circular(12.0),
                                      topLeft: Radius.circular(12.0)),
                                  color: Color(0xff16B8FF3D),
                                ),
                                child: Center(
                                  child: Text(
                                    "${PhotographerList[index]["Title"]}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0.0,
                            right: 0.0,
                            child: Container(
                              height: 24,
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(12.0),
                                    topLeft: Radius.circular(12.0)),
                                color: Color(0xff16B8FF3D),
                                //color: ColorUtils.buttonDarkBlueColor,
                              ),
                              child: Center(
                                child: Text(
                                  "Expires on ${PhotographerList[index]["ValidTill"]}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
