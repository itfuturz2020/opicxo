import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opicxo/Common/Constants.dart' as cnst;
import 'package:opicxo/Components/StudioNameOnTap.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:opicxo/Common/Services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudioLocationComponent extends StatefulWidget {
  var NewList;

  StudioLocationComponent(this.NewList);

  @override
  _StudioLocationComponentState createState() =>
      _StudioLocationComponentState();
}

class _StudioLocationComponentState extends State<StudioLocationComponent> {

  List NewList = [];
  ProgressDialog pr;
  bool isLoading = true;

  @override
  void initState() {
    _getAddressBranch();
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait..",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
            //backgroundColor: cnst.appPrimaryMaterialColor,
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
  }

  _getAddressBranch() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String CustomerId =
        await preferences.getString(cnst.Session.StudioId);
        print("yyy=> " + preferences.getString(cnst.Session.StudioId));
        Future res = Services.GetAddressBranch(CustomerId);
        setState(() {
          isLoading = true;
        });

        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              NewList = data;
              isLoading = false;
            });
          } else {
            setState(() {
              NewList = [];
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : on NewLead Data Call $e");
          showMsg("$e");
        });
      } else {
        showMsg("Something went Wrong!");
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
          elevation: 2,
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

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  Widget detailsofstudio(){
    int current=0;
      // return SingleChildScrollView(
      //     child:
      //     StudioNameOnTap(NewList[current]),
      // );
    return ListView.builder(
        itemCount: NewList.length,
        itemBuilder: (BuildContext context, int index) {
          return
              StudioNameOnTap(NewList[index]);
        });
  }

  // void _createEmail() async{
  //   const emailaddress = '${widget.NewList["Email"]}';
  //
  //   if(await canLaunch(emailaddress)) {
  //     await launch(emailaddress);
  //   } else {
  //     throw 'Could not Email';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GestureDetector(
        // onTap: (){
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => detailsofstudio(),
        //     ),
        //   );
        // },
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          elevation: 5,
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            padding: EdgeInsets.symmetric(
                horizontal: 10.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text("${widget.NewList["MainStudioName"]}",
                          style: TextStyle(
                            fontSize: 40,
                          ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left :6.0),
                              child: IconButton(
                                  icon: Icon(Icons.call, color: Colors.green),
                                  onPressed: () {
                                    launch("tel:" + '${widget.NewList["Mobile"]}');
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left : 16.0),
                              child: Text(
                                "Call",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.deepOrange,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left :6.0),
                              child: IconButton(
                                  icon: Icon(Icons.mail, color: Colors.green),
                                  onPressed: () {
                                      launch('mailto:${widget.NewList["Email"]}?subject=Sample Subject&body=This is a Sample email');
                                  }
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left : 16.0),
                              child: Text(
                                "Email",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.deepOrange,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Column(
                        //   children: [
                        //     Padding(
                        //       padding: const EdgeInsets.only(left :6.0,top: 13),
                        //       child: GestureDetector(
                        //         onTap: (){
                        //           launch('https://www.google.com/maps/dir/api=1');
                        //         },
                        //         child: Image.asset(
                        //           "images/google-maps.png",
                        //           height: 27,
                        //           width: 27,
                        //         fit: BoxFit.cover,
                        //         ),
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       height: 10,
                        //     ),
                        //     Padding(
                        //       padding: const EdgeInsets.only(left : 16.0),
                        //       child: Text(
                        //         "Maps",
                        //         style: TextStyle(
                        //           fontWeight: FontWeight.bold,
                        //           fontSize: 20,
                        //           color: Colors.deepOrange,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),

              ],
            ),
          ),
        ),
      ),
    );

  }
}
