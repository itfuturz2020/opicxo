import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Common/Constants.dart' as cnst;
import '../Common/Services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import 'Dashboard.dart';
import 'OTPVerification.dart';

class LoginWithUsername extends StatefulWidget {
  @override
  _LoginWithUsernameState createState() => _LoginWithUsernameState();
}

class _LoginWithUsernameState extends State<LoginWithUsername> {
  TextEditingController txtMobile = new TextEditingController();
  TextEditingController txtUsername = new TextEditingController();
  TextEditingController txtPassword = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();

  ProgressDialog pr;

  @override
  void initState() {
    super.initState();
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

  _photographerLogin() async {
    if (txtUsername != "" && txtPassword != "") {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          pr.show();
          Future res = Services.userloginwithusername(
              txtUsername.text, txtPassword.text);
          res.then((data) async {
            pr.hide();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            if (data != null && data.length > 0) {
              await prefs.setString(
                  cnst.Session.CustomerId, data[0]["Id"].toString());
              await prefs.setString(
                  cnst.Session.StudioId, data[0]["studio"]["Id"].toString());
              await prefs.setString(cnst.Session.StudioName,
                  data[0]["studio"]["Name"].toString());
              await prefs.setString(cnst.Session.StudioMobile,
                  data[0]["studio"]["MobileNo"].toString());
              await prefs.setString(cnst.Session.StudioEmail,
                  data[0]["studio"]["Email"].toString());
              await prefs.setString(cnst.Session.StudioLogo,
                  data[0]["studio"]["StudioLogo"].toString());

              await prefs.setString(
                  cnst.Session.ParentId, data[0]["ParentId"].toString());
              await prefs.setString(
                  cnst.Session.Image, data[0]["StudioLogo"].toString());
              await prefs.setString(
                  cnst.Session.BranchId, data[0]["BranchId"].toString());
              await prefs.setString(cnst.Session.Name, data[0]["Name"]);

              await prefs.setString(cnst.Session.Mobile, data[0]["Mobile"]);
              await prefs.setString(
                  cnst.Session.StudioMobile, data[0]["studio"]["MobileNo"]);
              await prefs.setString(cnst.Session.Email, data[0]["UserName"]);
              await prefs.setString(
                  cnst.Session.StudioName, data[0]["studio"]["Name"]);
              await prefs.setString(cnst.Session.Password, data[0]["Password"]);
              await prefs.setString(cnst.Session.UserName, data[0]["UserName"]);
              await prefs.setString(
                  cnst.Session.IsVerified, data[0]["IsVerified"].toString());

              // if (data[0]["IsVerified"].toString() == "true" &&
              //     data[0]["IsVerified"] != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Dashboard(
                            name: data[0]["studio"]["Name"],
                            index: 2,
                            loginWithMobile: false,
                          )));
              // }
              // else {
              //   //Navigator.pushNamedAndRemoveUntil(context, "/OTPVerification",
              //   Navigator.push(context, MaterialPageRoute(builder: (context) => OTPVerification(
              //       mobileno : txtMobile.text,
              //       studioid:data[0]["Id"].toString(),
              //   ),
              //   ),
              //   );
              //   //(Route<dynamic> route) => false);
              // }
            } else {
              showMsg("Invalid login Detail");
            }
          }, onError: (e) {
            setState(() {
              pr.hide();
            });

            print("Error : on Login Call $e");
            showMsg("$e");
          });
        }
      } on SocketException catch (_) {
        showMsg("No Internet Connection.");
      }
    }
  }

//   void _validateInputs() {
//     if (_formKey.currentState.validate()) {
//       _formKey.currentState.save();
//       _photographerLogin();
//     } else {
// //    If all data are not valid then start auto validation.
//       setState(() {
//         _autoValidate = true;
//       });
//     }
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Container(
          //   child: Opacity(
          //     opacity: 0.2,
          //     child: Image.asset(
          //       "images/1.png",
          //       width: MediaQuery
          //           .of(context)
          //           .size
          //           .width,
          //       height: MediaQuery
          //           .of(context)
          //           .size
          //           .height,
          //       fit: BoxFit.fill,
          //     ),
          //   ),
          // ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            //color: Colors.black.withOpacity(0.6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Form(
                key: _formKey,
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
                    Form(
                      key: _formKey1,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 50,
                              child: TextFormField(
                                validator: (value) {
                                  if (value.trim() == "")
                                    return 'Please Enter your username';
                                  else
                                    return null;
                                },
                                controller: txtUsername,
                                scrollPadding: EdgeInsets.all(0),
                                decoration: InputDecoration(
                                    labelText: "Username",
                                    labelStyle:
                                        (TextStyle(color: Colors.black)),
                                    border: new OutlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: cnst
                                                .appPrimaryMaterialColorPink),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    prefixIcon: Icon(
                                      Icons.phone_android,
                                      color: cnst.appPrimaryMaterialColorPink,
                                    ),
                                    hintStyle: TextStyle(
                                        fontSize: 15, color: Colors.black)),
                                keyboardType: TextInputType.text,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 50,
                              child: TextFormField(
                                controller: txtPassword,
                                scrollPadding: EdgeInsets.all(0),
                                decoration: InputDecoration(
                                    labelText: "Password",
                                    labelStyle:
                                        (TextStyle(color: Colors.black)),
                                    border: new OutlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: cnst
                                                .appPrimaryMaterialColorPink),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    prefixIcon: Icon(
                                      Icons.phone_android,
                                      color: cnst.appPrimaryMaterialColorPink,
                                    ),
                                    hintStyle: TextStyle(
                                        fontSize: 15, color: Colors.black)),
                                keyboardType: TextInputType.text,
                                style: TextStyle(color: Colors.black),
                                obscureText: true,
                                validator: (value) {
                                  if (value.trim() == "")
                                    return 'Please enter your password';
                                  return null;
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            // child: Container(
                            //    height: 50,
                            //    child: TextFormField(
                            //      controller: txtMobile,
                            //      scrollPadding: EdgeInsets.all(0),
                            //      decoration: InputDecoration(
                            //          labelText: "Mobile No",
                            //          labelStyle: (TextStyle(color: Colors.black)),
                            //          border: new OutlineInputBorder(
                            //              borderSide: new BorderSide(
                            //                  color: cnst.appPrimaryMaterialColorPink),
                            //              borderRadius:
                            //              BorderRadius.all(Radius.circular(10))),
                            //          prefixIcon: Icon(
                            //            Icons.phone_android,
                            //            color: cnst.appPrimaryMaterialColorPink,
                            //          ),
                            //          counterText: "",
                            //          hintStyle:
                            //          TextStyle(fontSize: 15, color: Colors.black)),
                            //      keyboardType: TextInputType.number,
                            //      maxLength: 10,
                            //      style: TextStyle(color: Colors.black),
                            //      validator: (value) {
                            //        if (value.trim() == "" ||
                            //            value.length < 10) {
                            //          return 'Please enter 10 characters';
                            //        }
                            //        return null;
                            //      },
                            //    ),
                            //  ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 1),
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
                                bool isvalidate = true;
                                setState(() {
                                  if (txtUsername == null &&
                                      txtPassword == null) {
                                    isvalidate = false;
                                  }
                                });
                                if (_formKey1.currentState.validate()) {
                                  if (isvalidate) {
                                    _photographerLogin();
                                  }
                                }
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
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
