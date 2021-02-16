import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:opicxo/Common/Constants.dart';
import 'package:permission_handler/permission_handler.dart';

import 'CollageGallaryScreen.dart';
import 'fade_route_transition.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class Collage1Screen extends StatefulWidget {
  String albumId, albumName, totalImg;

  Collage1Screen({this.albumId, this.albumName, this.totalImg});

  @override
  _Collage1ScreenState createState() => _Collage1ScreenState();
}

class _Collage1ScreenState extends State<Collage1Screen> {
  var Image, Image1;
  GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        //backgroundColor: appPrimaryMaterialColor,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[
                appPrimaryMaterialColorYellow,
                appPrimaryMaterialColorPink
              ],
            ),
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  _saveScreen();
                },
                child: Container(
                    width: 80,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 3, right: 3, top: 2, bottom: 2),
                      child: Center(
                        child: Text(
                          "Save",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                    )),
              ))
        ],
        actionsIconTheme: IconThemeData.fallback(),
        title: Text(
          "Collage Image",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 3, right: 3),
        child: RepaintBoundary(
          key: _globalKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  var image = await Navigator.of(context).push(
                    FadeRouteTransition(
                        //  page: CollageSample(CollageType.VSplit)),
                        page: CollageGallaryScreen(
                      albumId: widget.albumId,
                      albumName: widget.albumName,
                      totalImg: widget.totalImg,
                    )),
                  );
                  setState(() {
                    Image = image;
                  });
                },
                child: Image == null
                    ? Container(
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.width / 2.1,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Icon(
                          Icons.add,
                          size: 25,
                        ),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.width / 2.1,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ClipRRect(
                          borderRadius: new BorderRadius.circular(5.0),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'images/logo1.png',
                            image: "${ImgUrl}${Image}",
                            fit: BoxFit.fill,
                          ),
                        )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 3.0),
                child: GestureDetector(
                  onTap: () async {
                    var image = await Navigator.of(context).push(
                      FadeRouteTransition(
                          //  page: CollageSample(CollageType.VSplit)),
                          page: CollageGallaryScreen(
                        albumId: widget.albumId,
                        albumName: widget.albumName,
                        totalImg: widget.totalImg,
                      )),
                    );
                    setState(() {
                      Image1 = image;
                    });
                  },
                  child: Image1 == null
                      ? Container(
                          height: MediaQuery.of(context).size.height / 2,
                          width: MediaQuery.of(context).size.width / 2.1,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Icon(
                            Icons.add,
                            size: 25,
                          ),
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height / 2,
                          width: MediaQuery.of(context).size.width / 2.1,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ClipRRect(
                            borderRadius: new BorderRadius.circular(5.0),
                            child: FadeInImage.assetNetwork(
                              placeholder: 'images/logo1.png',
                              image: "${ImgUrl}${Image1}",
                              fit: BoxFit.fill,
                            ),
                          )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _requestPermission() async {
    PermissionHandler().requestPermissions(<PermissionGroup>[
      PermissionGroup.storage,
    ]);

    final info = PermissionGroup.storage.toString();
    print(info);
    _toastInfo(info);
  }

  _saveScreen() async {
    if (Image != null && Image1 != null) {
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage();
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final result =
          await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());

      print(result);
      _toastInfo(result.toString());
    }
  }

  _toastInfo(String info) {
    Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
  }
}
