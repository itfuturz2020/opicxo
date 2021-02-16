import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:opicxo/Common/Constants.dart';
import 'package:opicxo/Common/Services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:opicxo/Common/Constants.dart' as cnst;
import 'package:shared_preferences/shared_preferences.dart';

import 'Login.dart';

class SignUpGuest extends StatefulWidget {
  @override
  _SignUpGuestState createState() => _SignUpGuestState();
}

class _SignUpGuestState extends State<SignUpGuest> {
  TextEditingController edtName = new TextEditingController();
  TextEditingController edtMobileNo = new TextEditingController();
  TextEditingController edtEmail = new TextEditingController();
  TextEditingController edtPassword = new TextEditingController();
  TextEditingController confirmPassword = new TextEditingController();
  List _selectedContact = [];

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

  _addCustomer() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        _selectedContact.clear();
        _selectedContact.add({
          "Id": 0,
          "password" : edtPassword.text,
          "Name": edtName.text,
          "Mobile": edtMobileNo.text,
          "Email": edtEmail.text,
          "StudioId": cnst.Studio_Id.toString(),
          "Type": "Guest",
          "ParentId" : 0,
        });

        Services.GuestSignUp(_selectedContact).then((data) async {
          pr.hide();
          if (data.Data == "1") {
            prefs.setString(Session.Name, edtName.text);
            prefs.setString(Session.Password, edtPassword.text);
            prefs.setString(Session.Mobile, edtMobileNo.text);
            Fluttertoast.showToast(
                msg: "Registered Successfully",
                backgroundColor: cnst.appPrimaryMaterialColorYellow,
                textColor: Colors.white,
                gravity: ToastGravity.TOP,
                toastLength: Toast.LENGTH_SHORT);
            Navigator.push(context, MaterialPageRoute(builder: (context) => Login(username : edtName.text,password:edtPassword.text)));
            // Navigator.of(context).pushNamedAndRemoveUntil(
            //     '/Login', (Route<dynamic> route) => false);
          } else {
            showMsg(data.Message);
          }
        }, onError: (e) {
          pr.hide();
          showMsg("Try Again.");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Error"),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(
                  "images/back010.png",
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 0, bottom: 30),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ClipRRect(
                          borderRadius: new BorderRadius.circular(15.0),
                          child: Image.asset(
                            'images/logo1.png',
                            fit: BoxFit.fill,
                            width: 150,
                            height: 50,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          height: 50,
                          child: TextFormField(
                            controller: edtName,
                            scrollPadding: EdgeInsets.all(0),
                            decoration: InputDecoration(
                                labelText: "Enter Name",
                                border: new OutlineInputBorder(
                                    borderSide: new BorderSide(
                                        color:
                                            cnst.appPrimaryMaterialColorPink),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  color: cnst.appPrimaryMaterialColorPink,
                                ),
                                counterText: "",
                                hintText: "Name",
                                hintStyle: TextStyle(fontSize: 15)),
                            keyboardType: TextInputType.text,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            height: 50,
                            child: TextFormField(
                              controller: edtMobileNo,
                              scrollPadding: EdgeInsets.all(0),
                              decoration: InputDecoration(
                                  labelText: "Enter Mobile No",
                                  border: new OutlineInputBorder(
                                      borderSide: new BorderSide(
                                          color:
                                              cnst.appPrimaryMaterialColorPink),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  prefixIcon: Icon(
                                    Icons.phone_android,
                                    color: cnst.appPrimaryMaterialColorPink,
                                  ),
                                  counterText: "",
                                  hintText: "Mobile Number",
                                  hintStyle: TextStyle(fontSize: 15)),
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            height: 50,
                            child: TextFormField(
                              controller: edtEmail,
                              scrollPadding: EdgeInsets.all(0),
                              decoration: InputDecoration(
                                  labelText: "Enter Email",
                                  border: new OutlineInputBorder(
                                      borderSide: new BorderSide(
                                          color:
                                              cnst.appPrimaryMaterialColorPink),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  prefixIcon: Icon(
                                    Icons.mail_outline,
                                    color: cnst.appPrimaryMaterialColorPink,
                                  ),
                                  counterText: "",
                                  hintText: "Email",
                                  hintStyle: TextStyle(fontSize: 15)),
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            height: 50,
                            child: TextFormField(
                              controller: edtPassword,
                              obscureText: !_showPassword,
                              scrollPadding: EdgeInsets.all(0),
                              decoration: InputDecoration(
                                  labelText: "Enter  Password",
                                  border: new OutlineInputBorder(
                                      borderSide: new BorderSide(
                                          color:
                                          cnst.appPrimaryMaterialColorPink),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  // prefixIcon: Icon(
                                  //   Icons.,
                                  //   color: cnst.appPrimaryMaterialColorPink,
                                  // ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.remove_red_eye,
                                      color: this._showPassword ? Colors.blue : Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() => this._showPassword = !this._showPassword);
                                    },
                                  ),
                                  counterText: "",
                                  hintText: "Password",
                                  hintStyle: TextStyle(fontSize: 15)),
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            height: 50,
                            child: TextFormField(
                              obscureText: !_showPassword,
                              controller: confirmPassword,
                              scrollPadding: EdgeInsets.all(0),
                              decoration: InputDecoration(
                                  labelText: "Confirm Password",
                                  border: new OutlineInputBorder(
                                      borderSide: new BorderSide(
                                          color:
                                          cnst.appPrimaryMaterialColorPink),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  // prefixIcon: Icon(
                                  //   Icons.,
                                  //   color: cnst.appPrimaryMaterialColorPink,
                                  // ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.remove_red_eye,
                                      color: this._showPassword ? Colors.blue : Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() => this._showPassword = !this._showPassword);
                                    },
                                  ),
                                  counterText: "",
                                  hintText: "Confirm Password",
                                  hintStyle: TextStyle(fontSize: 15)),
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        /*Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          height: 50,
                          child: TextFormField(
                           // controller: edtEmail,
                            scrollPadding: EdgeInsets.all(0),
                            decoration: InputDecoration(
                                labelText: "Enter referral code",
                                border: new OutlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: cnst.appPrimaryMaterialColorPink),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                                prefixIcon: Icon(
                                  Icons.people_outline,
                                  color: cnst.appPrimaryMaterialColorPink,
                                ),
                                counterText: "",
                                hintText: "referral code",
                                hintStyle: TextStyle(fontSize: 15)),
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),*/
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          width: MediaQuery.of(context).size.width,
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    cnst.appPrimaryMaterialColorYellow,
                                    cnst.appPrimaryMaterialColorPink
                                  ])),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(9.0)),
                            onPressed: () {
                              if (edtName.text != "" && edtName.text != null) {
                                if (edtMobileNo.text != "" &&
                                    edtMobileNo.text != null) {
                                  if (edtPassword.text != null &&
                                      edtPassword.text != "" &&
                                      confirmPassword.text != null &&
                                      confirmPassword.text != "") {
                                    if (edtPassword.text == confirmPassword.text) {
                                      if (edtMobileNo.text.length == 10) {
                                        if (edtEmail.text != "") {
                                          _addCustomer();
                                        }
                                        else {
                                          showMsg("Enter Customer Email");
                                        }
                                      } else {
                                        showMsg(
                                            "Enter Customer Valid Mobile Number");
                                      }
                                    }
                                    else {
                                      showMsg("Both password should match");
                                    }
                                  } else {
                                    showMsg("Enter Your Password");
                                  }
                                }
                                else{
                                  showMsg("Enter Customer Mobile Number");
                                }
                              }
                              else{
                                showMsg("Enter Customer Name");
                              }
                            },
                            child: Text(
                              "SIGN UP",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Already Register ?',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'SIGN IN',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: cnst.appPrimaryMaterialColorYellow),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
