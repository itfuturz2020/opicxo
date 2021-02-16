import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:opicxo/Screen/Dashboard.dart';
import 'package:opicxo/Screen/OTPVerification.dart';
import '../Common/Constants.dart' as cnst;
import '../Common/Services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginWithMobile extends StatefulWidget {
  @override
  _LoginWithMobileState createState() => _LoginWithMobileState();
}

class _LoginWithMobileState extends State<LoginWithMobile> {
  TextEditingController txtMobile = new TextEditingController();
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

  _photographerLogin() async {
    if (txtMobile.text != "") {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          pr.show();
          Future res = Services.MemberLogin(txtMobile.text);
          res.then((data) async {
            pr.hide();
            print("data");
            print(data);
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
              await prefs.setString(
                  cnst.Session.StudioMobile, data[0]["studio"]["MobileNo"]);
              await prefs.setString(cnst.Session.Mobile, data[0]["Mobile"]);
              await prefs.setString(
                  cnst.Session.StudioName, data[0]["studio"]["Name"]);
              await prefs.setString(cnst.Session.Email, data[0]["Email"]);
              await prefs.setString(cnst.Session.Password, data[0]["Password"]);
              await prefs.setString(cnst.Session.UserName, data[0]["UserName"]);
              await prefs.setString(
                  cnst.Session.IsVerified, data[0]["IsVerified"].toString());

              //print("login:${prefs.getString(cnst.Session.AlbumId)}");
              // if (data[0]["IsVerified"].toString() == "true" &&
              //     data[0]["IsVerified"] != null) {
              print("cnst.Session.Mobile");
              print(data[0]["UserName"]);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Dashboard(
                            name: data[0]["studio"]["Name"],
                            loginWithMobile: true,
                          )));
              // Navigator.pushNamedAndRemoveUntil(
              //     context, "/Dashboard", (Route<dynamic> route) => false);
              // } else {
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => OTPVerification(
              //               mobileno: txtMobile.text,
              //               studioid: data[0]["studio"]["Id"].toString())));
              //   // Navigator.pushNamedAndRemoveUntil(context, "/OTPVerification",
              //   //         (Route<dynamic> route) => false);
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
    } else {
      Fluttertoast.showToast(
          msg: "Please Enter Registerd Mobile Number",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          gravity: ToastGravity.TOP);
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
                  Column(
                    children: <Widget>[
                      Container(
                        height: 50,
                        child: TextFormField(
                          controller: txtMobile,
                          scrollPadding: EdgeInsets.all(0),
                          decoration: InputDecoration(
                              labelText: "Mobile No",
                              labelStyle: (TextStyle(color: Colors.black)),
                              border: new OutlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: cnst.appPrimaryMaterialColorPink),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              prefixIcon: Icon(
                                Icons.phone_android,
                                color: cnst.appPrimaryMaterialColorPink,
                              ),
                              counterText: "",
                              hintText: "Enter Mobile No",
                              hintStyle:
                                  TextStyle(fontSize: 15, color: Colors.black)),
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 25),
                        width: MediaQuery.of(context).size.width,
                        height: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: cnst.appPrimaryMaterialColorPink),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(9.0)),
                          onPressed: () {
                            _photographerLogin();
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
        ],
      ),
    );
  }
}
