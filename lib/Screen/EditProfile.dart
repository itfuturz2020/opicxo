import 'dart:io';
import 'dart:ui';
import 'dart:ui';
import 'dart:ui';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opicxo/Common/Constants.dart';
import 'package:opicxo/Common/Services.dart';
import 'package:opicxo/Pages/Profile.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:opicxo/Common/Constants.dart' as cnst;
import 'package:url_launcher/url_launcher.dart';
import 'package:opicxo/Screen/EditProfile.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool isLoading = false;
  String cardData;
  String ShareMsg =
      "Hello sir,\n My Name is #sender. You can see my digital visiting card from the below link.\n #link \n Regards \n #sender \n Download the App from the below link to make sure your own visiting card. \n #applink";
  String CustomerId = "", Name = "", Email = "", Mobile = "";

  String name = '';

  String _url = "";
  String CustId, CustName, CustEmail, CustMobile;

  ProgressDialog pr;
  File profileImage;

  TextEditingController EditName = new TextEditingController();
  TextEditingController EditMobile = new TextEditingController();
  TextEditingController EditEmail = new TextEditingController();

  @override
  void initState() {
    _getData();
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
    _getLocalData();
  }

  _getLocalData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      CustId = preferences.getString(Session.CustomerId);
      CustName = preferences.getString(Session.Name);
      CustEmail = preferences.getString(Session.Email);
      CustMobile = preferences.getString(Session.Mobile);
    });
  }

  _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      EditName.text = prefs.getString(Session.Name);
      EditMobile.text = prefs.getString(Session.Mobile);
      EditEmail.text = prefs.getString(Session.Email);
      _url = prefs.getString(cnst.Session.Image);
    });
  }

  _updateProfile() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String id = preferences.getString(Session.CustomerId);
        setState(() {
          isLoading = true;
        });
        Future res = Services.UpdateProfile(
            id, EditName.text, EditMobile.text, EditEmail.text);
        res.then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data != "0" && data.IsSuccess == true) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString(cnst.Session.Name, "${EditName.text}");
            await prefs.setString(cnst.Session.Mobile, "${EditMobile.text}");
            await prefs.setString(cnst.Session.Email, "${EditEmail.text}");
            Fluttertoast.showToast(
                msg: "Data Successfully Updated",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: cnst.appPrimaryMaterialColorYellow,
                textColor: Colors.white,
                gravity: ToastGravity.TOP);
          } else {
            showMsg(data.Message);
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : on Login Call $e");
          showMsg("Try Again.");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
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

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
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

  _updatePhotographerPhoto() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        String filename = "";
        String filePath = "";
        File compressedFile;

        if (profileImage != null) {
          ImageProperties properties =
              await FlutterNativeImage.getImageProperties(profileImage.path);

          compressedFile = await FlutterNativeImage.compressImage(
            profileImage.path,
            quality: 80,
            targetWidth: 600,
            targetHeight: (properties.height * 600 / properties.width).round(),
          );

          filename = profileImage.path.split('/').last;
          filePath = compressedFile.path;
        }

        SharedPreferences preferences = await SharedPreferences.getInstance();
        FormData data = FormData.fromMap({
          "Id": "${preferences.getString(cnst.Session.CustomerId)}",
          "Image": (filePath != null && filePath != '')
              ? await MultipartFile.fromFile(filePath,
                  filename: filename.toString())
              : null,
        });

        Services.UpdateCustomerPhoto(data).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data != "0" && data.IsSuccess == true) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            profileImage != null
                ? await prefs.setString(cnst.Session.Image, "${data.Data}")
                : null;
            Fluttertoast.showToast(
                msg: "Image Successfully Updated",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: cnst.appPrimaryMaterialColorYellow,
                textColor: Colors.white,
                gravity: ToastGravity.TOP);
          } else {
            showMsg(data.Message);
          }
        }, onError: (e) {
          pr.hide();
          showMsg("Try Again.");
        });
      } else
        showMsg("No Internet Connection.");
    } on SocketException catch (_) {
      pr.hide();
      showMsg("No Internet Connection.");
    }
  }

  pickProfile(source) async {
    var picture = await ImagePicker.pickImage(source: source);
    this.setState(() {
      profileImage = picture;
    });
    Navigator.pop(context);
    _updatePhotographerPhoto();
  }

  Future<void> _chooseprofilepic(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Make Choice"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Gallery"),
                    onTap: () {
                      pickProfile(ImageSource.gallery);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
                      pickProfile(ImageSource.camera);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.pink,
          title: Text(
            "Edit Profile",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
        body: WillPopScope(
          onWillPop: onWillPop,
          child: Stack(
            children: <Widget>[
              Container(
                child: Opacity(
                  opacity: 0.4,
                  child: Image.asset(
                    "images/profilebackground.jpeg",
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
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      child: ClipOval(
                                          child: profileImage != null
                                              ? Image.file(
                                                  profileImage,
                                                  width: 90,
                                                  height: 90,
                                                  fit: BoxFit.fill,
                                                )
                                              : _url != "" && _url != null
                                                  ? FadeInImage.assetNetwork(
                                                      placeholder:
                                                          "images/man.png",
                                                      width: 110,
                                                      height: 110,
                                                      fit: BoxFit.fill,
                                                      image: "${cnst.ImgUrl}" +
                                                          _url)
                                                  : Image.asset(
                                                      "images/man.png",
                                                      width: 90,
                                                      height: 90,
                                                      fit: BoxFit.fill,
                                                    )),
                                    ),
                                    /*Container(
                                      child: ClipOval(
                                          child: Image.asset(
                                        "images/person.png",
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.fill,
                                      )),
                                    ),*/
                                    /*Positioned(
                                      top: MediaQuery.of(context).size.width / 6,
                                      left: MediaQuery.of(context).size.width / 5.3,
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 27,
                                      )),*/
                                  ],
                                ),
                              ),
                            ),
                            // Container(
                            //   margin: EdgeInsets.only(top: 10, left: 1),
                            //   height: MediaQuery.of(context).size.width / 10.5,
                            //   width: MediaQuery.of(context).size.width / 2.2,
                            //   decoration: BoxDecoration(
                            //       borderRadius:
                            //       BorderRadius.all(Radius.circular(15)),
                            //       gradient: LinearGradient(
                            //           begin: Alignment.topLeft,
                            //           end: Alignment.bottomRight,
                            //           colors: [
                            //             cnst.appPrimaryMaterialColorYellow,
                            //             cnst.appPrimaryMaterialColorPink
                            //           ])),
                            //   child: MaterialButton(
                            //     shape: RoundedRectangleBorder(
                            //         borderRadius: new BorderRadius.circular(9.0)),
                            //     onPressed: () {
                            //       if (!isLoading) _updateProfile();
                            //     },
                            //     child: isLoading
                            //         ? CircularProgressIndicator(
                            //       valueColor:
                            //       new AlwaysStoppedAnimation<Color>(
                            //           Colors.white),
                            //     )
                            //         : Text("Update Profile",
                            //         style: GoogleFonts.aBeeZee(
                            //             textStyle: TextStyle(
                            //                 fontSize: 17,
                            //                 fontWeight: FontWeight.w600,
                            //                 color: Colors.white))),
                            //   ),
                            // ),
                            // MaterialButton(
                            //   shape: RoundedRectangleBorder(
                            //       borderRadius: new BorderRadius.circular(9.0)),
                            //   onPressed: () {
                            //     _chooseprofilepic(context);
                            //   },
                            //   child: Text("Edit Photo",
                            //       style: GoogleFonts.aBeeZee(
                            //           textStyle: TextStyle(
                            //               fontSize: 17,
                            //               fontWeight: FontWeight.w600,
                            //               color: Colors.black))),
                            // ),
                            // RaisedButton(
                            //   shape: RoundedRectangleBorder(
                            //       borderRadius: new BorderRadius.circular(9.0)),
                            //   onPressed: () {
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(builder: (context) => EditProfile()),
                            //     );
                            //   },
                            //   child: Text("Edit Profile",
                            //       style: GoogleFonts.aBeeZee(
                            //           textStyle: TextStyle(
                            //               fontSize: 17,
                            //               fontWeight: FontWeight.w600,
                            //               color: Colors.white))),
                            // ),
                            Container(
                              height: MediaQuery.of(context).size.width / 12,
                              width: MediaQuery.of(context).size.width / 2.5,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        cnst.appPrimaryMaterialColorYellow,
                                        cnst.appPrimaryMaterialColorPink
                                      ])),
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(9.0)),
                                onPressed: () {
                                  _chooseprofilepic(context);
                                },
                                child: Text("Edit Photo",
                                    style: GoogleFonts.aBeeZee(
                                        textStyle: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white))),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 230.0, top: 1),
                              child: Text(
                                "Name",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Row(
                                children: <Widget>[
                                  // Chip(
                                  //     backgroundColor: Colors.pink,
                                  //     padding: const EdgeInsets.symmetric(
                                  //         vertical: 13, horizontal: 5),
                                  //     shape: RoundedRectangleBorder(
                                  //         borderRadius: BorderRadius.only(
                                  //             topRight: Radius.circular(25),
                                  //             bottomRight: Radius.circular(25))),
                                  //     label: Icon(
                                  //       Icons.person,
                                  //       size: 19,
                                  //       color: Colors.white,
                                  //     )),
                                  // Expanded(
                                  //   flex: 3,
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.only(
                                  //         top: 2.0, left: 8.0),
                                  //     child: Text("Name",
                                  //         style: GoogleFonts.aBeeZee(
                                  //             textStyle: TextStyle(
                                  //                 fontSize: 15,
                                  //                 fontWeight: FontWeight.w600,
                                  //                 color: Colors.black))),
                                  //   ),
                                  // ),
                                  // Expanded(
                                  //   flex: 1,
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.all(1.0),
                                  //     child: Text(":",
                                  //         style: GoogleFonts.aBeeZee(
                                  //             textStyle: TextStyle(
                                  //                 fontSize: 15,
                                  //                 fontWeight: FontWeight.w600,
                                  //                 color: Colors.black))),
                                  //   ),
                                  // ),
                                  Expanded(
                                    flex: 10,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 30.0, right: 30),
                                      child: Card(
                                        shadowColor: Colors.black,
                                        elevation: 20,
                                        shape: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                        color: Colors.white,
                                        child: Container(
                                          height: 48,
                                          width: 65,
                                          child: TextFormField(
                                            controller: EditName,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                fillColor: Colors.black,
                                                contentPadding: EdgeInsets.only(
                                                  top: 5,
                                                  left: 10,
                                                  bottom: 5,
                                                ),
                                                hintText: 'Enter Your Name',
                                                hintStyle: GoogleFonts.aBeeZee(
                                                    textStyle: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black))),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 230.0, top: 7),
                              child: Text(
                                "Phone",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Row(
                                children: <Widget>[
                                  // Chip(
                                  //     backgroundColor: Colors.pink,
                                  //     padding: const EdgeInsets.symmetric(
                                  //         vertical: 13, horizontal: 5),
                                  //     shape: RoundedRectangleBorder(
                                  //         borderRadius: BorderRadius.only(
                                  //             topRight: Radius.circular(25),
                                  //             bottomRight: Radius.circular(25))),
                                  //     label: Icon(
                                  //       Icons.phone_android,
                                  //       size: 19,
                                  //       color: Colors.white,
                                  //     )),
                                  // Container(
                                  //   decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(15),
                                  //   ),
                                  //
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.only(
                                  //         top: 2.0, left: 8.0),
                                  //     child: Text("MobileNo",
                                  //         style: GoogleFonts.aBeeZee(
                                  //             textStyle: TextStyle(
                                  //                 fontSize: 15,
                                  //                 fontWeight: FontWeight.w600,
                                  //                 color: Colors.black))),
                                  //   ),
                                  // ),
                                  // Expanded(
                                  //   flex: 1,
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.all(1.0),
                                  //     child: Text(":",
                                  //         style: GoogleFonts.aBeeZee(
                                  //             textStyle: TextStyle(
                                  //                 fontSize: 15,
                                  //                 fontWeight: FontWeight.w600,
                                  //                 color: Colors.black))),
                                  //   ),
                                  // ),
                                  Expanded(
                                    flex: 10,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 1.0, left: 30.0, right: 30),
                                      child: Card(
                                        color: Colors.white,
                                        shadowColor: Colors.black,
                                        elevation: 20,
                                        shape: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                        child: Container(
                                          height: 45,
                                          width: 60,
                                          child: TextFormField(
                                            //readOnly: true,
                                            controller: EditMobile,
                                            keyboardType: TextInputType.phone,
                                            decoration: InputDecoration(
                                                fillColor: Colors.grey[500],
                                                contentPadding: EdgeInsets.only(
                                                    top: 5,
                                                    left: 10,
                                                    bottom: 5),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15)),
                                                        borderSide:
                                                            BorderSide(
                                                                width: 1,
                                                                color: Colors
                                                                    .black)),
                                                hintText: 'Enter Mobile No',
                                                hintStyle: GoogleFonts.aBeeZee(
                                                    textStyle: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black))),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 230.0, top: 7),
                              child: Text(
                                "Email",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 8,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 1.0, left: 30.0, right: 30),
                                      child: Card(
                                        elevation: 20,
                                        color: Colors.white,
                                        shadowColor: Colors.black,
                                        shape: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                        child: Container(
                                          height: 45,
                                          width: 60,
                                          child: TextFormField(
                                            controller: EditEmail,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            decoration: InputDecoration(
                                                fillColor: Colors.grey[200],
                                                contentPadding: EdgeInsets.only(
                                                    top: 5,
                                                    left: 10,
                                                    bottom: 5),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5)),
                                                        borderSide:
                                                            BorderSide(
                                                                width: 0,
                                                                color: Colors
                                                                    .black)),
                                                hintText: 'Enter Email Address',
                                                hintStyle: GoogleFonts.aBeeZee(
                                                    textStyle: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black))),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10, left: 1),
                              height: MediaQuery.of(context).size.width / 10.5,
                              width: MediaQuery.of(context).size.width / 2.2,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        cnst.appPrimaryMaterialColorYellow,
                                        cnst.appPrimaryMaterialColorPink
                                      ])),
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(9.0)),
                                onPressed: () {
                                  if (!isLoading) _updateProfile();
                                },
                                child: isLoading
                                    ? CircularProgressIndicator(
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      )
                                    : Text("Update Profile",
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
                    ),
                  ],
                ),
              ),
            ],
          ),
          /*Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                  elevation: 5,
                  margin: EdgeInsets.all(5),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        //name
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width / 2.7,
                                //color: Colors.black,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          child: ClipOval(
                                              child:
                                                  */ /* profileImage != null
                                                  ? Image.file(
                                                profileImage,
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.fill,
                                              )
                                                  : _url != "" && _url != null
                                                  ? FadeInImage.assetNetwork(
                                                  placeholder: "images/user1.png",
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.fill,
                                                  image: "${cnst.APIURL.IMG_URL}" +
                                                      _url)
                                                  :*/ /*
                                                  Image.asset(
                                            "images/user1.png",
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.fill,
                                          )),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Name',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ),
                              Text(
                                ':',
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                //color: Colors.black,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('${Name}',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                        ))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        //Mobile
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width / 2.7,
                                //color: Colors.black,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Mobile Number',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ),
                              Text(
                                ':',
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                //color: Colors.black,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('${Mobile}',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                        ))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        //Email
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width / 2.7,
                                //color: Colors.black,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'E-Mail Address',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ),
                              Text(
                                ':',
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                //color: Colors.black,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('${Email}',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                        ))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                */ /*Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: RaisedButton(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            elevation: 5,
                            textColor: Colors.white,
                            color: cnst.appPrimaryMaterialColorYellow,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.share,
                                  color: Colors.white,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text("Share",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15)),
                                )
                              ],
                            ),
                            onPressed: () {
                              _getViewCardId("no");
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder: (BuildContext context, _, __) =>
                                      CardShareComponent(
                                        memberId: cardData,
                                        memberName: Name,
                                        isRegular: true,
                                        memberType: "",
                                        shareMsg: ShareMsg,
                                        IsActivePayment: true,
                                      ),
                                ),
                              );
                            },
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0))),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: RaisedButton(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            elevation: 5,
                            textColor: Colors.white,
                            color: cnst.appPrimaryMaterialColorYellow,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.white,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text("View Card",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15)),
                                )
                              ],
                            ),
                            onPressed: () async {
                              _getViewCardId("yes");
                            },
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0))),
                      )
                    ],
                  ),
                ),*/ /*
              ],
            ),
          ),*/
        ),
      ),
    );
  }
}
