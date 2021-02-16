import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:opicxo/Common/Constants.dart';
import 'package:opicxo/Common/Constants.dart' as cnst;
import 'package:opicxo/Common/Services.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:opicxo/Components/LoadinComponent.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCustomer extends StatefulWidget {
  @override
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  TextEditingController txtName = new TextEditingController();
  TextEditingController txtMobile = new TextEditingController();
  PermissionStatus _permissionStatus = PermissionStatus.unknown;
  bool _isLoading = false;
  List _selectedContact = [];
  String memberId = "";
  String parentId = "";

  ProgressDialog pr;

  Future<void> requestPermission(PermissionGroup permission) async {
    final List<PermissionGroup> permissions = <PermissionGroup>[permission];
    final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
        await PermissionHandler().requestPermissions(permissions);

    setState(() {
      print(permissionRequestResult);
      _permissionStatus = permissionRequestResult[permission];
      print(_permissionStatus);
    });
    if (permissionRequestResult[permission] == PermissionStatus.granted) {
      Navigator.pushReplacementNamed(context, "/ContactList");
    } else
      Fluttertoast.showToast(
          backgroundColor: cnst.appPrimaryMaterialColorYellow,
          msg: "Permission Not Granted",
          gravity: ToastGravity.TOP,
          toastLength: Toast.LENGTH_SHORT);
  }
  /* Future<void> requestPermission(PermissionGroup permission) async {
    final List<PermissionGroup> permissions = <PermissionGroup>[permission];
    final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
        await PermissionHandler().requestPermissions(permissions);

    setState(() {
      print(permissionRequestResult);
      _permissionStatus = permissionRequestResult[permission];
      print(_permissionStatus);
    });
  }*/

  bool isLoading = false;

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
    refreshContacts();
  }

  refreshContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String MemberId = prefs.getString(Session.CustomerId).toString();
    String ParentId = prefs.getString(Session.ParentId).toString();
    print("ParentId Init = ${ParentId}");
    setState(() {
      memberId = MemberId;
      parentId = ParentId;
      _isLoading = true;
    });
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

  _addCustomer() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        _selectedContact.clear();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        _selectedContact.add({
          "Id": 0,
          "ParentId": parentId.toString() == "null" || parentId == "0"
              ? memberId
              : parentId,
          "Name": "${txtName.text}",
          "Mobile": "${txtMobile.text}",
          "Type": 'Member',
          "StudioId": '${prefs.getString(Session.StudioId)}',
          "InviteStatus": 'Pending',
        });
        print("studio id 1234");
        print(_selectedContact);
        Services.AddCustomer(_selectedContact).then((data) async {
          pr.hide();
          if (data.Data == "1") {
            Fluttertoast.showToast(
                msg: "Invite Added Successfully",
                backgroundColor: cnst.appPrimaryMaterialColorYellow,
                textColor: Colors.white,
                gravity: ToastGravity.TOP,
                toastLength: Toast.LENGTH_SHORT);
            Navigator.pushReplacementNamed(context, "/MyCustomer");
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, "/MyCustomer");
      },
      child: Scaffold(
        appBar: AppBar(
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
          centerTitle: true,
          title: Text("Add Invite",
              style: GoogleFonts.aBeeZee(
                  textStyle: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: Colors.white))),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/MyCustomer");
              }),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(
                  "images/Back90.png",
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            isLoading
                ? LoadinComponent()
                : Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 10, top: 6),
                          child: TextFormField(
                            controller: txtName,
                            scrollPadding: EdgeInsets.all(0),
                            decoration: InputDecoration(
                                border: new OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.black),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                prefixIcon: Icon(
                                  Icons.person,
                                  //color: cnst.appPrimaryMaterialColorPink,
                                ),
                                hintText: "Invite Name",
                                hintStyle: GoogleFonts.aBeeZee(
                                    textStyle: TextStyle(
                                  fontSize: 16,
                                ))),
                            keyboardType: TextInputType.text,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: TextFormField(
                            controller: txtMobile,
                            scrollPadding: EdgeInsets.all(0),
                            maxLength: 10,
                            decoration: InputDecoration(
                                border: new OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.black),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                prefixIcon: Icon(
                                  Icons.call,
                                ),
                                counterText: "",
                                hintText: "Invite Mobile Number",
                                hintStyle: GoogleFonts.aBeeZee(
                                    textStyle: TextStyle(
                                  fontSize: 16,
                                ))),
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Text("OR",
                            style: GoogleFonts.aBeeZee(
                                textStyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: cnst.appPrimaryMaterialColorPink))),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.6,
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0)),
                            color: Color(0xff00A599),
                            onPressed: () {
                              requestPermission(PermissionGroup.contacts);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Icon(
                                  Icons.contact_phone,
                                  color: Colors.white,
                                  size: 17,
                                ),
                                Text("Choose From Contact List",
                                    style: GoogleFonts.aBeeZee(
                                        textStyle: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white))),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 50,
                          margin: EdgeInsets.only(top: 10),
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            color: cnst.appPrimaryMaterialColorPink,
                            minWidth: MediaQuery.of(context).size.width - 20,
                            onPressed: () {
                              if (txtName.text != "" && txtName.text != null) {
                                if (txtMobile.text != "" &&
                                    txtMobile.text != null) {
                                  if (txtMobile.text.length == 10) {
                                    _addCustomer();
                                  } else {
                                    showMsg("Enter Invite Valid Mobile Number");
                                  }
                                } else {
                                  showMsg("Enter Invite Mobile Number");
                                }
                              } else {
                                showMsg("Enter Invite Name");
                              }
                            },
                            child: Text("Submit",
                                style: GoogleFonts.aBeeZee(
                                    textStyle: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white))),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
