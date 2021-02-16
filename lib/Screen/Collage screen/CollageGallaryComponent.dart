import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:opicxo/Common/Constants.dart';
import 'package:opicxo/Common/Services.dart';

class CollageGallaryComponent extends StatefulWidget {
  var albumData;
  int index;
  String image;
  Function onChange;
  String SelectedPin;

  CollageGallaryComponent(this.albumData, this.index, this.onChange);
  @override
  _CollageGallaryComponentState createState() =>
      _CollageGallaryComponentState();
}

class _CollageGallaryComponentState extends State<CollageGallaryComponent> {
  bool downloading = false;

  Future<void> _downloadFile(String url) async {
    var file = url.split('/');

    Dio dio = Dio();
    try {
      var dir = await getExternalStorageDirectory();
      print("${dir.path}/${file[3].toString()}");
      await dio.download("${ImgUrl}${url.replaceAll(" ", "%20")}",
          "${dir.path}/${file[3].toString()}", onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");
        setState(() {
          downloading = true;
        });
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      downloading = false;
    });
  }

  shareFile(String ImgUrl) async {
    ImgUrl = ImgUrl.replaceAll(" ", "%20");
    if (ImgUrl.toString() != "null" && ImgUrl.toString() != "") {
      var request = await HttpClient().getUrl(Uri.parse("${ImgUrl}"));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      await Share.files(
          'ESYS AMLOG',
          {
            'esys.png': bytes,
          },
          'image/jpg');
    }
  }

  List selectedData = new List();

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Error"),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(color: appPrimaryMaterialColorPink),
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

  sendSelectImage(String isselected) async {
    try {
      selectedData.add({
        'Id': widget.albumData["Id"].toString(),
        'IsSelected': isselected.toString(),
      });
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Services.UploadSelectedImage(selectedData).then((data) async {
          if (data.Data == "1") {
            setState(() {
              //isselected=="true" ?
              // Fluttertoast.showToast(
              //     msg: "Image Saved Successfully.",
              //     toastLength: Toast.LENGTH_SHORT,
              //     backgroundColor: Colors.red,
              //     textColor: Colors.white,
              //     gravity: ToastGravity.TOP):
              // Fluttertoast.showToast(
              //     msg: "Image Removed Successfully.",
              //     toastLength: Toast.LENGTH_SHORT,
              //     backgroundColor: Colors.red,
              //     textColor: Colors.white,
              //     gravity: ToastGravity.TOP);
              //signUpDone("Image Saved Successfully.");
              selectedData.clear();
            });
          } else {
            showMsg(data.Message);
          }
        }, onError: (e) {
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
    return GestureDetector(
      onTap: () {
        //log("${widget.albumData["Id"].toString()}");
        Navigator.of(context)
            .pop("${widget.albumData["PhotoThumb"].toString()}");
        log("${widget.albumData["PhotoThumb"].toString()}");
        //   widget.onChange(
        //       "Show", widget.index, widget.albumData["Photo"].toString());
        // },
        // onLongPress: () {
        //   // onTap: () {
        //   if (widget.albumData["IsSelected"].toString() == "true") {
        //     sendSelectImage("false");
        //     setState(() {
        //       widget.albumData["IsSelected"] = "false";
        //     });
        //     widget.onChange("Remove", widget.albumData["Id"].toString(),
        //         widget.albumData["Photo"].toString());
        //   } else {
        //     sendSelectImage("true");
        //     setState(() {
        //       widget.albumData["IsSelected"] = "true";
        //     });
        //     widget.onChange("Add", widget.albumData["Id"].toString(),
        //         widget.albumData["Photo"].toString());
        //   }
      },
      child: Container(
        padding: widget.albumData["IsSelected"].toString() == "true"
            ? EdgeInsets.all(10)
            : EdgeInsets.all(0),
        child: Card(
          elevation: 3,
          margin: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            //side: BorderSide(color: appcolor)),
            side: BorderSide(width: 0.10, color: appPrimaryMaterialColorPink),
            borderRadius: BorderRadius.circular(
              10.0,
            ),
          ),
          child: Container(
            //padding: EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: new BorderRadius.circular(10.0),
              child: widget.albumData["Photo"] != null
                  ? FadeInImage.assetNetwork(
                      placeholder: 'images/logo1.png',
                      image: "${ImgUrl}${widget.albumData["PhotoThumb"]}",
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.blue[100],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
