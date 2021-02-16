import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:opicxo/Common/Constants.dart';
import 'package:opicxo/Common/Services.dart';
import 'package:opicxo/Components/LoadinComponent.dart';
import 'package:opicxo/Screen/Dashboard.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:opicxo/Common/Constants.dart' as cnst;
import 'package:shared_preferences/shared_preferences.dart';

class OTPVerification extends StatefulWidget {

  String mobileno;
  String studioid;
  OTPVerification({this.mobileno,this.studioid});
  @override
  _OTPVerificationState createState() => _OTPVerificationState();

}

class _OTPVerificationState extends State<OTPVerification> {

  TextEditingController edtMobile = new TextEditingController();
  TextEditingController controller = TextEditingController();

  var isLoading = false;
  int otpCode;

  String memberId = "", memberMobile = "", memberType = "";

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
    // TODO: implement initState
    super.initState();
    getLocalData();
    sendOtp();
  }

  getLocalData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String CustId = await preferences.getString(Session.CustomerId).toString();
    String CustType = await preferences.getString(Session.Type);
    //String CustEmail = preferences.getString(Session.Email);
    String CustMobile = preferences.getString(Session.Mobile);

    setState(() {
      memberId = CustId == null ? widget.studioid : CustId;
      memberMobile = CustMobile == null ? widget.mobileno : CustMobile;
      memberType = CustType;
    });
  }

  showInternetMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
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

  sendOtp() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var rng = await new Random();
        int code = await rng.nextInt(9999 - 1000) + 1000;
        setState(() {
          isLoading = true;
        });
        Future res = Services.sendOtpCode(memberMobile, code.toString());
        res.then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data.toString() == "1") {
            setState(() {
              otpCode = code;
            });
            Fluttertoast.showToast(
                msg: "Otp Send ${data.Message}",
                backgroundColor: cnst.appPrimaryMaterialColorYellow,
                gravity: ToastGravity.TOP,
                toastLength: Toast.LENGTH_SHORT);
          } else {
            Fluttertoast.showToast(
                msg: "Try Again ${data.Message}",
                backgroundColor: cnst.appPrimaryMaterialColorYellow,
                gravity: ToastGravity.TOP,
                toastLength: Toast.LENGTH_SHORT);
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          print("Error : on Login Call");
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(
              msg: "$e",
              backgroundColor: cnst.appPrimaryMaterialColorYellow,
              gravity: ToastGravity.TOP,
              toastLength: Toast.LENGTH_SHORT);
        });
      }
    } on SocketException catch (_) {
      showInternetMsg("No Internet Connection.");
    }
  }

  sendOtpResend() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var rng = await new Random();
        int code = await rng.nextInt(9999 - 1000) + 1000;
        /*setState(() {
           isLoading = true;
         });*/
        pr.show();
        Future res = Services.sendOtpCode(memberMobile, code.toString());
        res.then((data) async {
          /*setState(() {
            isLoading = false;
          });*/
          pr.hide();
          if (data.Data.toString() == "1") {
            setState(() {
              otpCode = code;
            });
            Fluttertoast.showToast(
                msg: "Otp Send ${data.Message}",
                backgroundColor: cnst.appPrimaryMaterialColorYellow,
                gravity: ToastGravity.TOP,
                toastLength: Toast.LENGTH_SHORT);
          } else {
            Fluttertoast.showToast(
                msg: "Try Again ${data.Message}",
                backgroundColor: cnst.appPrimaryMaterialColorYellow,
                gravity: ToastGravity.TOP,
                toastLength: Toast.LENGTH_SHORT);
            /*setState(() {
              isLoading = false;
            });*/
            pr.hide();
          }
        }, onError: (e) {
          print("Error : on Login Call");
          /*setState(() {
            isLoading = false;
          });*/
          pr.hide();
          Fluttertoast.showToast(
              backgroundColor: cnst.appPrimaryMaterialColorYellow,
              msg: "$e",
              gravity: ToastGravity.TOP,
              toastLength: Toast.LENGTH_SHORT);
        });
      }
    } on SocketException catch (_) {
      showInternetMsg("No Internet Connection.");
    }
  }

  VerificationStatusUpdate() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        Future res = Services.CodeVerification(widget.studioid);
        res.then((data) async {
          pr.hide();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (data.Data == "1") {
            await prefs.setString(Session.IsVerified, "true");
            if (memberType.toString() == "Guest") {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/GuestDashboard', (Route<dynamic> route) => false);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Dashboard(
                      mobile : widget.mobileno,
                      id : widget.studioid,
                  index:1,
                  ),
                ),
              );
              // Navigator.of(context).pushNamedAndRemoveUntil(
              //     '/Dashboard', (Route<dynamic> route) => false);
            }
          } else {
            Fluttertoast.showToast(
                msg: "Try Again ${data.Message}",
                backgroundColor: cnst.appPrimaryMaterialColorYellow,
                gravity: ToastGravity.TOP,
                toastLength: Toast.LENGTH_SHORT);
            /*setState(() {
              isLoading = false;
            });*/
          }
        }, onError: (e) {
          print("Error : on Login Call");
          pr.hide();
          Fluttertoast.showToast(
              msg: "$e",
              backgroundColor: cnst.appPrimaryMaterialColorYellow,
              gravity: ToastGravity.TOP,
              toastLength: Toast.LENGTH_SHORT);
        });
      }
    } on SocketException catch (_) {
      showInternetMsg("No Internet Connection.");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacementNamed(context, '/Login');
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.9,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            cnst.appPrimaryMaterialColorYellow,
                            cnst.appPrimaryMaterialColorPink
                          ])),
                  //color: cnst.appPrimaryMaterialColorPink,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Verify Your Account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(top: 5, left: 20, right: 20),
                        child: Text(
                          //"OTP has been sent to you on ${memberMobile}. Please enter it below",
                          "OTP has been sent to you on ${memberMobile}. Please enter it below",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      //side: BorderSide(color: cnst.appcolor)),
                      side: BorderSide(width: 0.50, color: Colors.grey[500]),
                      borderRadius: BorderRadius.circular(
                        10.0,
                      ),
                    ),
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2.65,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      //color: Colors.red,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          PinCodeTextField(
                            autofocus: false,
                            controller: controller,
                            highlight: true,
                            pinBoxHeight: 60,
                            pinBoxWidth: 60,
                            wrapAlignment: WrapAlignment.center,
                            highlightColor: cnst.appPrimaryMaterialColorYellow,
                            defaultBorderColor: Colors.grey,
                            hasTextBorderColor:
                            cnst.appPrimaryMaterialColorPink,
                            maxLength: 4,
                            pinBoxDecoration: ProvidedPinBoxDecoration
                                .defaultPinBoxDecoration,
                            pinTextStyle: TextStyle(fontSize: 20.0),
                            pinTextAnimatedSwitcherTransition:
                            ProvidedPinBoxTextAnimation.scalingTransition,
                            pinTextAnimatedSwitcherDuration:
                            Duration(milliseconds: 200),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 30),
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  new BorderRadius.circular(30.0)),
                              //color: Colors.red,
                              color: cnst.appPrimaryMaterialColorPink[700],
                              minWidth: MediaQuery.of(context).size.width - 20,
                              onPressed: () {
                                if (controller.text != "") {
                                  if (otpCode.toString() == controller.text) {
                                    VerificationStatusUpdate();
                                  } else {
                                    Fluttertoast.showToast(
                                        backgroundColor:
                                        cnst.appPrimaryMaterialColorYellow,
                                        msg: "Enter Valid Code",
                                        gravity: ToastGravity.TOP,
                                        toastLength: Toast.LENGTH_SHORT);
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Enter Code",
                                      backgroundColor:
                                      cnst.appPrimaryMaterialColorYellow,
                                      gravity: ToastGravity.TOP,
                                      toastLength: Toast.LENGTH_SHORT);
                                }
                                //Navigator.pushReplacementNamed(context, '/Dashboard');
                              },
                              child: Text(
                                "VERIFY",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                  ),
                                  Text(
                                    "Didn't Receive the Verification Code ?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      /*if (!isLoading) {

                                      }*/
                                      sendOtpResend();
                                    },
                                    child: Text(
                                      'RESEND CODE',
                                      maxLines: 2,
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color:
                                          cnst.appPrimaryMaterialColorPink),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: isLoading ? LoadinComponent() : Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
