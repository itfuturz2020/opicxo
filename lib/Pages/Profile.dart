import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'dart:ui';
import 'dart:ui';
import 'dart:ui';
import 'package:clay_containers/clay_containers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:opicxo/Common/Constants.dart';
import 'package:opicxo/Common/Services.dart';
import 'package:opicxo/Screen/CardShareComponent.dart';
import 'package:opicxo/Screen/FullScreenImage.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:opicxo/Common/Constants.dart' as cnst;
import 'package:url_launcher/url_launcher.dart';
import 'package:opicxo/Screen/EditProfile.dart';

class Profile extends StatefulWidget {
  String mobile, id, name;
  List data = [];
  Profile({this.mobile, this.id, this.name});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isLoading = false;
  String MemberType = "";
  bool IsActivePayment = false;
  String cardData;
  String ShareMsg =
      "Hello sir,\n My Name is #sender. You can see my digital visiting card from the below link.\n #link \n Regards \n #sender \n Download the App from the below link to make sure your own visiting card. \n #applink";
  String CustomerId = "", Name = "", Email = "", Mobile = "", StudioLogo = "";

  String _url = "";
  String CustId, CustName, CustEmail, CustMobile;

  ProgressDialog pr;
  File profileImage;

  TextEditingController EditName = new TextEditingController();
  TextEditingController EditMobile = new TextEditingController();
  TextEditingController EditEmail = new TextEditingController();
  String name, mobile, email;

