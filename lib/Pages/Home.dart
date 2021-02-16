import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opicxo/Common/Services.dart';
import 'package:opicxo/Components/AlbumComponent.dart';
import 'package:opicxo/Components/LoadinComponent.dart';
import 'package:opicxo/Components/NoDataComponent.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:opicxo/Common/Constants.dart' as cnst;

class Home extends StatefulWidget {
  String galleryId, galleryName, IsSelectionDone;

  //bool IsSelectionDone;

  Home(this.galleryId, this.galleryName, this.IsSelectionDone);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
    print("${widget.IsSelectionDone}");
  }

  updateGalleryStatus(String status) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        Future res = Services.UpdateGallrySelection(widget.galleryId, status);
        res.then((data) async {
          pr.hide();
          if (data.Data == "1") {
            setState(() {
              if (status == "true") {
                widget.IsSelectionDone = "true";
              } else {
                widget.IsSelectionDone = "false";
              }
            });
          } else {
            showMsg("Something Went Wrong Please Try Again.");
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
  }

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("PICTIK"),
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
        title: Text("${widget.galleryName}",
            style: GoogleFonts.aBeeZee(
                textStyle: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Colors.white))),
        centerTitle: true,
        actions: <Widget>[
          /*widget.IsSelectionDone == "true"
              ? Padding(
                  padding: const EdgeInsets.all(7),
                  child: GestureDetector(
                    onTap: () {
                      updateGalleryStatus("false");
                    },
                    child: Container(
                        //width: 80,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 6, right: 6, top: 0, bottom: 0),
                          child: Center(
                            child: Text(
                              "Cancel\nSelection",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ),
                        )),
                  ))
              : Padding(
                  padding: const EdgeInsets.all(7),
                  child: GestureDetector(
                    onTap: () {
                      updateGalleryStatus("true");
                    },
                    child: Container(
                        //width: 80,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 5, right: 5, top: 0, bottom: 0),
                          child: Center(
                            child: Text(
                              "Complate\nSelection",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ),
                        )),
                  ))*/
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                "images/back17.png",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder<List>(
                future: Services.GetCustomerAlbumList(widget.galleryId),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return snapshot.connectionState == ConnectionState.done
                      ? snapshot.data != null && snapshot.data.length > 0
                          ? ListView.builder(
                              padding: EdgeInsets.all(0),
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return AlbumComponent(snapshot.data[index]);
                              },
                            )
                          : NoDataComponent()
                      : LoadinComponent();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
