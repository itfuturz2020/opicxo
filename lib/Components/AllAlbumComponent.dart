import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:opicxo/Common/Constants.dart' as cnst;
import 'package:opicxo/Common/Constants.dart';
import 'package:opicxo/Common/Services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoadinComponent.dart';
import 'NoDataComponent.dart';
import 'PhotoCommentConponent.dart';

class AllAlbumComponent extends StatefulWidget {
  var albumData;
  int index;
  Function onChange;
  String selectedCount = "";

  AllAlbumComponent(this.albumData, this.index, this.onChange,
      {this.selectedCount});

  @override
  _AllAlbumComponentState createState() => _AllAlbumComponentState();
}

class _AllAlbumComponentState extends State<AllAlbumComponent> {
  bool downloading = false;
  String imageData;

  List selectedData = new List();

  Future<void> _downloadFile(String url) async {
    var url = "https://www.tottus.cl/static/img/productos/20104355_2.jpg";
    var response = await get(url);
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = documentDirectory.path + "/images";
    var filePathAndName = documentDirectory.path + '/images/pic.jpg';
    await Directory(firstPath).create(recursive: true);
    File file2 = new File(filePathAndName);
    file2.writeAsBytesSync(response.bodyBytes);
    setState(() {
      imageData = filePathAndName;
      downloading = true;
    });
  }

  _getHttp(String url) async {
    var response = await Dio()
        .get("${url}", options: Options(responseType: ResponseType.bytes));
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print(result);
  }

  _saveNetworkImage(String url) async {
    print('URl = ${url}');
    setState(() {
      downloading = true;
    });
    String path = '${url}';
    GallerySaver.saveImage(path).then((bool success) {
      print("Success = ${success}");
      setState(() {
        print('Image is saved');
        downloading = false;
        Fluttertoast.showToast(
            msg: "Download Complete",
            gravity: ToastGravity.TOP,
            toastLength: Toast.LENGTH_SHORT);
      });
    });
  }

