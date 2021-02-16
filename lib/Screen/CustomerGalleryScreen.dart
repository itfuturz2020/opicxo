import 'dart:developer';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opicxo/Common/Constants.dart';
import 'package:opicxo/Common/Services.dart';
import 'package:opicxo/Components/CustomerGalleryComponent.dart';
import 'package:opicxo/Components/LoadinComponent.dart';
import 'package:opicxo/Components/NoDataComponent.dart';
import 'package:opicxo/Common/Constants.dart' as cnst;
import 'package:shared_preferences/shared_preferences.dart';

import 'OfferDetailScreen.dart';
import 'PortfolioImages.dart';

class CustomerGallery extends StatefulWidget {
  CustomerGallery();

  @override
  _CustomerGalleryState createState() => _CustomerGalleryState();
}

class _CustomerGalleryState extends State<CustomerGallery> {
  DateTime currentBackPressTime;
  TextEditingController name = new TextEditingController();
  TextEditingController mobile = new TextEditingController();
  TextEditingController email = new TextEditingController();
  bool dialVisible = true;
  bool isLoading = true;
  String SelectedPin = "";
  List _advertisementData = new List();
  final _formKey = GlobalKey<FormState>();
  List PhotographerList = [],
      PhotographerListData = [],
      maindata = [],
      PortfolioData = [],
      bothdata1 = [],
      bothdata2 = [],
      bothdata = [];
  int _current = 0, offercurrent = 0, portfoliocurrent = 0;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    GetPhotogrpaherOffers();
    GetPortfolioData();
    // dataaddedd();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  // var data = "";
  //
  // dataaddedd() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   data = preferences.getString(cnst.Session.dataaddedd);
  //   print("data main");
  //   print(data);
  //   print("dataaddedd");
  //   print(cnst.Session.dataaddedd);
  //   if (data == null && cnst.Session.dataaddedd == "false") {
  //     adddata();
  //   } else {
  //     return;
  //   }
  // }

