import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opicxo/Common/Services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:opicxo/Common/Constants.dart' as constant;
import 'package:opicxo/Common/Constants.dart';
import 'package:opicxo/Common/Services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:opicxo/Common/Constants.dart' as cnst;
import 'package:get_it/get_it.dart';

class ChildCustomerComponent extends StatefulWidget {
  var ChildGuestData;
  Function onDelete;

  ChildCustomerComponent(this.ChildGuestData, this.onDelete);

  @override
  _ChildCustomerComponentState createState() => _ChildCustomerComponentState();
}

class _ChildCustomerComponentState extends State<ChildCustomerComponent> {
  List VehicleData = new List();
  bool isLoading = false;
  String StudioId,Username,Password;
  static String Applink = "";

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    StudioId = prefs.getString(constant.Session.StudioId);
    Username = prefs.getString(constant.Session.UserName);
    Password = prefs.getString(constant.Session.Password);
  }

  @override
  void initState() {
    _getLocaldata();
  }

  _deleteChildGuest(String ChildGuestId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Services.DeleteChileCustomer(ChildGuestId).then((data) async {
          if (data.Data == "1") {
            setState(() {
              isLoading = false;
            });
            widget.onDelete();
          } else {
            data.Data;
            isLoading = false;
            showHHMsg("Vehicle Is Not Deleted", "");
          }
        }, onError: (e) {
          isLoading = false;
          showHHMsg("$e", "");
          isLoading = false;
        });
      } else {
        showHHMsg("No Internet Connection.", "");
      }
    } on SocketException catch (_) {
      showHHMsg("Something Went Wrong", "");
    }
  }

  _GetAppLink(bool flag) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var name = prefs.getString(Session.Name);
      var password = prefs.getString(Session.Password);
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isLoading = false;
        Services.ShareAppMessage(StudioId).then((data) async {
          if (data.Data == "1") {
            isLoading = false;
            setState(() {
              Applink = data.Message;
            });
            widget.onDelete();
            Share.share(data.Message.toString());
            if (flag) {
              launch(
                  "https://wa.me/+91${widget.ChildGuestData["Mobile"]}?text=Download the pictik app from below link to get your photos. \n http://tinyurl.com/y2vnvfnb \n Login with the below given details \n Username : ${Username} \n Password : ${Password}");
            }
          } else {
            isLoading = false;
            showHHMsg("Something Went Wrong", "");
          }
        }, onError: (e) {
          isLoading = false;
        });
      } else {
        showHHMsg("No Internet Connection.", "");
      }
    } on SocketException catch (_) {
      showHHMsg("Something Went Wrong", "");
    }
  }

  _UpdateInviteStatus(String ChildGuestId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isLoading = true;
        Services.UpdateInviteStatus(ChildGuestId).then((data) async {
          if (data.Data == "1") {
            isLoading = false;
            _GetAppLink(true);
          } else {
            isLoading = false;
            showHHMsg("Something Went Wrong", "");
          }
        }, onError: (e) {
          isLoading = false;
          showHHMsg("$e", "");
          isLoading = false;
        });
      } else {
        showHHMsg("No Internet Connection.", "");
      }
    } on SocketException catch (_) {
      showHHMsg("Something Went Wrong", "");
    }
  }

  showHHMsg(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showConfirmDialog(String Id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Are You Sure You Want To Delete?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("No",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteChildGuest(Id);
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(3),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  image: new DecorationImage(
                      image: AssetImage("images/man.png"), fit: BoxFit.cover),
                  borderRadius: BorderRadius.all(new Radius.circular(75.0)),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 9.0),
                      child: Text('${widget.ChildGuestData["Name"]}',
                          style: GoogleFonts.aBeeZee(
                              textStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(81, 92, 111, 1)))),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 1.0, top: 5.0, bottom: 5),
                      child: Text('${widget.ChildGuestData["Mobile"]}',
                          style: GoogleFonts.aBeeZee(
                              textStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700]))),
                    ),
                    widget.ChildGuestData["InviteStatus"] == "Pending"
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 1.0, top: 3.0, bottom: 4.0),
                            child: Text('Pending',
                                style: GoogleFonts.aBeeZee(
                                    textStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red))),
                          )
                        : widget.ChildGuestData["IsVerified"] == null
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 1.0, top: 3.0, bottom: 4.0),
                                child: Text('Invited',
                                    style: GoogleFonts.aBeeZee(
                                        textStyle: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.green))),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(
                                    left: 1.0, top: 3.0, bottom: 4.0),
                                child: Text('App Downloaded',
                                    style: GoogleFonts.aBeeZee(
                                        textStyle: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.amber))),
                              ),
                  ],
                ),
              ),
            ),
            IconButton(
                icon: Icon(Icons.call, color: Colors.black),
                onPressed: () {
                  launch("tel:" + '${widget.ChildGuestData["Mobile"]}');
                }),

            SizedBox(
              width: 6,
            ),
            GestureDetector(
              onTap: () {
                print(widget.ChildGuestData["Mobile"]);
                _GetAppLink(true);
                launch("https://wa.me/+91${widget.ChildGuestData["Mobile"]}");
              },
              child: Image.asset(
                "images/whatsapp.png",
                height: 40,
                width: 40,
                fit: BoxFit.contain,
              ),
            ),
           /* IconButton(
                icon: Icon(
                  Icons.share,
                  color: Colors.grey,
                ),
                onPressed: () {
                  _UpdateInviteStatus('${widget.ChildGuestData["Id"]}');

                  // widget.onDelete();
                }),*/
            IconButton(
                icon: Icon(Icons.delete, color: Colors.red[400]),
                onPressed: () {
                  _showConfirmDialog('${widget.ChildGuestData["Id"]}');
                }),

            //minWidth: 30,
          ],
        ),
      ),
    );
  }
}