  shareFile(String ImgUrl) async {
    var request = await HttpClient().getUrl(Uri.parse(
        'https://shop.esys.eu/media/image/6f/8f/af/amlog_transport-berwachung.jpg'));
    var response = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(response);

    var request1 = await HttpClient().getUrl(Uri.parse(
        'https://shop.esys.eu/media/image/6f/8f/af/amlog_transport-berwachung.jpg'));
    var response1 = await request1.close();
    Uint8List bytes1 = await consolidateHttpClientResponseBytes(response1);

    var request2 = await HttpClient().getUrl(Uri.parse(
        'https://shop.esys.eu/media/image/6f/8f/af/amlog_transport-berwachung.jpg'));
    var response2 = await request2.close();
    Uint8List bytes2 = await consolidateHttpClientResponseBytes(response2);

    await Share.files(
        'esys images',
        {
          'esys.png': bytes,
          'bluedan.png': bytes1,
          'addresses.png': bytes2,
        },
        '*/*',
        text: 'My optional text.');
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
              child: new Text(
                "Close",
                style: TextStyle(color: cnst.appPrimaryMaterialColorPink),
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

  Function onComment;
  onCommentFunction(value) {
    switch (value) {
      case 0:
        onComment = widget.onChange;
        return onComment;
        break;
    }
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => BottomSheet(
        Data: widget.albumData,
        onComment: onCommentFunction(0),
        index: widget.index,
      ),
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
        widget.onChange(
            "Show", widget.index, widget.albumData["Photo"].toString());
      },
      onLongPress: () {
        if (widget.albumData["IsSelected"].toString() == "true") {
          sendSelectImage("false");
          setState(() {
            widget.albumData["IsSelected"] = "false";
          });
          widget.onChange("Remove", widget.albumData["Id"].toString(),
              widget.albumData["Photo"].toString());
        } else {
          sendSelectImage("true");
          setState(() {
            widget.albumData["IsSelected"] = "true";
          });
          widget.onChange("Add", widget.albumData["Id"].toString(),
              widget.albumData["Photo"].toString());
        }
      },
      child: Container(
        padding: widget.albumData["IsSelected"].toString() == "true"
            ? EdgeInsets.all(10)
            : EdgeInsets.all(0),
        child: Card(
          elevation: 3,
          margin: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            side: BorderSide(
                width: 0.10, color: cnst.appPrimaryMaterialColorPink),
            borderRadius: BorderRadius.circular(
              10.0,
            ),
          ),
          child: Container(
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: new BorderRadius.circular(10.0),
                  child: widget.albumData["Photo"] != null
                      ? FadeInImage.assetNetwork(
                          placeholder: 'images/icon_events.jpg',
                          image:
                              "${cnst.ImgUrl}${widget.albumData["PhotoThumb"]}",
                          fit: BoxFit.cover,
                          //height: MediaQuery.of(context).size.height / 1.7,
                          width: MediaQuery.of(context).size.width,
                        )
                      : Image.asset(
                          'images/icon_events.jpg',
                          fit: BoxFit.fill,
                          //height: MediaQuery.of(context).size.height / 1.7,
                          width: MediaQuery.of(context).size.width,
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            if (widget.albumData["IsSelected"].toString() ==
                                "true") {
                              sendSelectImage("false");
                              setState(() {
                                widget.albumData["IsSelected"] = "false";
                              });
                              widget.onChange(
                                  "Remove",
                                  widget.albumData["Id"].toString(),
                                  widget.albumData["Photo"].toString());
                            } else {
                              sendSelectImage("true");
                              setState(() {
                                widget.albumData["IsSelected"] = "true";
                              });
                              widget.onChange(
                                  "Add",
                                  widget.albumData["Id"].toString(),
                                  widget.albumData["Photo"].toString());
                            }
                          },
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: widget.albumData["IsSelected"].toString() ==
                                    "true"
                                ? Container(
                                    margin: EdgeInsets.all(5),
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: cnst.appPrimaryMaterialColorPink,
                                        border: Border.all(
                                            color: cnst
                                                .appPrimaryMaterialColorPink,
                                            width: 2)),
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 19,
                                    ),
                                  )
                                : Container(
                                    margin: EdgeInsets.all(5),
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withOpacity(0.6),
                                        border: Border.all(
                                            color: Colors.white, width: 2)),
                                  ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _settingModalBottomSheet(context);
                          },
                          child: Container(
                            margin: EdgeInsets.all(5),
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: cnst.appPrimaryMaterialColorYellow,
                            ),
                            child: Icon(Icons.chat_bubble_outline,
                                size: 15, color: Colors.white),
                          ),
                        ),
                        /*GestureDetector(
                                  onTap: () {
                                    */ /*_downloadFile(widget.albumData["Photo"]
                                        .toString()
                                        .replaceAll(" ", "%20"));*/ /*
                                    _getHttp(
                                        "${cnst.ImgUrl}${widget.albumData["Photo"].toString().replaceAll(" ", "%20")}");
                                    //_getHttp();
                                    //_saveNetworkImage("${cnst.ImgUrl}${widget.albumData["Photo"].toString().replaceAll(" ", "%20")}");
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    height: 30,
                                    width: 30,
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
                          GestureDetector(
                            onTap: () {
                              shareFile(
                                  "${cnst.ImgUrl}${widget.albumData["Photo"].toString()}");
                            },
                            child: Container(
                              margin: EdgeInsets.all(5),
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.7),
                              ),
                              child: Icon(
                                Icons.share,
                                size: 17,
                              ),
                            ),
                          ),*/
                      ],
                    )
                  ],
                ),
                //  widget.albumData["IsSelected"].toString() ==
                //     "true"
                //     ?  Container(
                //  // margin: EdgeInsets.all(5),
                //   height: 20,
                //   width: 20,
                //   decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       color: cnst.appPrimaryMaterialColorPink,
                //       border: Border.all(
                //           color: cnst
                //               .appPrimaryMaterialColorPink,
                //           width: 2)),
                //   child: Icon(
                //     Icons.check,
                //     color: Colors.orangeAccent,
                //     size: 19,
                //   ),
                // ):
                // Container(
                //         margin: EdgeInsets.all(5),
                //         height: 20,
                //         width: 20,
                //         decoration: BoxDecoration(
                //             shape: BoxShape.circle,
                //             color: Colors.grey,
                //             border: Border.all(
                //                 color: Colors.grey, width: 1)),
                //       ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomSheet extends StatefulWidget {
  Function onComment;
  var Data;
  int index;

  BottomSheet({this.Data, this.onComment, this.index});

  @override
  _BottomSheetState createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  String paymentMethod = "";
  String _Fromtime = "From Time";
  String _Totime = "To Time";
  TextEditingController edtComment = new TextEditingController();

  DateTime FromDate, ToDate;
  List CommentList = new List();
  ProgressDialog pr;
  bool IsLoading = true;

  String CustomerId = "", studioname = "";

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

    // TODO: implement initState
    super.initState();
    getCommentData();
  }

  getCommentData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      CustomerId = prefs.getString(Session.CustomerId);
      studioname = prefs.getString(cnst.Session.StudioName);
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          IsLoading = true;
        });
        Future res = Services.GetImageComment(widget.Data["Id"].toString());
        res.then((data) async {
          if (data != null && data.length > 0) {
            pr.hide();
            setState(() {
              CommentList = data;
              IsLoading = false;
            });
            print("commentlist");
            print(CommentList);
          } else {
            pr.hide();
            setState(() {
              CommentList.clear();
              IsLoading = false;
            });
            //showMsg("Try Again.");
          }
        }, onError: (e) {
          pr.hide();
          setState(() {
            IsLoading = false;
          });
          print("Error : on Login Call $e");
          //showMsg("$e");
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
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //send More Info to server
  sendRequestBookingFn() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String CustomerId = prefs.getString(Session.CustomerId);
        print(studioname);
        var data1 = {
          'Id': "0",
          'CustomerId': CustomerId,
          'AlbumPhotoId': widget.Data["Id"].toString(),
          'Comment': edtComment.text.toString().trim(),
          'Name': studioname,
        };
        Services.AddComment(data1).then((data) async {
          pr.hide();
          if (data.Data == "1") {
            setState(() {
              CommentList.add(data1);
              widget.Data["IsSelected"] = "true";
            });
            widget.onComment("Add", widget.Data["Id"].toString(),
                widget.Data["Photo"].toString());
            print("data1");
            print(data1);
            Navigator.of(context).pop();
            Fluttertoast.showToast(
                msg: "Comment Added Successfully",
                backgroundColor: cnst.appPrimaryMaterialColorYellow,
                textColor: Colors.white,
                gravity: ToastGravity.TOP,
                toastLength: Toast.LENGTH_SHORT);
            Navigator.of(context).pop();
          } else {
            pr.hide();
          }
        }, onError: (e) {
          pr.hide();
          showMsg("Try Again.");
        });
      } else {
        pr.hide();
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  deleteComment(String id, int index) async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        Future res = Services.DeleteComment(id);
        res.then((data) async {
          if (data.Data.toString() == "1") {
            setState(() {
              pr.hide();
              CommentList.removeAt(index);
              //widget.onChange("cancel");
            });
            showMsg("Comment Deleted Successfully");
          } else {
            pr.hide();
            showMsg(data.Message);
          }
        }, onError: (e) {
          print("Error : on Login Call $e");
          pr.hide();
          showMsg("Try Again.");
        });
      } else {
        pr.hide();
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  signUpDone(String msg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Okay",
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

  sendSelectImage() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Services.UploadSelectedImage([widget.Data["Id"].toString()]).then(
            (data) async {
          print("data.Data");
          print(data.Data);
          if (data.Data == "1") {
            setState(() {
              signUpDone("Image Saved Successfully.");
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
    print("widget.data");
    print(widget.Data);
    return SafeArea(
      child: Container(
        //height: 500,
        padding: EdgeInsets.only(
            top: 30, bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(right: 5),
                width: MediaQuery.of(context).size.width,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.close,
                    size: 30,
                  ),
                ),
              ),
            ),
            Expanded(
                child: IsLoading
                    ? LoadinComponent()
                    : CommentList.length > 0
                        ? ListView.builder(
                            padding: EdgeInsets.all(0),
                            itemCount: CommentList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return PhotoCommentConponent(
                                  CommentList[index], CustomerId, (action, id) {
                                if (action == "delete") {
                                  deleteComment(id, index);
                                }
                              });
                            },
                          )
                        : NoDataComponent()),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    height: 60,
                    child: TextFormField(
                      controller: edtComment,
                      scrollPadding: EdgeInsets.all(0),
                      decoration: InputDecoration(
                        filled: true,
                        border: InputBorder.none,
                        fillColor: Colors.black.withOpacity(0.1),
                        hintStyle: TextStyle(fontSize: 15, color: Colors.black),
                        hintText: "Enter Comment",
                      ),
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  width: 60,
                  height: 45,
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(top: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(100)),
                    color: cnst.appPrimaryMaterialColorPink,
                    onPressed: () {
                      if (edtComment.text != "") {
                        sendRequestBookingFn();
                      } else {
                        Fluttertoast.showToast(
                            msg: "Enter Comment",
                            backgroundColor: cnst.appPrimaryMaterialColorYellow,
                            textColor: Colors.white,
                            gravity: ToastGravity.TOP,
                            toastLength: Toast.LENGTH_SHORT);
                      }
                    },
                    child: Icon(
                      Icons.send,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
