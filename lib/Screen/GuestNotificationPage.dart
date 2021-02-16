import 'dart:io';
import 'package:opicxo/Common/Constants.dart' as cnst;
import 'package:flutter/material.dart';
import 'package:opicxo/Common/Services.dart';
import 'package:opicxo/Components/NoDataComponent.dart';
import 'package:opicxo/Components/NotificationComponent.dart';

class GuestNotificationPage extends StatefulWidget {
  @override
  _GuestNotificationPageState createState() => _GuestNotificationPageState();
}

class _GuestNotificationPageState extends State<GuestNotificationPage> {
  bool isLoading = false;
  List list = new List();

  @override
  void initState() {
    isLoading = true;
    // TODO: implement initState
    super.initState();
    getDailyProgressFromServer();
  }

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
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

  getDailyProgressFromServer() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.GetNotificationFromServer();
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              isLoading = false;
              list = data;
            });
          } else {
            //showMsg("Try Again.");
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          print("Error : on Login Call $e");
          showMsg("$e");
          setState(() {
            isLoading = false;
          });
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  DateTime currentBackPressTime;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                "images/back15.png",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : list.length != 0 && list != null
                      ? ListView.builder(
                          padding: EdgeInsets.only(top: 5),
                          itemCount: list.length,
                          itemBuilder: (BuildContext context, int index) {
                            return NotificationComponent(list[index]);
                          },
                        )
                      : NoDataComponent()),
        ],
      ),
    );
  }
}
