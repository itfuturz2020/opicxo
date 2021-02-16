import 'dart:io';
import 'dart:typed_data';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:opicxo/Common/Constants.dart' as cnst;

class GuestPortfolioImagesComponent extends StatefulWidget {
  var albumData;
  int index;
  Function onChange;

  GuestPortfolioImagesComponent(this.albumData, this.index, this.onChange);

  @override
  _GuestPortfolioImagesComponentState createState() =>
      _GuestPortfolioImagesComponentState();
}

class _GuestPortfolioImagesComponentState
    extends State<GuestPortfolioImagesComponent> {
  bool downloading = false;

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChange("Show", widget.index);
      },
      child: Container(
        padding: EdgeInsets.all(0),
        child: Card(
          elevation: 3,
          margin: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            //side: BorderSide(color: cnst.appcolor)),
            side: BorderSide(
                width: 0.10, color: cnst.appPrimaryMaterialColorPink),
            borderRadius: BorderRadius.circular(
              10.0,
            ),
          ),
          child: Container(
            //padding: EdgeInsets.all(10),
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: new BorderRadius.circular(10.0),
                  child: widget.albumData["Image"] != null
                      ? FadeInImage.assetNetwork(
                          placeholder: 'images/No_photo.png',
                          image:
                              "${cnst.ImgUrl}${widget.albumData["ImageThumb"]}",
                          fit: BoxFit.cover,
                          //height: MediaQuery.of(context).size.height / 1.7,
                          width: MediaQuery.of(context).size.width,
                        )
                      /*Image(
                      image: NetworkToFileImage(
                          url:
                          "${cnst.ImgUrl}${widget.albumData["Image"]}",
                          debug: true,
                          file: compressedFile))*/
                      : Image.asset(
                          'images/No_photo.png',
                          fit: BoxFit.fill,
                          //height: MediaQuery.of(context).size.height / 1.7,
                          width: MediaQuery.of(context).size.width,
                        ),
                ),
                /*GestureDetector(
                  onTap: () {
                    if (widget.albumData["IsSelected"].toString() == "true") {
                      setState(() {
                        widget.albumData["IsSelected"] = "false";
                      });
                      widget.onChange(
                          "Remove", widget.albumData["Id"].toString());
                    } else {
                      setState(() {
                        widget.albumData["IsSelected"] = "true";
                      });
                      widget.onChange("Add", widget.albumData["Id"].toString());
                    }
                  },
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: widget.albumData["IsSelected"].toString() == "true"
                        ? Container(
                      margin: EdgeInsets.all(5),
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: cnst.appPrimaryMaterialColorPink,
                          border: Border.all(
                              color: cnst.appPrimaryMaterialColorPink,
                              width: 2)),
                      child: Icon(Icons.check),
                    )
                        : Container(
                      margin: EdgeInsets.all(5),
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.6),
                          border:
                          Border.all(color: Colors.white, width: 2)),
                    ),
                  ),
                ),*/
                /*GestureDetector(
                  onTap: () {
                    _downloadFile(widget.albumData["Image"]);
                  },
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      margin: EdgeInsets.all(5),
                      height: 27,
                      width: 27,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      child: downloading == true
                          ? Container(
                        child: CircularProgressIndicator(),
                      )
                          : Icon(
                        Icons.file_download,
                        size: 17,
                      ),
                    ),
                  ),
                ),*/
                GestureDetector(
                  onTap: () {
                    shareFile(
                        "${cnst.ImgUrl}${widget.albumData["Image"].toString()}");
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: EdgeInsets.all(5),
                      height: 27,
                      width: 27,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      child: Icon(
                        Icons.share,
                        size: 17,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
