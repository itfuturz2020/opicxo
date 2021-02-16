import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:opicxo/Common/Services.dart';
import 'package:opicxo/Common/Constants.dart' as cnst;
import 'package:opicxo/Common/Constants.dart' as constant;
import 'package:opicxo/Components/CustomerComponent.dart';
import 'package:url_launcher/url_launcher.dart';

class MychildCustomerList extends StatefulWidget {
  @override
  _MychildCustomerListState createState() => _MychildCustomerListState();
}

class _MychildCustomerListState extends State<MychildCustomerList> {
  bool isLoading = false;
  List ChildGuestData = new List();
  String CustomerId;

  @override
  void initState() {
    GetChildCustomerData();
    _getLocaldata();
  }

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CustomerId = prefs.getString(constant.Session.StudioId);
  }

  GetChildCustomerData() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        Services.MyCustomerList(CustomerId).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              ChildGuestData = data;
              print("ChildGuestData");
              print(ChildGuestData);
            });
          } else {
            setState(() {
              ChildGuestData = data;
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showHHMsg("Try Again.", "");
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showHHMsg("No Internet Connection.", "");
      }
    } on SocketException catch (_) {
      showHHMsg("No Internet Connection.", "");
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, "/Dashboard");
      },
      child: Scaffold(
        bottomNavigationBar: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/AddCustomer');
          },
          child: Container(
            height: 50,
            color: constant.appPrimaryMaterialColorPink,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                Text(
                  "Add Invite",
                  style: GoogleFonts.aBeeZee(
                    textStyle: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
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
          title: Text(
            "My Invites",
            style: GoogleFonts.aBeeZee(
              textStyle: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/Dashboard");
              }),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(
                  "images/back99.png",
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            isLoading
                ? Container(
                    child: Center(child: CircularProgressIndicator()),
                  )
                : ChildGuestData.length > 0
                    ? ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return ChildCustomerComponent(ChildGuestData[index],
                              () {
                            GetChildCustomerData();
                          });
                        },
                        itemCount: ChildGuestData.length,
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset("images/no_data.png",
                                width: 40, height: 40, color: Colors.grey),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "No Invites Found",
                                style: GoogleFonts.aBeeZee(
                                    textStyle: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey)),
                              ),
                            )
                          ],
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
