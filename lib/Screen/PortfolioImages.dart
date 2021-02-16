import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:opicxo/Common/Constants.dart' as cnst;
import 'package:opicxo/Common/Services.dart';
import 'package:opicxo/Components/NoDataComponent.dart';
import 'package:opicxo/Components/PortfolioImagesComponent.dart';
import 'package:opicxo/Screen/ImageView.dart';
import 'package:opicxo/Screen/PortfolioImageView.dart';

class PortfolioImages extends StatefulWidget {
  String galleryId, galleryName;

  PortfolioImages(this.galleryId, this.galleryName);

  @override
  _PortfolioImagesState createState() => _PortfolioImagesState();
}

class _PortfolioImagesState extends State<PortfolioImages> {
  List albumData = new List();
  bool isLoading = false;

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

  void initState() {
    //pr.setMessage('Please Wait');
    // TODO: implement initState
    super.initState();
    getAlbumAllData();
  }

  getAlbumAllData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isLoading = false;
        Future res = Services.GetCategoryAlbumAllData(widget.galleryId);
        res.then((data) async {
          if (data != null && data.length > 0) {
            isLoading = false;
            setState(() {
              albumData = data;
            });
            /*setState(() {
              selectedCount = data[0]["SelectedCount"].toString();
            });*/
          } else {
            isLoading = false;
            //showMsg("Try Again.");
            setState(() {
              albumData.clear();
            });
          }
        }, onError: (e) {
          isLoading = false;
          print("Error : on Login Call $e");
          setState(() {
            albumData.clear();
          });
          //showMsg("$e");
        });
      } else {
        isLoading = false;
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
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
        centerTitle: true,
        title: Text("${widget.galleryName}",style: GoogleFonts.aBeeZee(
            textStyle: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w600,
                color: Colors.white))),

      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: albumData.length != 0 && albumData != null
                  ? StaggeredGridView.countBuilder(
                      padding: const EdgeInsets.only(left: 3, right: 3, top: 5),
                      crossAxisCount: 4,
                      itemCount: albumData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return PortfolioImagesComponent(albumData[index], index,
                            (action, Id) {
                          if (action.toString() == "Show") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PortfolioImageView(
                                        albumData: albumData,
                                        albumIndex: index)));
                          }
                        });
                      },
                      staggeredTileBuilder: (_) => StaggeredTile.fit(2),
                      mainAxisSpacing: 3,
                      crossAxisSpacing: 3,
                    )
                  : NoDataComponent(),
            ),
    );
  }
}