  @override
  void initState() {
    print("image data");
    print(Session.Image);
    _profileData();
    //_getData();
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
      StudioLogo = preferences.getString(Session.StudioLogo);
      CustEmail = preferences.getString(Session.Email);
      CustMobile = preferences.getString(Session.Mobile);
    });
  }
  //
  // _getData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     EditName.text = prefs.getString(Session.Name);
  //     EditMobile.text = prefs.getString(Session.Mobile);
  //     EditEmail.text = prefs.getString(Session.Email);
  //     _url = prefs.getString(cnst.Session.Image);
  //   });
  // }

  _updateProfile() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String id = preferences.getString(Session.StudioId);
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
            await prefs.setString(cnst.Session.StudioName, "${EditName.text}");
            await prefs.setString(
                cnst.Session.StudioMobile, "${EditMobile.text}");
            await prefs.setString(
                cnst.Session.StudioEmail, "${EditEmail.text}");
            var image = prefs.getString(Session.Image);
            Fluttertoast.showToast(
                msg: "Data Successfully Updated",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: cnst.appPrimaryMaterialColorYellow,
                textColor: Colors.white,
                gravity: ToastGravity.TOP);
            editpressed = false;
            updatepressed = false;
            // data[0]["Name"] = name;
            // data[0]["Mobile"] = mobile;
            // data[0]["Email"] = email;
            // profileImage = image;
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

  List profileData = [];
  String studioid = "";
  String id, studiomobile;

  _profileData() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        id = preferences.getString(Session.StudioId);
        setState(() {
          isLoading = true;
        });
        var mobilenumber = preferences.getString(Session.StudioMobile);
        Future res = Services.MemberLogin(mobilenumber);
        res.then((data) async {
          setState(() {
            profileData = data;
            isLoading = false;
            name = data[0]["studio"]["Name"];
            mobile = data[0]["studio"]["MobileNo"];
            email = data[0]["studio"]["Email"];
          });
          if (data != "0") {
            SharedPreferences prefs = await SharedPreferences.getInstance();
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

  _StudioDigitalCardId() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        id = preferences.getString(Session.StudioId);
        studiomobile = preferences.getString(Session.StudioMobile);
        setState(() {
          isLoading = true;
        });
        Future res = Services.StudioDigitalCard(studiomobile);
        res.then((data) async {
          setState(() {
            studioid = data;
            isLoading = false;
          });
          if (data != "0") {
            SharedPreferences prefs = await SharedPreferences.getInstance();
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

        print("filename");
        print(filename);
        print("filePath");
        print(filePath);

        SharedPreferences preferences = await SharedPreferences.getInstance();
        FormData data = FormData.fromMap({
          "Id": "${preferences.getString(cnst.Session.StudioId)}",
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
            print("data is not null");
            SharedPreferences prefs = await SharedPreferences.getInstance();
            profileImage != null
                ? await prefs.setString(cnst.Session.Image, "${data.Data}")
                : null;
            cnst.Session.Image = data.Data;

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
      Session.profilephoto = profileImage;
      print("profileImage");
      print(profileImage);
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

  String ExpDate = "";

  bool checkValidity() {
    if (ExpDate.trim() != null && ExpDate.trim() != "") {
      final f = new DateFormat('dd MMM yyyy');
      DateTime validTillDate = f.parse(ExpDate);
      print(validTillDate);
      DateTime currentDate = new DateTime.now();
      print(currentDate);
      if (validTillDate.isAfter(currentDate)) {
        return true;
      } else {
        return false;
      }
    } else
      return false;
  }

  List CardIddata = [];
  List Updatedata = [];
  var cardid = "";

  getCardId() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        SharedPreferences prefs = await SharedPreferences.getInstance();
        var mobile = prefs.getString(cnst.Session.Mobile);
        Future res = Services.GetCardIdLogin("login", mobile);
        res.then((data) async {
          print(data);
          if (data != null && data.length > 0) {
            setState(() {
              CardIddata = data;
              cardid = CardIddata[0]["cardid"];
              isLoading = false;
            });
            print("Session card id");
            print(cardid);
            if (cardid == "" || cardid == null) {
              print("if part");
              SaveOffer();
              checkLogin();
            } else {
              print("else part");
              checkLogin();
            }
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          showMsg("Something went wrong.Please try agian.");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
      });
      showMsg("No Internet Connection.");
    }
  }

  UpdateCardId(String cardid) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        SharedPreferences prefs = await SharedPreferences.getInstance();
        Future res = Services.UpdateCardId("updatemember", cardid, "2944");
        res.then((data) async {
          print(data);
          if (data != null && data.length > 0) {
            setState(() {
              Updatedata = data;
              print("Updatedata");
              print(Updatedata);
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          showMsg("Something went wrong.Please try agian.");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
      });
      showMsg("No Internet Connection.");
    }
  }

  File _image;
  TextEditingController txtRegCode = new TextEditingController();
  List data;

  checkLogin() async {
    if (CardIddata[0]["mobile"] != "" && CardIddata[0]["mobile"] != null) {
      if (CardIddata[0]["mobile"].length == 10) {
        try {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            //pr.show();
            Services.MemberLogin1(CardIddata[0]["mobile"]).then((data) async {
              if (data != null || data == []) {
                cardid = data[0].Id;
                ShareMsg = data[0].ShareMsg;
                MemberType = prefs.getString(Session.Type);
                print("cardid latest");
                print(cardid);
                print("ShareMsg");
                print(ShareMsg);
                UpdateCardId(cardid);
              }
            }, onError: (e) {
              //pr.hide();
              print("Error : on Login Call $e");
              showMsg("$e");
            });
          } else {
            //pr.hide();
            showMsg("Something wen wrong");
          }
        } on SocketException catch (_) {
          showMsg("No Internet Connection.");
        }
      } else {
        Fluttertoast.showToast(
            msg: "Please enter Valid Mobile Number",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            textColor: Colors.white,
            fontSize: 15.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Please enter Mobile Number",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          textColor: Colors.white,
          fontSize: 15.0);
    }
  }

  SaveOffer() async {
    if (CardIddata[0]["person"] != '' ||
        CardIddata[0]["mobile"] != '' ||
        CardIddata[0]["companyname"] != '') {
      String img = cnst.Session.SignImage;
      String referCode = CardIddata[0]["person"].substring(0, 3).toUpperCase();

      if (_image != null) {
        List<int> imageBytes = await _image.readAsBytesSync();
        String base64Image = base64Encode(imageBytes);
        img = base64Image;
      }

      var data = {
        'type': 'signup',
        'name': CardIddata[0]["person"],
        'mobile': CardIddata[0]["mobile"],
        'imagecode': "",
        'company': CardIddata[0]["companyname"],
        'email': CardIddata[0]["officeemail"],
        'myreferCode': referCode,
        'regreferCode': txtRegCode.text,
      };
      Future res = Services.MemberSignUp(data);
      res.then((data) {
        setState(() {
          isLoading = false;
        });
        if (data != null && data.ERROR_STATUS == false) {
          Fluttertoast.showToast(
              msg: "Data Saved",
              backgroundColor: Colors.green,
              gravity: ToastGravity.TOP);
        } else {
          Fluttertoast.showToast(
              msg: "Data Not Saved" + data.MESSAGE,
              backgroundColor: Colors.red,
              gravity: ToastGravity.TOP,
              toastLength: Toast.LENGTH_LONG);
        }
      }, onError: (e) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
            msg: "Data Not Saved" + e.toString(), backgroundColor: Colors.red);
      });
    } else {
      Fluttertoast.showToast(
          msg: "Please Enter Data First",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.yellow,
          textColor: Colors.black,
          fontSize: 15.0);
    }
  }

  bool editpressed = false;
  bool updatepressed = false;

  @override
  Widget build(BuildContext context) {
    print("profileImage");
    print(Session.profilephoto);
    return Material(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
          title: Text(
            "Profile",
            style: GoogleFonts.aBeeZee(
              textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
          actions: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.only(right:8.0),
            //   child: GestureDetector(
            //     onTap: (){
            //       setState(() {
            //         EditName.text = name;
            //         EditMobile.text = mobile;
            //         EditEmail.text = email;
            //         editpressed = true;
            //       });
            //     },
            //       child: !editpressed ||updatepressed? Icon(
            //           Icons.edit,
            //       ) : GestureDetector(
            //         onTap: (){
            //           setState(() {
            //             name  =EditName.text;
            //             mobile = EditMobile.text;
            //             email = EditEmail.text;
            //           });
            //           _updateProfile();
            //           setState(() {
            //             updatepressed = true;
            //           });
            //         },
            //         child: Icon(
            //           Icons.update,
            //         ),
            //       ),
            //   ),
            // ),
          ],
        ),
        body: SingleChildScrollView(
          child: WillPopScope(
            onWillPop: onWillPop,
            child: Stack(
              fit: StackFit.loose,
              children: <Widget>[
                Container(
                  child: Opacity(
                    opacity: 1,
                    child: StudioLogo == null
                        ? Image.asset(
                            "images/logo1.png",
                            height: 50,
                            width: 50,
                            fit: BoxFit.fill,
                          )
                        : Image.asset("images/logo1.png"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ClayContainer(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: ClayContainer(
                      color: Colors.white,
                      curveType: CurveType.convex,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 15),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 140,
                                      height: 140,
                                      child: Opacity(
                                        opacity: 1,
                                        child: StudioLogo == null
                                            ? Image.asset(
                                                "images/logo1.png",
                                              )
                                            // : Image.asset(
                                            //     "images/onlylogo.jpeg"),
                                            : Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xff7c94b6),
                                                  // image: const DecorationImage(
                                                  //   image: AssetImage( "images/logo1.png"),
                                                  //   fit: BoxFit.cover,
                                                  // ),
                                                  border: Border.all(
                                                    color: Colors.black,
                                                    width: 8,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Image.asset(
                                                    "images/logo1.png"),
                                              ),
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 50.0, left: 8),
                              child: !editpressed || updatepressed
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Text("Name: ",
                                            // style: TextStyle(
                                            //   fontWeight: FontWeight.bold,
                                            //   fontSize: 20
                                            // ),
                                            // ),
                                            name != null
                                                ? Text(
                                                    "${name}",
                                                    style: TextStyle(
                                                        //fontWeight: FontWeight.w700,
                                                        fontSize: 20),
                                                  )
                                                : Text(
                                                    "${cnst.Session.Name}",
                                                    style: TextStyle(
                                                        //fontWeight: FontWeight.w700,
                                                        fontSize: 20),
                                                  ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            // Text("Mobile: ",
                                            //   style: TextStyle(
                                            //       fontWeight: FontWeight.bold,
                                            //       fontSize: 20
                                            //   ),
                                            // ),
                                            mobile != null
                                                ? Text(
                                                    "${mobile}",
                                                    style: TextStyle(
                                                        //fontWeight: FontWeight.w700,
                                                        fontSize: 20),
                                                  )
                                                : Text(
                                                    "${cnst.Session.Mobile}",
                                                    style: TextStyle(
                                                        //fontWeight: FontWeight.w700,
                                                        fontSize: 20),
                                                  ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Column(
                                          children: [
                                            // Text("Email: ",
                                            //   style: TextStyle(
                                            //       fontWeight: FontWeight.bold,
                                            //       fontSize: 20
                                            //   ),
                                            // ),

                                            email != null
                                                ? Text(
                                                    "${email}",
                                                    style: TextStyle(
                                                        //fontWeight: FontWeight.w700,
                                                        fontSize: 20),
                                                  )
                                                : Text(
                                                    "${cnst.Session.Email}",
                                                    style: TextStyle(
                                                      //fontWeight: FontWeight.w700,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          height: 24,
                                          child: new TextFormField(
                                            controller: EditName,
                                            decoration: const InputDecoration(),
                                            keyboardType: TextInputType.text,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          height: 24,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          child: new TextFormField(
                                            controller: EditMobile,
                                            decoration: const InputDecoration(),
                                            keyboardType: TextInputType.phone,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          height: 24,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          child: new TextFormField(
                                            controller: EditEmail,
                                            decoration: const InputDecoration(),
                                            keyboardType:
                                                TextInputType.emailAddress,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 200, left: 20),
                  child: Stack(
                    children: [
                      ClayContainer(
                        width: MediaQuery.of(context).size.width * 0.90,
                        height: MediaQuery.of(context).size.height * 0.5,
                        //color: Colors.white,
                        child: ClayContainer(
                          curveType: CurveType.convex,
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width * 0.90,
                          height: MediaQuery.of(context).size.height * 0.5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 35.0, left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.pink,
                                  ),
                                  //color: Colors.pink,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacementNamed(
                                          context, '/MyCustomer');
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Icon(
                                        Icons.accessibility,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/MyCustomer');
                                  },
                                  child: Text(
                                    "Share App",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.blue,
                                  ),
                                  //color: Colors.pink,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/PortfolioScreen');
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Icon(
                                        Icons.brush,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/PortfolioScreen');
                                  },
                                  child: Text(
                                    "View Portfolio",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 140.0, left: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.green,
                                  ),
                                  //color: Colors.pink,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/SocialLink');
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Icon(
                                        Icons.link,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/SocialLink');
                                  },
                                  child: Text(
                                    "Social Link",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.teal,
                                  ),
                                  //color: Colors.pink,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/StudioLocation');
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Icon(
                                        Icons.add_location,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/StudioLocation');
                                  },
                                  child: Text(
                                    "Branches",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 265.0, left: 15),
                        // child:
                        // Container(
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(40),
                        //   ),
                        //   width: MediaQuery.of(context).size.width*0.85,
                        //   child: RaisedButton(
                        //     child: Text("Preview Card",
                        //     style: TextStyle(
                        //       color: Colors.white,
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: 20
                        //     ),
                        //     ),
                        //     onPressed: () async {
                        //       _StudioDigitalCardId();
                        //       String profileUrl = cnst.profileUrl
                        //           .replaceAll("#id",studioid);
                        //       if (await canLaunch(profileUrl)) {
                        //         await launch(profileUrl);
                        //       } else {
                        //         throw 'Could not launch $profileUrl';
                        //       }
                        //     },
                        //     color: Colors.black,
                        //   ),
                        // ),
                        // Column(
                        //   children: [
                        //     Container(
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(30),
                        //         color: Colors.deepOrange,
                        //       ),
                        //       //color: Colors.pink,
                        //       child: GestureDetector(
                        //         onTap: (){
                        //           getCardId();
                        //           bool val = checkValidity();
                        //           Navigator.of(context).push(
                        //             PageRouteBuilder(
                        //               opaque: false,
                        //               pageBuilder:
                        //                   (BuildContext context, _, __) =>
                        //                   CardShareComponent(
                        //                     memberId: cardid,
                        //                     memberName: Name,
                        //                     isRegular: val,
                        //                     memberType: MemberType,
                        //                     shareMsg: ShareMsg,
                        //                     IsActivePayment: IsActivePayment,
                        //                   ),
                        //             ),
                        //           );
                        //         },
                        //         child: Padding(
                        //           padding: const EdgeInsets.all(2.0),
                        //           child: Icon(Icons.share,
                        //             size: 37,
                        //             color: Colors.white,
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       height: 5,
                        //     ),
                        //     GestureDetector(
                        //               onTap: (){
                        //                 getCardId();
                        //                 bool val = checkValidity();
                        //                 Navigator.of(context).push(
                        //                   PageRouteBuilder(
                        //                     opaque: false,
                        //                     pageBuilder:
                        //                         (BuildContext context, _, __) =>
                        //                         CardShareComponent(
                        //                           memberId: cardid,
                        //                           memberName: Name,
                        //                           isRegular: val,
                        //                           memberType: MemberType,
                        //                           shareMsg: ShareMsg,
                        //                           IsActivePayment: IsActivePayment,
                        //                         ),
                        //                   ),
                        //                 );
                        //               },
                        //       child: Text(
                        //         "Share Card",
                        //         style: TextStyle(
                        //           fontWeight: FontWeight.bold,
                        //           color: Colors.black,
                        //           fontSize: 18,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        // Column(
                        //   children: [
                        //     Container(
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(30),
                        //         color: Colors.purple,
                        //       ),
                        //       //color: Colors.pink,
                        //       child: GestureDetector(
                        //         onTap: () async {
                        //           _StudioDigitalCardId();
                        //           String profileUrl = cnst.profileUrl
                        //               .replaceAll("#id",studioid);
                        //           if (await canLaunch(profileUrl)) {
                        //             await launch(profileUrl);
                        //           } else {
                        //             throw 'Could not launch $profileUrl';
                        //           }
                        //         },
                        //         child: Padding(
                        //           padding: const EdgeInsets.all(2.0),
                        //           child: Icon(Icons.preview,
                        //             size: 40,
                        //             color: Colors.white,
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       height: 5,
                        //     ),
                        //     GestureDetector(
                        //       onTap: () async {
                        //         _StudioDigitalCardId();
                        //         String profileUrl = cnst.profileUrl
                        //             .replaceAll("#id", studioid);
                        //         if (await canLaunch(profileUrl)) {
                        //           await launch(profileUrl);
                        //         } else {
                        //           throw 'Could not launch $profileUrl';
                        //         }
                        //       },
                        //       child: Text(
                        //         "Preview Card",
                        //         style: TextStyle(
                        //           fontWeight: FontWeight.bold,
                        //           color: Colors.black,
                        //           fontSize: 18,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(
                        //   width: 10,
                        // ),
                      ),
                    ],
                  ),
                ),
                //       SingleChildScrollView(
                //         child: Column(
                //           children: <Widget>[
                //             Padding(
                //               padding: const EdgeInsets.only(top: 5.0),
                //               child: Container(
                //                 child: Column(
                //                   children: <Widget>[
                //                     Center(
                //                       child: Padding(
                //                         padding: const EdgeInsets.all(15.0),
                //                         child: Stack(
                //                           children: <Widget>[
                //                             Container(
                //                               child: ClipOval(
                //                                   child: profileImage != null
                //                                       ? Image.file(
                //                                           profileImage,
                //                                           width: 90,
                //                                           height: 90,
                //                                           fit: BoxFit.fill,
                //                                         )
                //                                       : _url != "" && _url != null
                //                                           ? FadeInImage.assetNetwork(
                //                                               placeholder: "images/man.png",
                //                                               width: 110,
                //                                               height: 110,
                //                                               fit: BoxFit.fill,
                //                                               image:
                //                                                   "${cnst.ImgUrl}" + _url)
                //                                           : Image.asset(
                //                                               "images/man.png",
                //                                               width: 90,
                //                                               height: 90,
                //                                               fit: BoxFit.fill,
                //                                             )),
                //                             ),
                //                             /*Container(
                //                               child: ClipOval(
                //                                   child: Image.asset(
                //                                 "images/person.png",
                //                                 width: 100,
                //                                 height: 100,
                //                                 fit: BoxFit.fill,
                //                               )),
                //                             ),*/
                //                             /*Positioned(
                //                               top: MediaQuery.of(context).size.width / 6,
                //                               left: MediaQuery.of(context).size.width / 5.3,
                //                               child: Icon(
                //                                 Icons.camera_alt,
                //                                 size: 27,
                //                               )),*/
                //                           ],
                //                         ),
                //                       ),
                //                     ),
                //                     // Container(
                //                     //   margin: EdgeInsets.only(top: 10, left: 1),
                //                     //   height: MediaQuery.of(context).size.width / 10.5,
                //                     //   width: MediaQuery.of(context).size.width / 2.2,
                //                     //   decoration: BoxDecoration(
                //                     //       borderRadius:
                //                     //       BorderRadius.all(Radius.circular(15)),
                //                     //       gradient: LinearGradient(
                //                     //           begin: Alignment.topLeft,
                //                     //           end: Alignment.bottomRight,
                //                     //           colors: [
                //                     //             cnst.appPrimaryMaterialColorYellow,
                //                     //             cnst.appPrimaryMaterialColorPink
                //                     //           ])),
                //                     //   child: MaterialButton(
                //                     //     shape: RoundedRectangleBorder(
                //                     //         borderRadius: new BorderRadius.circular(9.0)),
                //                     //     onPressed: () {
                //                     //       if (!isLoading) _updateProfile();
                //                     //     },
                //                     //     child: isLoading
                //                     //         ? CircularProgressIndicator(
                //                     //       valueColor:
                //                     //       new AlwaysStoppedAnimation<Color>(
                //                     //           Colors.white),
                //                     //     )
                //                     //         : Text("Update Profile",
                //                     //         style: GoogleFonts.aBeeZee(
                //                     //             textStyle: TextStyle(
                //                     //                 fontSize: 17,
                //                     //                 fontWeight: FontWeight.w600,
                //                     //                 color: Colors.white))),
                //                     //   ),
                //                     // ),
                //                     // MaterialButton(
                //                     //   shape: RoundedRectangleBorder(
                //                     //       borderRadius: new BorderRadius.circular(9.0)),
                //                     //   onPressed: () {
                //                     //     _chooseprofilepic(context);
                //                     //   },
                //                     //   child: Text("Edit Photo",
                //                     //       style: GoogleFonts.aBeeZee(
                //                     //           textStyle: TextStyle(
                //                     //               fontSize: 17,
                //                     //               fontWeight: FontWeight.w600,
                //                     //               color: Colors.black))),
                //                     // ),
                //                     // Text(
                //                     //     "${EditName.text}",
                //                     // style: TextStyle(
                //                     //   fontWeight: FontWeight.bold,
                //                     //   fontSize: 28,
                //                     // ),
                //                     // ),
                //                     RaisedButton(
                //                       shape: RoundedRectangleBorder(
                //                           borderRadius: new BorderRadius.circular(9.0)),
                //                       onPressed: () {
                //                         Navigator.push(
                //                           context,
                //                           MaterialPageRoute(builder: (context) => EditProfile()),
                //                         );
                //                       },
                //                       child: Text("Edit Profile",
                //                           style: GoogleFonts.aBeeZee(
                //                               textStyle: TextStyle(
                //                                   fontSize: 15,
                //                                   fontWeight: FontWeight.w600,
                //                                   color: Colors.white))),
                //                     ),
                //                     Container(
                //                       height: MediaQuery.of(context).size.width / 12,
                //                       width: MediaQuery.of(context).size.width / 2.5,
                //                       decoration: BoxDecoration(
                //                           borderRadius:
                //                               BorderRadius.all(Radius.circular(15)),
                //                           gradient: LinearGradient(
                //                               begin: Alignment.topLeft,
                //                               end: Alignment.bottomRight,
                //                               colors: [
                //                                 cnst.appPrimaryMaterialColorYellow,
                //                                 cnst.appPrimaryMaterialColorPink
                //                               ])),
                //                       child: MaterialButton(
                //                         shape: RoundedRectangleBorder(
                //                             borderRadius: new BorderRadius.circular(9.0)),
                //                         onPressed: () {
                //                           _chooseprofilepic(context);
                //                         },
                //                         child: Text("Edit Photo",
                //                             style: GoogleFonts.aBeeZee(
                //                                 textStyle: TextStyle(
                //                                     fontSize: 17,
                //                                     fontWeight: FontWeight.w600,
                //                                     color: Colors.white))),
                //                       ),
                //                     ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 15.0),
                //   child: Row(
                //     children: <Widget>[
                //       Chip(
                //           backgroundColor: Colors.pink,
                //           padding: const EdgeInsets.symmetric(
                //               vertical: 13, horizontal: 5),
                //           shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.only(
                //                   topRight: Radius.circular(25),
                //                   bottomRight: Radius.circular(25))),
                //           label: Icon(
                //             Icons.person,
                //             size: 19,
                //             color: Colors.white,
                //           )),
                //       Expanded(
                //         flex: 3,
                //         child: Padding(
                //           padding: const EdgeInsets.only(
                //               top: 2.0, left: 8.0),
                //           child: Text("Name",
                //               style: GoogleFonts.aBeeZee(
                //                   textStyle: TextStyle(
                //                       fontSize: 15,
                //                       fontWeight: FontWeight.w600,
                //                       color: Colors.black))),
                //         ),
                //       ),
                //       Expanded(
                //         flex: 1,
                //         child: Padding(
                //           padding: const EdgeInsets.all(1.0),
                //           child: Text(":",
                //               style: GoogleFonts.aBeeZee(
                //                   textStyle: TextStyle(
                //                       fontSize: 15,
                //                       fontWeight: FontWeight.w600,
                //                       color: Colors.black))),
                //         ),
                //       ),
                //       Expanded(
                //         flex: 10,
                //         child: Padding(
                //           padding: const EdgeInsets.only(
                //               top: 2.0, left: 30.0, right: 30),
                //           child: Container(
                //             height: 40,
                //             width: 60,
                //             child: TextFormField(
                //               controller: EditName,
                //               keyboardType: TextInputType.text,
                //               decoration: InputDecoration(
                //                   fillColor: Colors.black,
                //                   contentPadding: EdgeInsets.only(
                //                       top: 5, left: 10, bottom: 5),
                //                   focusedBorder: OutlineInputBorder(
                //                       borderRadius: BorderRadius.all(
                //                           Radius.circular(25)),
                //                       borderSide: BorderSide(
                //                           width: 2,
                //                           color: Colors.black)),
                //                   enabledBorder: OutlineInputBorder(
                //                       borderRadius: BorderRadius.all(
                //                           Radius.circular(20)),
                //                       borderSide: BorderSide(
                //                           width: 1,
                //                           color: Colors.black)),
                //                   hintText: 'Enter Your Name',
                //                   hintStyle: GoogleFonts.aBeeZee(
                //                       textStyle: TextStyle(
                //                           fontSize: 14,
                //                           color: Colors.black))),
                //             ),
                //           ),
                //         ),
                //       ),
                //
                //     ],
                //   ),
                // ),
                //                     Padding(
                //                       padding: const EdgeInsets.only(top: 20.0),
                //                       child: Row(
                //                         children: <Widget>[
                //                           // Chip(
                //                           //     backgroundColor: Colors.pink,
                //                           //     padding: const EdgeInsets.symmetric(
                //                           //         vertical: 13, horizontal: 5),
                //                           //     shape: RoundedRectangleBorder(
                //                           //         borderRadius: BorderRadius.only(
                //                           //             topRight: Radius.circular(25),
                //                           //             bottomRight: Radius.circular(25))),
                //                           //     label: Icon(
                //                           //       Icons.phone_android,
                //                           //       size: 19,
                //                           //       color: Colors.white,
                //                           //     )),
                //                           // Container(
                //                           //   decoration: BoxDecoration(
                //                           //     borderRadius: BorderRadius.circular(15),
                //                           //   ),
                //                           //
                //                           //   child: Padding(
                //                           //     padding: const EdgeInsets.only(
                //                           //         top: 2.0, left: 8.0),
                //                           //     child: Text("MobileNo",
                //                           //         style: GoogleFonts.aBeeZee(
                //                           //             textStyle: TextStyle(
                //                           //                 fontSize: 15,
                //                           //                 fontWeight: FontWeight.w600,
                //                           //                 color: Colors.black))),
                //                           //   ),
                //                           // ),
                //                           // Expanded(
                //                           //   flex: 1,
                //                           //   child: Padding(
                //                           //     padding: const EdgeInsets.all(1.0),
                //                           //     child: Text(":",
                //                           //         style: GoogleFonts.aBeeZee(
                //                           //             textStyle: TextStyle(
                //                           //                 fontSize: 15,
                //                           //                 fontWeight: FontWeight.w600,
                //                           //                 color: Colors.black))),
                //                           //   ),
                //                           // ),
                //                           Expanded(
                //                             flex: 10,
                //                             child: Padding(
                //                               padding: const EdgeInsets.only(
                //                                   top: 1.0, left: 30.0, right: 30),
                //                               child: Container(
                //                                 height: 40,
                //                                 width: 60,
                //                                 child: TextFormField(
                //                                   //readOnly: true,
                //                                   controller: EditMobile,
                //                                   keyboardType: TextInputType.phone,
                //                                   decoration: InputDecoration(
                //                                       fillColor: Colors.grey[500],
                //                                       contentPadding: EdgeInsets.only(
                //                                           top: 5, left: 10, bottom: 5),
                //                                       focusedBorder: OutlineInputBorder(
                //                                           borderRadius: BorderRadius.all(
                //                                               Radius.circular(15)),
                //                                           borderSide: BorderSide(
                //                                               width: 1,
                //                                               color: Colors.black)),
                //                                       enabledBorder: OutlineInputBorder(
                //                                           borderRadius: BorderRadius.all(
                //                                               Radius.circular(20)),
                //                                           borderSide: BorderSide(
                //                                               width: 1,
                //                                               color: Colors.black)),
                //                                       hintText: 'Enter Mobile No',
                //                                       hintStyle: GoogleFonts.aBeeZee(
                //                                           textStyle: TextStyle(
                //                                               fontSize: 15,
                //                                               color: Colors.black))),
                //                                 ),
                //                               ),
                //                             ),
                //                           ),
                //                         ],
                //                       ),
                //                     ),
                //                     Padding(
                //                       padding: const EdgeInsets.only(top: 20.0),
                //                       child: Row(
                //                         children: <Widget>[
                // Chip(
                //     backgroundColor: Colors.pink,
                //     padding: const EdgeInsets.symmetric(
                //         vertical: 13, horizontal: 5),
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.only(
                //             topRight: Radius.circular(25),
                //             bottomRight: Radius.circular(25))),
                //     label: Icon(
                //       Icons.email,
                //       size: 19,
                //       color: Colors.white,
                //     )),
                // Expanded(
                //   flex: 3,
                //   child: Padding(
                //     padding: const EdgeInsets.only(
                //         top: 2.0, left: 8.0),
                //     child: Text("Email",
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
                //                           Expanded(
                //                             flex: 8,
                //                             child: Padding(
                //                               padding: const EdgeInsets.only(
                //                                   top: 1.0, left: 30.0, right: 30),
                //                               child: Container(
                //                                 height: 40,
                //                                 width: 60,
                //                                 child: TextFormField(
                //                                   controller: EditEmail,
                //                                   keyboardType: TextInputType.emailAddress,
                //                                   decoration: InputDecoration(
                //                                       fillColor: Colors.grey[200],
                //                                       contentPadding: EdgeInsets.only(
                //                                           top: 5, left: 10, bottom: 5),
                //                                       focusedBorder: OutlineInputBorder(
                //                                           borderRadius: BorderRadius.all(
                //                                               Radius.circular(5)),
                //                                           borderSide: BorderSide(
                //                                               width: 0,
                //                                               color: Colors.black)),
                //                                       enabledBorder: OutlineInputBorder(
                //                                           borderRadius: BorderRadius.all(
                //                                               Radius.circular(20)),
                //                                           borderSide: BorderSide(
                //                                               width: 1,
                //                                               color: Colors.black)),
                //                                       hintText: 'Enter Email Address',
                //                                       hintStyle: GoogleFonts.aBeeZee(
                //                                           textStyle: TextStyle(
                //                                               fontSize: 14,
                //                                               color: Colors.black))),
                //                                 ),
                //                               ),
                //                             ),
                //                           ),
                //                         ],
                //                       ),
                //                     ),
                //

                //                   ],
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
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
      ),
    );
  }
}
