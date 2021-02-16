import 'dart:async';
import 'dart:io';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:opicxo/Common/Constants.dart' as cnst;
import 'package:opicxo/Common/Services.dart';
import 'package:opicxo/Pages/Profile.dart';
import 'package:opicxo/Pages/Settings.dart';
import 'package:opicxo/Screen/PortfolioScreen.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AnimatedBottomBar.dart';
import 'CustomerGalleryScreen.dart';
import 'Offers.dart';

class Dashboard extends StatefulWidget {
  String mobile, id, name;
  bool loginWithMobile = false;
  int index = 2;
  Dashboard(
      {this.mobile, this.id, this.name, this.index, this.loginWithMobile});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;
  StreamSubscription iosSubscription;
  int _pos = 0;
  Timer _timer;
  List colors = [
    cnst.appPrimaryMaterialColorYellow,
    cnst.appPrimaryMaterialColorPink,
    cnst.appPrimaryMaterialColorYellow,
    cnst.appPrimaryMaterialColorPink
  ];

  //vinchu
  TextEditingController name = new TextEditingController();
  TextEditingController mobile = new TextEditingController();
  TextEditingController email = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var studioId;
  bool isLoading = true;
  List _advertisementData = new List();

  //FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Dashboard()),
    );
  }

  var platform = MethodChannel('crossingthestreams.io/resourceResolver');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.loginWithMobile);
    getStudioName();
    if (widget.loginWithMobile != null) {
      if (!widget.loginWithMobile) {
        dataaddedd();
      } else {
        widget.loginWithMobile = true;
      }
    }
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (mounted) {
        _pos = colors.length != 0 ? (_pos + 1) % colors.length : 0;
      }
    });
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

    /*var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    _showDailyAtTime();*/
    PermissionHandler().requestPermissions(<PermissionGroup>[
      PermissionGroup.storage,
    ]);
  }

  var data = "";

  dataaddedd() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    data = preferences.getString(cnst.Session.dataaddedd);
    print("data main");
    print(data);
    print("dataaddedd");
    print(cnst.Session.dataaddedd);
    if (data == null && cnst.Session.dataaddedd == "false") {
      adddata();
    } else {
      return;
    }
  }

  adddata() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Add Details"),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Name",
                    ),
                    controller: name,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Mobile No.",
                    ),
                    keyboardType: TextInputType.number,
                    controller: mobile,
                    validator: (value) {
                      if (value.length != 10) {
                        return "please enter valid mobile number";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Email Id",
                    ),
                    controller: email,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Submit"),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  getUserData();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  getUserData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var parentid = prefs.getString(cnst.Session.ParentId);
      studioId = prefs.getString(cnst.Session.StudioId);
      print("studioid 1");
      print(studioId);
      var fcmtoken = "";
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetUserData(
            parentid, name.text, mobile.text, email.text, studioId, "0");
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          if (data != null && data.length > 0) {
            String value = "true";
            await prefs.setString(cnst.Session.dataaddedd, value);
            print("studioid 2");
            print(cnst.Session.dataaddedd);
          } else {
            setState(() {
              isLoading = false;
              _advertisementData.clear();
            });
          }
        }, onError: (e) {
          showMsg("$e");
          setState(() {
            isLoading = false;
          });
        });
      } else {
        showMsg("No Internet Connection.");
        setState(() {
          isLoading = false;
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
      setState(() {
        isLoading = false;
      });
    }
  }

  showMsg(String msg, {String title = 'Pictik'}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDailyAtTime() async {
    /*var time = Time(10, 0, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'repeatDailyAtTime channel id',
      'repeatDailyAtTime channel name',
      'repeatDailyAtTime description',
      sound: 'slow_spring_board',
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'show daily title',
        //'Daily notification shown at approximately ${_toTwoDigitString(time.hour)}:${_toTwoDigitString(time.minute)}:${_toTwoDigitString(time.second)}',
        'Daily notification shown at approximately ${_toTwoDigitString(time.hour)}:${_toTwoDigitString(time.minute)}:${_toTwoDigitString(time.second)}',
        time,
        platformChannelSpecifics);*/
  }

  String _toTwoDigitString(int value) {
    return value.toString().padLeft(2, '0');
  }

  // final List<Widget> _children = [
  //   CustomerGallery(),
  //   Profile(),
  //   PortfolioScreen(),
  //   Settings(),
  // ];

  List<BarItem> barItems = [
    BarItem(
      text: "Home",
      iconData: Icons.home,
      color: Colors.teal,
    ),

    /* BarItem(
        text: "Notification",
        iconData: Icons.notifications_active,
        color: Colors.deepOrange.shade600),
    BarItem(text: "About Us", iconData: Icons.info, color: Colors.lightGreen),
   */
    BarItem(
      text: "Portfolio",
      iconData: Icons.person,
      color: Colors.yellow.shade900,
    ),
    BarItem(
      text: "Offers",
      iconData: Icons.person,
      color: Colors.yellow.shade900,
    ),
    BarItem(
      text: "Profile",
      iconData: Icons.person,
      color: Colors.yellow.shade900,
    ),
    BarItem(
      text: "Settings",
      iconData: Icons.settings,
      color: Colors.blue,
    ),
  ];

  List<String> titleList = [
    "Studio Name",
    "Portfolio",
    "Offers",
    "Profile",
    "Settings",
  ];

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

  Future<void> onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    await showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: title != null ? Text(title) : null,
        content: body != null ? Text(body) : null,
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              /*await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Dashboard(),
                ),
              );*/
            },
          )
        ],
      ),
    );
  }

  String studioname = "", Username = "", Password = "";
  //send fcm token
  sendFCMTokan(var FcmToken) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      studioname = preferences.getString(cnst.Session.StudioName);
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.SendTokanToServer(FcmToken);
        res.then((data) async {}, onError: (e) {
          print("Error : on Login Call");
        });
      }
    } on SocketException catch (_) {}
  }

  getStudioName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    studioname = preferences.getString(cnst.Session.StudioName);
    Username = preferences.getString(cnst.Session.UserName);
    Password = preferences.getString(cnst.Session.Password);
  }

  // @override
  // void dispose() {
  //   _timer.cancel();
  //   _timer = null;
  //   super.dispose();
  // }

  currentscreen(int index) {
    switch (index) {
      case 0:
        return CustomerGallery();
        break;

      case 1:
        return PortfolioScreen(index: 1);
        break;

      case 2:
        return Offers();
        break;

      case 3:
        return Profile();
        break;

      case 4:
        return Settings();
        break;

      default:
        print("Invalid choice");

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex != 3 && _currentIndex != 2
          ? AppBar(
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
                _currentIndex != 0
                    ? titleList[_currentIndex].toString()
                    : "Opicxo ${"- " + studioname}",
                style: GoogleFonts.aBeeZee(
                  textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
              actions: <Widget>[
                _currentIndex != 4 && _currentIndex != 1
                    ? GestureDetector(
                        onTap: () {
                          Share.share(
                              "Download the opicxo app from below link to get your photos. \n http://tinyurl.com/y2vnvfnb \n Login with the below given details \n Username : ${Username} \n Password : ${Password}");
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 11),
                          child: Icon(
                            Icons.share,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      )
                    : Container(),
              ],
            )
          : null,
      body: currentscreen(_currentIndex),
      bottomNavigationBar: ConvexAppBar(
        // gradient: LinearGradient(
        //     begin: Alignment.topRight,
        //     end: Alignment.bottomLeft,
        //   colors: <Color>[
        //
        //   ],
        // ),
        style: TabStyle.titled,
        backgroundColor: colors[_pos],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          TabItem(
            icon: Icon(
              Icons.home,
              //color: cnst.appPrimaryMaterialColorYellow,
            ),
            title: "Home",
          ),
          TabItem(
            icon: Icon(
              Icons.person,
              //color: cnst.appPrimaryMaterialColorYellow,
            ),
            title: "Portfolio",
          ),
          TabItem(
            icon: Icon(
              Icons.person,
              //color: cnst.appPrimaryMaterialColorYellow,
            ),
            title: "Offers",
          ),
          TabItem(
            icon: Icon(
              Icons.person,
              //color: cnst.appPrimaryMaterialColorYellow,
            ),
            title: "Profile",
          ),
          TabItem(
            icon: Icon(
              Icons.menu,
              //color: cnst.appPrimaryMaterialColorYellow,
            ),
            title: "More",
          ),
        ],
        initialActiveIndex: 0, //optional, default as 0
      ),

      //bottomNavigationBar:
      /*FloatingNavbar(
        selectedBackgroundColor: Colors.transparent,
        fontSize: 12,
        backgroundColor: Colors.transparent,
        unselectedItemColor: Colors.black26,
        selectedItemColor: cnst.appPrimaryMaterialColorYellow,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          //returns tab id which is user tapped
        },
        items: [
          FloatingNavbarItem(icon: Icons.home, title: 'Home'),
          FloatingNavbarItem(icon: Icons.person, title: 'Profile'),
          FloatingNavbarItem(icon: Icons.menu, title: 'More'),
          // FloatingNavbarItem(icon: Icons.settings, title: 'Settings'),
        ],
      ),*/

      //         BottomNavigationBar(
      //       // type: BottomNavigationBarType.fixed,
      //       unselectedItemColor: Colors.black,
      //       showSelectedLabels: true,
      //       //selectedItemColor: cnst.appPrimaryMaterialColorPink,
      //       selectedLabelStyle: TextStyle(
      //           fontWeight: FontWeight.w500,
      //       ),
      //
      //       onTap: (index) {
      //         setState(() {
      //           _currentIndex = index;
      //         });
      //       },
      //       currentIndex: _currentIndex,
      //       selectedFontSize: 15,
      //       iconSize: 28,
      //       items: [
      //         BottomNavigationBarItem(
      //             icon: Icon(
      //               Icons.home,
      //               //color: cnst.appPrimaryMaterialColorYellow,
      //             ),
      //             title: Text(
      //               "Home",
      //               style: GoogleFonts.aBeeZee(
      //                 textStyle: TextStyle(
      //                     fontWeight: FontWeight.w400, color: Colors.black),
      //               ),
      //             )),
      //         BottomNavigationBarItem(
      //             icon: Icon(
      //               Icons.person,
      //               //color: cnst.appPrimaryMaterialColorYellow,
      //             ),
      //             title: Text(
      //               "Profile",
      //               style: GoogleFonts.aBeeZee(
      //                 textStyle: TextStyle(
      //                     fontWeight: FontWeight.w400, color: Colors.black),
      //               ),
      //             )),
      //         BottomNavigationBarItem(
      //             icon: Icon(
      //               Icons.person,
      //               //color: cnst.appPrimaryMaterialColorYellow,
      //             ),
      //             title: Text(
      //               "Portfolio",
      //               style: GoogleFonts.aBeeZee(
      //                 textStyle: TextStyle(
      //                     fontWeight: FontWeight.w400, color: Colors.black),
      //               ),
      //             )),
      //         BottomNavigationBarItem(
      //             icon: Icon(
      //               Icons.menu,
      //               //color: cnst.appPrimaryMaterialColorYellow,
      //             ),
      //             title: Text(
      //               "More",
      //               style: GoogleFonts.aBeeZee(
      //                 textStyle: TextStyle(
      //                     fontWeight: FontWeight.w400, color: Colors.black),
      //               ),
      //             )),
      //       ],
      //       /*barItems: barItems,
      //     animationDuration: Duration(milliseconds: 350),
      //     onBarTab: (index) {
      //       setState(
      //         () {
      //           _currentIndex = index;
      //         },
      //       );
      //     },*/ /**/ /*
      //   ),*/ /*
      // )*/
      //     )
    );
  }
}
