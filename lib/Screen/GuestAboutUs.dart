import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:opicxo/Common/Constants.dart' as cnst;
import 'package:flutter/material.dart';
import 'package:opicxo/Common/Services.dart';
import 'package:opicxo/Components/NoDataComponent.dart';

class GuestAboutUs extends StatefulWidget {
  @override
  _GuestAboutUsState createState() => _GuestAboutUsState();
}

class _GuestAboutUsState extends State<GuestAboutUs> {
  List giveData = [];
  bool isLoading = true;

  @override
  void initState() {
    _getGive();
  }

  _getGive() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetAboutUs();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              giveData = data;
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : on Myask Call $e");
          showMsg("Try Again.");
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
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(color: cnst.appPrimaryMaterialColorPink),
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

  DateTime currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[

        Container(
          padding: EdgeInsets.all(10),
          color: Colors.grey[200],
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                  child: Text(
                    "PICTIK",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  " Vision to be the most prefererd growth partners of photostudios globally for photography solutions and innovation.\n \n Mission Pictik is on a mission to deliver great customer experience with easing out the workflow for the photographer by giving them great digital platform which will save their Money & Time. \n \n Pictik is a platform where studio and customer can interact easily.Studio can register their studio and create album on our platform and will share that album detail with customer and customer can easily access his/her album easily.They can easily choose their images that they want to finalize for their function.This makes the work easy for the client and his customer \n \n I’D LOVE TO HEAR FROM YOU! PLEASE FILL OUT THE FORM BELOW OR SEND A NOTE DIRECTLY WITH AS MUCH DETAILS AS POSSIBLE TO INFO@DANPHOTO.COM",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54),
                ),
              ),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left:10.0,top: 30),
                        child: Icon(Icons.call,size: 25,color: Colors.green,),

                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:5.0,top: 25),
                        child: Text("+91 9510977735",style: TextStyle(fontSize: 16,color: Colors.black54),),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left:10.0,top: 20),
                        child: Icon(Icons.call,size: 25,color: Colors.green),

                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:5.0,top: 25),
                        child: Text("+91 9510977736",style: TextStyle(fontSize: 16,color: Colors.black54),),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          child: Opacity(
            opacity: 0.2,
            child: Image.asset(
              "images/pencil.png",
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    ));
  }
}
