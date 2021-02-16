import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opicxo/Common/Constants.dart' as cnst;
import 'package:opicxo/Common/Constants.dart';
import 'package:opicxo/Common/Services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoginWithMobile.dart';
import 'LoginWithUsername.dart';

class Login extends StatefulWidget {
  String username, password;
  Login({this.password, this.username});
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController edtMobile = new TextEditingController();

  ProgressDialog pr;

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
    //pr.setMessage('Please Wait');
    // TODO: implement initState
    super.initState();
  }

  checkLogin() async {
    if (edtMobile.text != "" && edtMobile.text != null) {
      if (edtMobile.text.length == 10) {
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            /* setState(() {
              isLoading = true;
            });
           */
            pr.show();
            Future res = Services.MemberLogin(edtMobile.text);
            res.then((data) async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              if (data != null && data.length > 0) {
                pr.hide();
                await prefs.setString(
                    Session.CustomerId, data[0]["Id"].toString());
                await prefs.setString(
                    Session.ParentId, data[0]["ParentId"].toString());

                await prefs.setString(Session.Name, data[0]["Name"].toString());
                await prefs.setString(
                    Session.Mobile, data[0]["Mobile"].toString());
                await prefs.setString(
                    Session.Email, data[0]["Email"].toString());
                await prefs.setString(
                    Session.Image, data[0]["Image"].toString());
                await prefs.setString(
                    Session.GalleryId, data[0]["GalleryId"].toString());
                await prefs.setString(
                    Session.StudioId, data[0]["StudioId"].toString());

                await prefs.setString(
                    Session.IsVerified, data[0]["IsVerified"].toString());

                await prefs.setString(Session.Type, data[0]["Type"].toString());
                await prefs.setString(Session.PinSelection, "false");

                if (data[0]["IsVerified"].toString() == "true") {
                  if (data[0]["Type"].toString() == "Guest") {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/GuestDashboard', (Route<dynamic> route) => false);
                  } else {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/Dashboard', (Route<dynamic> route) => false);
                  }
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/OTPVerification', (Route<dynamic> route) => false);
                }
              } else {
                pr.hide();
                showMsg("Invalid login Detail.");
              }
            }, onError: (e) {
              pr.hide();

              print("Error : on Login Call $e");
              showMsg("$e");
            });
          } else {
            pr.hide();
            showMsg("No Internet Connection.");
          }
        } on SocketException catch (_) {
          showMsg("No Internet Connection.");
        }
      } else {
        showMsg("Please Enter Valid Mobile No.");
      }
    } else {
      showMsg("Please Enter Mobile No.");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                "images/intro5.jpeg",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.fill,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              //color: Colors.black.withOpacity(0.6),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Image.asset(
                        'images/logo1.png',
                        fit: BoxFit.fill,
                        width: 200,
                        height: 70,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 25),
                          width: MediaQuery.of(context).size.width,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: cnst.appPrimaryMaterialColorPink,
                          ),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(9.0)),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return LoginWithMobile();
                              }));
                            },
                            child: Text(
                              "Login with Mobile",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 25),
                          width: MediaQuery.of(context).size.width,
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: cnst.appPrimaryMaterialColorPink),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(9.0)),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return LoginWithUsername();
                              }));
                            },
                            child: Text(
                              "Login with Username",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        // Padding(
                        //   padding: const EdgeInsets.only(bottom: 10),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: <Widget>[
                        //       Container(
                        //         width: MediaQuery
                        //             .of(context)
                        //             .size
                        //             .width / 3,
                        //         child: Divider(
                        //           thickness: 2,
                        //         ),
                        //       ),
                        //       Container(
                        //         width: MediaQuery
                        //             .of(context)
                        //             .size
                        //             .width / 3,
                        //         child: Divider(
                        //           thickness: 2,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // GestureDetector(
                        //   onTap: () {
                        //     Navigator.pushNamed(context, '/Registration');
                        //   },
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(4.0),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: <Widget>[
                        //         Text(
                        //           'Don\'t have an account ?',
                        //           style: TextStyle(
                        //               fontSize: 14,
                        //               fontWeight: FontWeight.w600,
                        //               color: Colors.black),
                        //         ),
                        //         Padding(
                        //           padding: const EdgeInsets.only(left: 5),
                        //           child: Text(
                        //             'SIGN UP',
                        //             style: TextStyle(
                        //                 fontSize: 14,
                        //                 fontWeight: FontWeight.w600,
                        //                 color:
                        //                 cnst.appPrimaryMaterialColorYellow),
                        //           ),
                        //         ),
                        //
                        //         ShaderMask(
                        //           shaderCallback: (bounds) => RadialGradient(
                        //               center: Alignment.topLeft,
                        //               colors: [
                        //                 cnst.appPrimaryMaterialColorYellow[
                        //                 800],
                        //                 cnst.appPrimaryMaterialColorPink[
                        //                 800]
                        //               ],
                        //               tileMode: TileMode.mirror)
                        //               .createShader(bounds),
                        //           // child: Text(
                        //           //   'SIGN UP',
                        //           //   style: TextStyle(
                        //           //       fontSize: 15,
                        //           //       fontWeight: FontWeight.w600,
                        //           //       ),
                        //           // ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 5.0),
                        //   child: GestureDetector(
                        //     onTap: () {
                        //       Navigator.pushNamed(context, "/TermsandConditions");
                        //     },
                        //     child: Text(
                        //       "Terms & Conditions",
                        //       style: TextStyle(
                        //           fontWeight: FontWeight.w600, fontSize: 16),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width / 3,
                                child: Divider(
                                  thickness: 2,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 3,
                                child: Divider(
                                  thickness: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/SignUpGuest');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Don\'t have an account ?',
                                  style: GoogleFonts.aBeeZee(
                                    textStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    'SIGN UP',
                                    style: GoogleFonts.aBeeZee(
                                      textStyle: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: cnst
                                              .appPrimaryMaterialColorYellow),
                                    ),
                                  ),
                                ),
                                /*ShaderMask(
                                  shaderCallback: (bounds) => RadialGradient(
                                          center: Alignment.topLeft,
                                          colors: [
                                            cnst.appPrimaryMaterialColorYellow[
                                                800],
                                            cnst.appPrimaryMaterialColorPink[
                                                800]
                                          ],
                                          tileMode: TileMode.mirror)
                                      .createShader(bounds),
                                  child: Text(
                                    'SIGN UP',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),*/
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
