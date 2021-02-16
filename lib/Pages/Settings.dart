import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:opicxo/Common/Constants.dart' as cnst;
import 'package:google_fonts/google_fonts.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isSwitched = false;
  ProgressDialog pr;
  List soundData = [];

  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
    _getLocal();
  }

  _getLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getString(cnst.Session.PlayMusic) == "true") {
        isSwitched = true;
      } else {
        isSwitched = false;
      }
    });
  }

  _showSpeedDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SlideShow();
      },
    );
  }

  _changePlayMusic(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(cnst.Session.PlayMusic, value.toString());
    setState(() {
      isSwitched = value;
    });
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

  DateTime currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press Back Again to Exit");
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          Container(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                "images/back009.png",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.fill,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          _showSpeedDialog();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: Text("SlideShow Speed",
                                  style: GoogleFonts.aBeeZee(
                                      textStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black))),
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 30,
                            ),
                          ],
                        ),
                      ),
                      /*    Divider(
                        thickness: 1.5,
                      ),
                      InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(13.0),
                                child: Text("Play Music",
                                    style: GoogleFonts.aBeeZee(
                                        textStyle: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black))),
                              ),
                            ),
                            Switch(
                              value: isSwitched,
                              onChanged: (value) {
                                _changePlayMusic(value);
                              },
                              activeTrackColor:
                                  cnst.appPrimaryMaterialColorPink[500],
                              activeColor: cnst.appPrimaryMaterialColorPink,
                            ),
                          ],
                        ),
                      ),
                      Divider(thickness: 1.5),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/SelectSound');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: Text("Select Music",
                                  style: GoogleFonts.aBeeZee(
                                      textStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black))),
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 30,
                            ),
                          ],
                        ),
                      ),*/
                      /*   Divider(thickness: 1.5),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/ReferAndEarn');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: Text(
                                "Refer & Earn",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 30,
                            ),
                          ],
                        ),
                      ),*/
                      Divider(thickness: 1.5),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/CustomerAboutUs');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: Text("About Us",
                                  style: GoogleFonts.aBeeZee(
                                      textStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black))),
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 30,
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1.5,
                      ),
                      InkWell(
                        onTap: () {
                          confirmation("Are you sure you want to Logout?");
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: Text("Log Out",
                                  style: GoogleFonts.aBeeZee(
                                      textStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black))),
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 30,
                            ),
                          ],
                        ),
                      ),
                      Divider(thickness: 1.5)
                    ],
                  ),
                ),
              ],
            ),

            /*     Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _showSpeedDialog();
                },
                child: ListTile(
                  title: Text("Speed"),
                  subtitle: Text("SlideShow Speed(s)"),
                ),
              ),
              Divider(
                thickness: 2,
              ),
              ListTile(
                title: Text("Play Music"),
                trailing: Switch(
                  value: isSwitched,
                  onChanged: (value) {
                    _changePlayMusic(value);
                  },
                  activeTrackColor: cnst.appPrimaryMaterialColorPink[500],
                  activeColor: cnst.appPrimaryMaterialColorPink,
                ),
              ),
              Divider(
                thickness: 2,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/SelectSound');
                },
                child: ListTile(
                  title: Text("Select Music"),
                ),
              ),
              Divider(
                thickness: 2,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/ReferAndEarn");
                },
                child: ListTile(
                  title: Text(
                    "Refer & Earn",
                  ),
                ),
              ),
              Divider(
                thickness: 2,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/CustomerAboutUs");
                },
                child: ListTile(
                  title: Text(
                    "About Us",
                  ),
                ),
              ),
              Divider(
                thickness: 2,
              ),
              GestureDetector(
                onTap: () {
                  confirmation("Are you sure you want to Logout?");
                },
                child: ListTile(
                  title: Text(
                    "Log Out",
                  ),
                ),
              ),
              Divider(
                thickness: 2,
              ),
            ],
        ),*/
          ),
        ],
      )),
    );
  }
}

class SlideShow extends StatefulWidget {
  @override
  _SlideShowState createState() => _SlideShowState();
}

class _SlideShowState extends State<SlideShow> {
  double _value;

  @override
  void initState() {
    getLocal();
  }

  getLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      if (prefs.getString(cnst.Session.SlideShowSpeed) == "" ||
          prefs.getString(cnst.Session.SlideShowSpeed) == null) {
        _value = 1.5;
      } else {
        _value = double.parse(prefs.getString(cnst.Session.SlideShowSpeed));
      }
    });
  }

  setSlideShowTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //String CustomerId = prefs.getString(Session.CustomerId);
    prefs.setString(cnst.Session.SlideShowSpeed, _value.toString());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Slide Show Speed"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Slider(
            value: _value,
            min: 0.5,
            max: 5.0,
            divisions: 9,
            label: 'Slide Show Speed',
            onChanged: (double newValue) {
              setState(() {
                _value = newValue;
                print("selected value: ${_value}");
              });
            },
          ),
          Text("${_value} Seconds")
        ],
      ),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        FlatButton(
          child: Text("Close",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w600)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text("Ok",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w600)),
          onPressed: () {
            setSlideShowTime();
          },
        ),
      ],
    );
  }
}
