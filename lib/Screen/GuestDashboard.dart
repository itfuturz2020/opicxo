import 'dart:async';
import 'dart:io';

//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:opicxo/Common/Constants.dart' as cnst;
import 'package:opicxo/Common/Services.dart';
import 'package:opicxo/Pages/GuestHome.dart';
import 'package:opicxo/Pages/Profile.dart';
import 'package:opicxo/Screen/AnimatedBottomBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'GuestAboutUs.dart';
import 'CustomerNotificationPage.dart';
import 'GuestNotificationPage.dart';

class GuestDashboard extends StatefulWidget {
  @override
  _GuestDashboardState createState() => _GuestDashboardState();
}

class _GuestDashboardState extends State<GuestDashboard> {
  int _currentIndex = 0;
  StreamSubscription iosSubscription;
  bool dialVisible = true;

  //FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*if (Platform.isIOS) {
      iosSubscription =
          _firebaseMessaging.onIosSettingsRegistered.listen((data) {
        print("FFFFFFFF" + data.toString());
        saveDeviceToken();
      });
      _firebaseMessaging
          .requestNotificationPermissions(IosNotificationSettings());
    } else {
      saveDeviceToken();
    }*/
  }

  saveDeviceToken() async {
    /*_firebaseMessaging.getToken().then((String token) {
      print("Original Token:$token");
      setState(() {
        //fcmToken = token;
        sendFCMTokan(token);
      });
      print("FCM Token : $token");
    });*/
  }

  //send fcm token
  sendFCMTokan(var FcmToken) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.SendTokanToServer(FcmToken);
        res.then((data) async {}, onError: (e) {
          print("Error : on Login Call");
        });
      }
    } on SocketException catch (_) {}
  }

  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/Login', (Route<dynamic> route) => false);
  }

  confirmation(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("PICTIK"),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog

            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                _logout();
              },
            ),
          ],
        );
      },
    );
  }

  List<String> titleList = [
    "Portfolio",
    "Profile",
    // "Notification",
    "About PICTIK",
  ];

  List<BarItem> barItems = [
    BarItem(text: "Portfolio", iconData: Icons.work, color: Colors.teal),
    BarItem(
        text: "Profile", iconData: Icons.person, color: Colors.yellow.shade900),
    /*  BarItem(
        text: "Notification",
        iconData: Icons.notifications_active,
        color: Colors.deepOrange.shade600),*/
    BarItem(text: "About Us", iconData: Icons.info, color: Colors.lightGreen),
  ];

  final List<Widget> _children = [
    GuestHome(),
    Profile(),
    //GuestNotificationPage(),
    GuestAboutUs(),
  ];

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
        automaticallyImplyLeading: false,
        title: Text(titleList[_currentIndex].toString()),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              confirmation("Are you sure you want to Logout?");
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                Icons.power_settings_new,
                color: Colors.white,
                size: 30,
              ),
            ),
          )
        ],
      ),
      /*floatingActionButton: SpeedDial(
        // both default to 16
        marginRight: 8,
        marginBottom: 8,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(
          size: 22.0,
        ),
        // this is ignored if animatedIcon is non null
        // child: Icon(Icons.add),
        visible: dialVisible,
        // If true user is forced to close dial manually
        // by tapping main button and overlay is not rendered.
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        //tooltip: 'Speed Dial',
        //heroTag: 'speed-dial-hero-tag',
        backgroundColor: cnst.appPrimaryMaterialColorYellow,
        foregroundColor: Colors.white,
        //child: Icon(Icons.add),
        elevation: 4.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(Icons.access_time),
              backgroundColor: Colors.deepPurple,
              label: 'Book Appointment',
              labelStyle: TextStyle(fontSize: 17.0),
              onTap: () {
                Navigator.pushNamed(context, '/BookAppointment');
              }),
          */ /*SpeedDialChild(
              child: Icon(Icons.accessibility),
              backgroundColor: Colors.red,
              label: 'Add Customer',
              labelStyle: TextStyle(fontSize: 17.0),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/AddCustomer');
              }),
          SpeedDialChild(
              child: Icon(Icons.brush),
              backgroundColor: Colors.blue,
              label: 'View Portfolio',
              labelStyle: TextStyle(fontSize: 17.0),
              onTap: () {
                Navigator.pushNamed(context, '/PortfolioScreen');
              }),*/ /*
          SpeedDialChild(
            child: Icon(Icons.link),
            backgroundColor: Colors.green,
            label: 'Social Link',
            labelStyle: TextStyle(fontSize: 17.0),
            onTap: () {
              Navigator.pushNamed(context, '/SocialLink');
            },
          ),
        ],
      ),*/
      bottomNavigationBar: SafeArea(
        child: AnimatedBottomBar(
          barItems: barItems,
          animationDuration: Duration(milliseconds: 350),
          onBarTab: (index) {
            setState(
              () {
                _currentIndex = index;
              },
            );
          },
        ),
      ),
      body: _children[_currentIndex],
    );
  }
}