  // adddata() {
  //   showDialog(
  //     context: context,
  //     // barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: new Text("Add Details"),
  //         content: Container(
  //           width: MediaQuery.of(context).size.width * 0.9,
  //           height: MediaQuery.of(context).size.height * 0.4,
  //           child: Form(
  //             key: _formKey,
  //             child: Column(
  //               children: [
  //                 TextFormField(
  //                   decoration: InputDecoration(
  //                     hintText: "Name",
  //                   ),
  //                   controller: name,
  //                   validator: (value) {
  //                     if (value.isEmpty) {
  //                       return 'Please enter your name';
  //                     }
  //                     return null;
  //                   },
  //                 ),
  //                 TextFormField(
  //                   decoration: InputDecoration(
  //                     hintText: "Mobile No.",
  //                   ),
  //                   keyboardType: TextInputType.number,
  //                   controller: mobile,
  //                   validator: (value) {
  //                     if (value.length != 10) {
  //                       return "please enter valid mobile number";
  //                     }
  //                     return null;
  //                   },
  //                 ),
  //                 TextFormField(
  //                   decoration: InputDecoration(
  //                     hintText: "Email Id",
  //                   ),
  //                   controller: email,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         actions: <Widget>[
  //           new FlatButton(
  //             child: new Text("Submit"),
  //             onPressed: () {
  //               if (_formKey.currentState.validate()) {
  //                 getUserData();
  //                 Navigator.of(context).pop();
  //               }
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  getAdvertisementData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetAllAdvertisement();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              _advertisementData = data;
              isLoading = false;
            });
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

  var studioId;

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

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  String photographerId = "";

  GetPhotogrpaherOffers() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      photographerId = prefs.getString(Session.StudioId);
      print(photographerId);
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetPhotogrpaherOffers(photographerId.toString());
        res.then((data) async {
          if (data != null && data.length > 0) {
            PhotographerListData = data;
            List images = data;
            for (int i = 0; i < images.length; i++) {
              setState(() {
                PhotographerList.add(images[i]["Image"]);
              });
            }
            bothdata1 = PhotographerListData;
            offercurrent = PhotographerList.length + 1;
            print("PhotographerList");
            print(PhotographerList);
          } else {
            setState(() {
              PhotographerList.clear();
            });
            //showMsg("Try Again.");
          }
        }, onError: (e) {
          print("Error : on Login Call $e");
          //showMsg("$e");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  GetPortfolioData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetportfolioGalleryList();
        res.then((data) async {
          if (data.length > 0) {
            PortfolioData = data;
            // for(int i=0;i<PortfolioData.length;i++) {
            //   bothdata.add("http://pictick.itfuturz.com/" + PortfolioData[i]["Image"]);
            // }
            bothdata2 = PortfolioData;
            portfoliocurrent = PortfolioData.length + 1;
            print("PortfolioData");
            print(PortfolioData);
            print("bothdata2");
            print(bothdata2);
          } else {
            setState(() {
              PortfolioData.clear();
            });
            //showMsg("Try Again.");
          }
        }, onError: (e) {
          print("Error : on Login Call $e");
          //showMsg("$e");
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
    bothdata = bothdata1 + bothdata2;
    print("PhotographerList");
    print(PhotographerList.length);
    print("PortfolioData");
    print(PortfolioData.length);
    print("bothdata1");
    print(bothdata1.length);
    print("bothdata2");
    print(bothdata2.length);
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SpeedDial(
            // both default to 16
            marginRight: 8,
            marginBottom: 10,
            animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme: IconThemeData(
              size: 22.0,
            ),
            // this is ignored if animatedIcon is non null
            // child: Icon(Icons.add),
            visible: dialVisible,
            // If true user is forced to close dial manually
            // by tapping main button and overlay is not rendered.
            closeManually: false,
            curve: Curves.bounceIn,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            onOpen: () => print('OPENING DIAL'),
            onClose: () => print('DIAL CLOSED'),
            //tooltip: 'Speed Dial',
            //heroTag: 'speed-dial-hero-tag',
            backgroundColor: cnst.appPrimaryMaterialColorYellow,
            foregroundColor: Colors.black,
            //child: Icon(Icons.add),
            elevation: 4.0,
            shape: CircleBorder(),
            children: [
              /* SpeedDialChild(
                child: Icon(Icons.access_time),
                backgroundColor: Colors.deepPurple,
                label: '000Book Appointment',
                labelStyle: TextStyle(fontSize: 17.0),
                onTap: () {
                  Navigator.pushNamed(context, '/BookAppointment');
                }),*/
              SpeedDialChild(
                  child: Icon(Icons.accessibility),
                  backgroundColor: Colors.red,
                  label: 'Share App',
                  labelStyle: GoogleFonts.aBeeZee(
                    textStyle: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/MyCustomer');
                  }),
              SpeedDialChild(
                  child: Icon(Icons.brush),
                  backgroundColor: Colors.blue,
                  label: 'View Portfolio',
                  labelStyle: GoogleFonts.aBeeZee(
                    textStyle: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/PortfolioScreen');
                  }),
              SpeedDialChild(
                child: Icon(Icons.link),
                backgroundColor: Colors.green,
                label: 'Social Link',
                labelStyle: GoogleFonts.aBeeZee(
                  textStyle: TextStyle(
                    fontSize: 17,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/SocialLink');
                },
              ),
              SpeedDialChild(
                child: Icon(Icons.add_location),
                backgroundColor: Colors.teal,
                label: 'Branches',
                labelStyle: TextStyle(fontSize: 17.0),
                onTap: () {
                  Navigator.pushNamed(context, '/StudioLocation');
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                child: Opacity(
                  opacity: 0.2,
                  child: Image.asset(
                    "images/back002.png",
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 15.0, left: 15, top: 15),
                      child: Column(
                        children: [
                          PhotographerList.length > 0 &&
                                  PortfolioData.length > 0
                              ? CarouselSlider(
                                  height: 180,
                                  viewportFraction: 0.9,
                                  autoPlayAnimationDuration:
                                      Duration(milliseconds: 1500),
                                  reverse: false,
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  autoPlay: true,
                                  onPageChanged: (index) {
                                    _current = index;
                                  },
                                  items: bothdata.map((i) {
                                    print(i);
                                    return Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.30,
                                      width: MediaQuery.of(context).size.width,
                                      child: GestureDetector(
                                        onTap: () {
                                          print(i["isOffers"]);
                                          Navigator.push(
                                            context,
                                            (i["isOffers"]) == "true"
                                                ? MaterialPageRoute(
                                                    builder: (context) =>
                                                        OfferDetailScreen(
                                                      PhotographerListData: i,
                                                      current: 0,
                                                    ),
                                                  )
                                                : MaterialPageRoute(
                                                    builder: (context) =>
                                                        PortfolioImages(
                                                      i["Id"].toString(),
                                                      i["Title"].toString(),
                                                    ),
                                                  ),
                                          );
                                        },
                                        child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            //color: Colors.blueAccent,
                                            child: Image.network(
                                              i["Image"],
                                              fit: BoxFit.fill,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.78,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.25,
                                            )
                                            //     :
                                            // FadeInImage.assetNetwork(
                                            //   placeholder: 'images/logo1.png',
                                            //   //image:"${i[_current]["${cnst.ImgUrl}"]["Image"]}",
                                            //   image: "${cnst.ImgUrl}${i["Image"]}",
                                            //   fit: BoxFit.cover,
                                            // ),
                                            ),
                                      ),
                                    );
                                  }).toList(),
                                )
                              : PhotographerList.length > 0 &&
                                      PortfolioData.length == 0
                                  ? CarouselSlider(
                                      height: 180,
                                      viewportFraction: 0.9,
                                      autoPlayAnimationDuration:
                                          Duration(milliseconds: 1500),
                                      reverse: false,
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      autoPlay: true,
                                      onPageChanged: (index) {
                                        _current = index;
                                      },
                                      items: bothdata1.map((i) {
                                        return Builder(
                                            builder: (BuildContext context) {
                                          return Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.30,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            OfferDetailScreen(
                                                                PhotographerListData:
                                                                    i,
                                                                current: 0)));
                                              },
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                //color: Colors.blueAccent,
                                                child: Image.network(
                                                  i["Image"],
                                                  fit: BoxFit.fill,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.78,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.25,
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                      }).toList(),
                                    )
                                  : PhotographerList.length == 0 &&
                                          PortfolioData.length > 0
                                      ? CarouselSlider(
                                          height: 180,
                                          viewportFraction: 0.9,
                                          autoPlayAnimationDuration:
                                              Duration(milliseconds: 1500),
                                          reverse: false,
                                          autoPlayCurve: Curves.fastOutSlowIn,
                                          autoPlay: true,
                                          onPageChanged: (index) {
                                            _current = index;
                                          },
                                          items: bothdata2.map((i) {
                                            return Builder(builder:
                                                (BuildContext context) {
                                              return Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.30,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                PortfolioImages(
                                                                    i["Id"]
                                                                        .toString(),
                                                                    i["Title"]
                                                                        .toString())));
                                                  },
                                                  child: Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    //color: Colors.blueAccent,
                                                    child: FadeInImage
                                                        .assetNetwork(
                                                      placeholder:
                                                          'images/logo1.png',
                                                      image: "${i["Image"]}",
                                                      fit: BoxFit.cover,
                                                    ),
                                                    // Image.network(
                                                    //   "${i}",
                                                    //   fit: BoxFit.fill,
                                                    //   width: MediaQuery.of(context).size.width*0.78,
                                                    //   height: MediaQuery.of(context).size.height*0.25,
                                                    // ),
                                                  ),
                                                ),
                                              );
                                            });
                                          }).toList(),
                                        )
                                      : Container(
                                          height: 150,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            //color: Colors.blueAccent,
                                            child: Center(
                                              child: Text(
                                                "No Data Found",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: 1,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: 1,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: 1,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    WillPopScope(
                      onWillPop: onWillPop,
                      child: FutureBuilder<List>(
                        future: Services.GetCustomerGalleryList(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          maindata = snapshot.data;
                          return snapshot.connectionState ==
                                  ConnectionState.done
                              ? snapshot.data != null &&
                                      snapshot.data.length > 0
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.all(0),
                                      itemCount: maindata.length,
                                      //shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GalleryComponent(
                                            maindata[index]);
                                      },
                                    )
                                  : NoDataComponent()
                              : LoadinComponent();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
