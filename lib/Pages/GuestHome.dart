import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:opicxo/Common/Services.dart';
import 'package:opicxo/Components/GuestPortfolioComponents.dart';
import 'package:opicxo/Components/LoadinComponent.dart';
import 'package:opicxo/Components/NoDataComponent.dart';
import 'package:opicxo/Common/Constants.dart' as cnst;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuestHome extends StatefulWidget {
  @override
  _GuestHomeState createState() => _GuestHomeState();
}

class _GuestHomeState extends State<GuestHome> {
  List NewList = [];
  ProgressDialog pr;
  bool isLoading = true;

  /* @override
  void initState() {
    _GetGuestPortfolioList();
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
*/
  /*_GetGuestPortfolioList() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String id =
        await preferences.getString(cnst.Session.GalleryId);
        //print("yyy=> " + preferences.getString(cnst.Session.GalleryId));
        Future res = Services.GetGuestPortfolioList(id);
        setState(() {
          isLoading = true;
        });

        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              NewList = data;
              isLoading = false;
            });
          } else {
            setState(() {
              NewList = [];
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : on NewLead Data Call $e");
          showMsg("$e");
        });
      } else {
        showMsg("Something went Wrong!");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }*/

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

  bool dialVisible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder<List>(
              future: Services.GetportfolioGalleryList(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return snapshot.connectionState == ConnectionState.done
                    ? snapshot.data != null && snapshot.data.length > 0
                        ? StaggeredGridView.countBuilder(
                            padding: const EdgeInsets.only(
                                left: 3, right: 3, top: 5),
                            itemCount: snapshot.data.length,
                            //shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            crossAxisCount: 4,
                            addRepaintBoundaries: false,
                            staggeredTileBuilder: (_) => StaggeredTile.fit(2),
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 2,
                            itemBuilder: (BuildContext context, int index) {
                              return GuestPortfolioComponents(
                                  snapshot.data[index]);
                            },
                          )
                        : NoDataComponent()
                    : LoadinComponent();
              },
            ),
          ),
        ],
      ),
      /*floatingActionButton: SpeedDial(
        // both default to 16
        marginRight: 15,

        marginBottom:18,
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
        foregroundColor: Colors.white,
        //child: Icon(Icons.add),
        elevation: 4.0,
        shape: CircleBorder(),
        children: [
          */ /*SpeedDialChild(
              child: Icon(Icons.access_time),
              backgroundColor: Colors.deepPurple,
              label: 'Book Appointment',
              labelStyle: TextStyle(fontSize: 17.0),
              onTap: () {
                Navigator.pushNamed(context, '/BookAppointment');
              }),*/ /*
          */ /*SpeedDialChild(
                child: Icon(Icons.accessibility),
                backgroundColor: Colors.red,
                label: 'Add Customer',
                labelStyle: TextStyle(fontSize: 17.0),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/AddCustomer');
                }),
            SpeedDialChild(
                child: Icon(Icons.brush),
                backgroundColor: Colors.blue,
                label: 'View Portfolio',
                labelStyle: TextStyle(fontSize: 17.0),
                onTap: () {
                  Navigator.pushNamed(context, '/PortfolioScreen');
                }),*/ /*
          SpeedDialChild(
            child: Icon(Icons.link),
            backgroundColor: Colors.green,
            label: 'Social Link',
            labelStyle: TextStyle(fontSize: 17.0),
            onTap: () {
              Navigator.pushNamed(context, '/SocialLink');
            },
          ),
        ],
      ),*/
    );
  }
}
