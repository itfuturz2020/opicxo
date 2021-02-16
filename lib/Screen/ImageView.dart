import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

import 'package:opicxo/Common/Constants.dart';
import 'package:opicxo/Common/Constants.dart' as cnst;
import 'package:opicxo/Common/Services.dart';
import 'package:opicxo/Components/LoadinComponent.dart';
import 'package:opicxo/Components/NoDataComponent.dart';
import 'package:opicxo/Components/PhotoCommentConponent.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AlbumAllImages.dart';

class ImageView extends StatefulWidget {
  List albumData;
  int albumIndex;
  String TotalImg;
  Function onChange;

  ImageView({this.albumData, this.albumIndex, this.onChange});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  bool downloading = false;
  Function onComment;
  ProgressDialog pr;
  String SelectedPin = "", PinSelection = "";

  TextEditingController edtPIN = new TextEditingController();

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
    getLocalData();
    super.initState();
  }

  getLocalData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      SelectedPin = preferences.getString(Session.SelectedPin);
      PinSelection = preferences.getString(Session.PinSelection);
    });
  }

  Future<void> _downloadFile(String url) async {
    var file = url.split('/');

    Dio dio = Dio();
    try {
      var dir = await getExternalStorageDirectory();
      print("${dir.path}/${file[3].toString()}");
      print("demo  --> " +
          "http://pictick.itfuturz.com/${url.replaceAll(" ", "%20")}");
      Platform.isIOS
          ? await GallerySaver.saveImage(
                  "http://pictick.itfuturz.com/${url.replaceAll(" ", "%20")}")
              .then((bool success) {
              print("Success = ${success}");

              Fluttertoast.showToast(
                  backgroundColor: cnst.appPrimaryMaterialColorYellow,
                  msg: "Download Completed",
                  gravity: ToastGravity.TOP,
                  toastLength: Toast.LENGTH_SHORT);
            })
          : await downloadAndroid(
              "http://pictick.itfuturz.com/${url.replaceAll(" ", "%20")}");
      /*await dio.download(
          "http://pictick.itfuturz.com/${url.replaceAll(" ", "%20")}",
          "${dir.path}/${file[3].toString()}", onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");
        setState(() {
          downloading = true;
        });
      });*/
    } catch (e) {
      print(e);
    }
    setState(() {
      downloading = false;
    });
  }

  /*Future<void> _downloadFile(String url) async {
    var file = url.split('/');

    Dio dio = Dio();
    try {
      var dir;
      dir = await getExternalStorageDirectory();
      print("${dir.path}/${file[3].toString()}");
      await dio.download("${cnst.ImgUrl}${url.replaceAll(" ", "%20")}",
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
  }*/

  shareFile(String ImgUrl) async {
    if (ImgUrl.toString() != "null" && ImgUrl.toString() != "") {
      var request = await HttpClient().getUrl(Uri.parse(ImgUrl));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      await Share.files(
          'ESYS AMLOG',
          {
            'esys.png': bytes,
          },
          'image/jpg');
      if (widget.albumData[widget.albumIndex]["IsSelected"].toString() ==
          "true") {
        setState(() {
          widget.albumData[widget.albumIndex]["IsSelected"] = "false";
        });
        widget.onChange(
            "Remove",
            widget.albumData[widget.albumIndex]["Id"].toString(),
            widget.albumData[widget.albumIndex]["Photo"].toString());
      } else {
        setState(() {
          widget.albumData[widget.albumIndex]["IsSelected"] = "true";
        });
        widget.onChange(
            "Add",
            widget.albumData[widget.albumIndex]["Id"].toString(),
            widget.albumData[widget.albumIndex]["Photo"].toString());
      }
    }
  }

  // shareFile(String ImgUrl) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString(Session.PinSelection, "true");
  //   widget.onChange("getData");
  //   if (ImgUrl.toString() != "null" && ImgUrl.toString() != "") {
  //     var request = await HttpClient().getUrl(Uri.parse(ImgUrl));
  //     var response = await request.close();
  //     Uint8List bytes = await consolidateHttpClientResponseBytes(response);
  //     await Share.files(
  //         'ESYS AMLOG',
  //         {
  //           'esys.png': bytes,
  //         },
  //         'image/jpg');
  //   }
  // }
  //  Future<void> _downloadFile(String url) async {
  //   var file = url.split('/');
  //
  //   Dio dio = Dio();
  //   try {
  //     var dir = await getExternalStorageDirectory();
  //     print("${dir.path}/${file[3].toString()}");
  //     await dio.download(
  //         "http://instaalbum.itfuturz.com/${url.replaceAll(" ", "%20")}",
  //         "${dir.path}/${file[3].toString()}", onReceiveProgress: (rec, total) {
  //       print("Rec: $rec , Total: $total");
  //       setState(() {
  //         downloading = true;
  //       });
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  //   setState(() {
  //     downloading = false;
  //   });
  // }

  _saveNetworkImage(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Session.PinSelection, "true");
    // widget.onChange("getData");
    Platform.isIOS
        ? await GallerySaver.saveImage(url).then((bool success) {
            print("Success = ${success}");
            Fluttertoast.showToast(
                backgroundColor: cnst.appPrimaryMaterialColorYellow,
                msg: "Download Completed",
                gravity: ToastGravity.TOP,
                toastLength: Toast.LENGTH_SHORT);
          })
        : await downloadAndroid(url);

    pr.hide();
  }

  downloadAndroid(String path) async {
    var response = await Dio()
        .get("${path}", options: Options(responseType: ResponseType.bytes));
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print(result);
    Fluttertoast.showToast(
        msg: "Download Completed",
        backgroundColor: cnst.appPrimaryMaterialColorYellow,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT);
  }

  _openDialog(String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Pictik"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 75,
                child: TextFormField(
                  controller: edtPIN,
                  scrollPadding: EdgeInsets.all(0),
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.black,
                      ),
                      hintText: "Enter PIN"),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              new Text("Are You Sure You Want To Download/Share Images ?"),
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("No",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                if (edtPIN.text == SelectedPin) {
                  Navigator.pop(context);
                  setState(() {
                    PinSelection = "true";
                  });

                  if (type == "Share") {
                    shareFile(
                        "${cnst.ImgUrl}${widget.albumData[widget.albumIndex]["Photo"]}");
                  } else {
                    _saveNetworkImage(
                        "${cnst.ImgUrl}${widget.albumData[widget.albumIndex]["Photo"].toString().replaceAll(" ", "%20")}");
                  }
                } else {
                  Fluttertoast.showToast(
                      msg: "Enter Valid PIN...",
                      textColor: cnst.appPrimaryMaterialColorPink[700],
                      backgroundColor: Colors.red,
                      gravity: ToastGravity.CENTER,
                      toastLength: Toast.LENGTH_SHORT);
                }
                print("PIN: ${edtPIN.text}");
              },
            ),
          ],
        );
      },
    );
  }

  onCommentFunction(value) {
    switch (value) {
      case 0:
        onComment = widget.onChange;
        break;
    }
  }

  bool _selectedIndex = false;

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => BottomSheet(
        onComment: onCommentFunction(0),
        Data: widget.albumData,
        index: widget.albumIndex,
      ),
    );
  }

  List selectedData = new List();
  List selectedPhoto = new List();
  List albumData = new List();
  String selectedCount = "0";

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

  sendSelectImage(String isselected) async {
    try {
      selectedData.add({
        'Id': widget.albumData[widget.albumIndex]["Id"].toString(),
        'IsSelected': isselected.toString(),
      });
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Services.UploadSelectedImage(selectedData).then((data) async {
          if (data.Data == "1") {
            setState(() {
              // isselected=="true" ?
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

  downloadAll() async {
    for (int i = 0; i < selectedPhoto.length; i++) {
      String path =
          "${cnst.ImgUrl}${selectedPhoto[i]["ImageUrl"].toString().replaceAll(" ", "%20")}";
      print("yaash" + ImgUrl);
      Platform.isIOS
          ? await GallerySaver.saveImage(path).then((bool success) {
              print("Success = ${success}");
              Fluttertoast.showToast(
                  msg: "Download Completed",
                  backgroundColor: cnst.appPrimaryMaterialColorYellow,
                  textColor: Colors.white,
                  gravity: ToastGravity.BOTTOM,
                  toastLength: Toast.LENGTH_SHORT);
              /*Fluttertoast.showToast(
                  backgroundColor: cnst.appPrimaryMaterialColorYellow,
                  msg: "Download Complete",
                  gravity: ToastGravity.TOP,
                  toastLength: Toast.LENGTH_SHORT);*/
            })
          : await downloadAndroid(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
        "ffff" + widget.albumData[widget.albumIndex]["IsSelected"].toString());
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Gallery'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.clear,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          // GestureDetector(
          //   onTap: () {
          //     print(widget.albumData[widget.albumIndex]);
          //     if (widget.albumData[widget.albumIndex]["IsSelected"]
          //             .toString() ==
          //         "true") {
          //       setState(() {
          //         widget.albumData[widget.albumIndex]["IsSelected"] = "false";
          //       });
          //       widget.onChange(
          //           "Remove",
          //           widget.albumData[widget.albumIndex]["Id"].toString(),
          //           widget.albumData[widget.albumIndex]["Photo"].toString());
          //     } else {
          //       setState(() {
          //         widget.albumData[widget.albumIndex]["IsSelected"] = "true";
          //       });
          //       widget.onChange(
          //           "Add",
          //           widget.albumData[widget.albumIndex]["Id"].toString(),
          //           widget.albumData[widget.albumIndex]["Photo"].toString());
          //     }
          //   },
          //   child:
          //       widget.albumData[widget.albumIndex]["IsSelected"].toString() ==
          //               "true"
          //           ? Container(
          //               margin: EdgeInsets.all(15),
          //               height: 25,
          //               width: 25,
          //               decoration: BoxDecoration(
          //                 shape: BoxShape.circle,
          //                 color: cnst.appPrimaryMaterialColorPink,
          //               ),
          //               child: Icon(
          //                 Icons.check,
          //                 color: Colors.white,
          //                 size: 19,
          //               ),
          //             )
          //           : Container(
          //               margin: EdgeInsets.all(5),
          //               height: 25,
          //               width: 25,
          //               decoration: BoxDecoration(
          //                   shape: BoxShape.circle,
          //                   color: Colors.white.withOpacity(0.6),
          //                   border: Border.all(color: Colors.white, width: 2)),
          //             ),
          // ),
          // Platform.isIOS
          //     ? Container()
          //     : GestureDetector(
          //         onTap: () {
          //           _downloadFile(widget.albumData[widget.albumIndex]["Photo"]);
          //           _saveNetworkImage(
          //               "${cnst.ImgUrl}${widget.albumData[widget.albumIndex]["Photo"].toString().replaceAll(" ", "%20")}");
          //           if (SelectedPin != "" &&
          //               (PinSelection == "false" ||
          //                   PinSelection == "" ||
          //                   PinSelection.toString() == "null")) {
          //             downloadAll();
          //           } else {
          //             _saveNetworkImage(
          //                 "${cnst.ImgUrl}${widget.albumData[widget.albumIndex]["Photo"].toString().replaceAll(" ", "%20")}");
          //           }
          //         },
          //         child: Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: Column(
          //             children: <Widget>[
          //               downloading == true
          //                   ? Container(
          //                       child: CircularProgressIndicator(
          //                         backgroundColor: Colors.white,
          //                       ),
          //                       height: 25,
          //                       width: 25,
          //                     )
          //                   : Icon(
          //                       Icons.file_download,
          //                       size: 20,
          //                       color: Colors.white,
          //                     ),
          //               Text(
          //                 "Download",
          //                 style: TextStyle(
          //                     color: Colors.white,
          //                     fontSize: 12,
          //                     fontWeight: FontWeight.w600),
          //               )
          //             ],
          //           ),
          //         ),
          //       ),
          // GestureDetector(
          //   //
          //   onTap: () {
          //     shareFile(
          //         "${cnst.ImgUrl}${widget.albumData[widget.albumIndex]["Photo"]}");
          //     /*shareFile(
          //         "${cnst.ImgUrl}${widget.albumData[widget.albumIndex]["Photo"]}");
          //     //Share
          //     if (SelectedPin != "" &&
          //         (PinSelection == "false" ||
          //             PinSelection == "" ||
          //             PinSelection.toString() == "null")) {
          //       downloadAll();
          //     } else {
          //       shareFile(
          //           "${cnst.ImgUrl}${widget.albumData[widget.albumIndex]["Photo"]}");
          //     }*/
          //   },
          //   child: Padding(
          //     padding: const EdgeInsets.only(
          //         top: 8.0, bottom: 8.0, left: 8.0, right: 14),
          //     child: Column(
          //       children: <Widget>[
          //         Icon(
          //           Icons.share,
          //           size: 20,
          //           color: Colors.white,
          //         ),
          //         Text(
          //           "Share",
          //           style: TextStyle(
          //               color: Colors.white,
          //               fontSize: 12,
          //               fontWeight: FontWeight.w600),
          //         )
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
      body: GestureDetector(
        // onHorizontalDragEnd: (DragEndDetails details) {
        //   setState(() {
        //     //_value++;
        //   });
        //   if (details.velocity.pixelsPerSecond.dx > -1000.0) {
        //     print("Drag Left - SubValue");
        //     /*if(widget.albumData.length-1==widget.albumIndex){
        //     }else{
        //       setState(() {
        //         widget.albumIndex=widget.albumIndex+1;
        //       });
        //     }*/
        //     if (widget.albumIndex != 0) {
        //       setState(() {
        //         widget.albumIndex = widget.albumIndex - 1;
        //       });
        //     }
        //     print("Current Index = ${widget.albumData.length}");
        //     print("Total Size = ${widget.albumIndex}");
        //   } else {
        //     print("Drag Right - AddValue");
        //     if (widget.albumData.length - 1 == widget.albumIndex) {
        //     } else {
        //       setState(() {
        //         widget.albumIndex = widget.albumIndex + 1;
        //       });
        //     }
        //     print("Current Index = ${widget.albumData.length}");
        //     print("Total Size = ${widget.albumIndex}");
        //   }
        // },
        child: Container(
          width: MediaQuery.of(context).size.width,
          //height: MediaQuery.of(context).size.height,
          child: Stack(
            /*crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,*/
            children: <Widget>[
              Center(child: CircularProgressIndicator()),
              Center(
                child: PhotoView(
                  imageProvider: NetworkImage(
                    "${cnst.ImgUrl}${widget.albumData[widget.albumIndex]["Photo"]}",
                  ),
                  loadingChild: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onHorizontalDragEnd: (DragEndDetails details) {
                        if (details.velocity.pixelsPerSecond.dx > -1000.0) {
                          print("Drag Left - SubValue");
                          /*if(widget.albumData.length-1==widget.albumIndex){
          }else{
            setState(() {
              widget.albumIndex=widget.albumIndex+1;
            });
          }*/
                          if (widget.albumIndex != 0) {
                            setState(() {
                              widget.albumIndex = widget.albumIndex - 1;
                            });
                          }
                          print("Current Index = ${widget.albumData.length}");
                          print("Total Size = ${widget.albumIndex}");
                        }
                        // else {
                        //   print("Drag Right - AddValue");
                        //   if (widget.albumData.length - 1 == widget.albumIndex) {
                        //   } else {
                        //     setState(() {
                        //       widget.albumIndex = widget.albumIndex + 1;
                        //     });
                        //   }
                        //   print("Current Index = ${widget.albumData.length}");
                        //   print("Total Size = ${widget.albumIndex}");
                        // }
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff4B4B4B4A),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onHorizontalDragEnd: (DragEndDetails details) {
                        if (details.velocity.pixelsPerSecond.dx > -1000.0)
                        //             {
                        //               print("Drag Left - SubValue");
                        //               /*if(widget.albumData.length-1==widget.albumIndex){
                        // }else{
                        //   setState(() {
                        //     widget.albumIndex=widget.albumIndex+1;
                        //   });
                        // }*/
                        //               if (widget.albumIndex != 0) {
                        //                 setState(() {
                        //                   widget.albumIndex = widget.albumIndex - 1;
                        //                 });
                        //               }
                        //               print("Current Index = ${widget.albumData.length}");
                        //               print("Total Size = ${widget.albumIndex}");
                        //             } else

                        {
                          print("Drag Right - AddValue");
                          if (widget.albumData.length - 1 ==
                              widget.albumIndex) {
                          } else {
                            setState(() {
                              widget.albumIndex = widget.albumIndex + 1;
                            });
                          }
                          print("Current Index = ${widget.albumData.length}");
                          print("Total Size = ${widget.albumIndex}");
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff4B4B4B4A),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (widget.albumData[widget.albumIndex]["IsSelected"]
                                  .toString() ==
                              "true") {
                            sendSelectImage("false");
                            setState(() {
                              widget.albumData[widget.albumIndex]
                                  ["IsSelected"] = "false";
                            });
                            widget.onChange(
                                "Remove",
                                widget.albumData[widget.albumIndex]["Id"]
                                    .toString(),
                                widget.albumData[widget.albumIndex]["Photo"]
                                    .toString());
                          } else {
                            sendSelectImage("true");
                            setState(() {
                              widget.albumData[widget.albumIndex]
                                  ["IsSelected"] = "true";
                            });
                            widget.onChange(
                                "Add",
                                widget.albumData[widget.albumIndex]["Id"]
                                    .toString(),
                                widget.albumData[widget.albumIndex]["Photo"]
                                    .toString());
                          }
                        },
                        icon: widget.albumData[widget.albumIndex]["IsSelected"]
                                    .toString() ==
                                "true"
                            ? Icon(
                                Icons.favorite,
                                size: 25,
                                color: Colors.white,
                              )
                            : Stack(
                                children: [
                                  Icon(
                                    Icons.favorite_border,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // _settingModalBottomSheet(context);
                          final snackBar = SnackBar(
                            content: Text('Yay! A SnackBar!'),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                // Some code to undo the change.
                              },
                            ),
                          );
                          Scaffold.of(context).showSnackBar(snackBar);
                        },
                        child: Icon(
                          Icons.comment,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          shareFile(
                              "${cnst.ImgUrl}${widget.albumData[widget.albumIndex]["Photo"]}");
                        },
                        child: Icon(
                          Icons.share,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _downloadFile(
                              widget.albumData[widget.albumIndex]["Photo"]);
                          _saveNetworkImage(
                              "${cnst.ImgUrl}${widget.albumData[widget.albumIndex]["Photo"].toString().replaceAll(" ", "%20")}");
                          if (SelectedPin != "" &&
                              (PinSelection == "false" ||
                                  PinSelection == "" ||
                                  PinSelection.toString() == "null")) {
                            downloadAll();
                          } else {
                            _saveNetworkImage(
                                "${cnst.ImgUrl}${widget.albumData[widget.albumIndex]["Photo"].toString().replaceAll(" ", "%20")}");
                          }
                          if (widget.albumData[widget.albumIndex]["IsSelected"]
                                  .toString() ==
                              "true") {
                            setState(() {
                              widget.albumData[widget.albumIndex]
                                  ["IsSelected"] = "false";
                            });
                            widget.onChange(
                                "Remove",
                                widget.albumData[widget.albumIndex]["Id"]
                                    .toString(),
                                widget.albumData[widget.albumIndex]["Photo"]
                                    .toString());
                          } else {
                            setState(() {
                              widget.albumData[widget.albumIndex]
                                  ["IsSelected"] = "true";
                            });
                            widget.onChange(
                                "Add",
                                widget.albumData[widget.albumIndex]["Id"]
                                    .toString(),
                                widget.albumData[widget.albumIndex]["Photo"]
                                    .toString());
                          }
                        },
                        child: Icon(
                          Icons.download_rounded,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
        Future res = Services.GetImageComment(
            widget.Data[widget.index]["Id"].toString());
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
          'AlbumPhotoId': widget.Data[widget.index]["Id"].toString(),
          'Comment': edtComment.text.toString().trim(),
          'Name': studioname,
        };
        Services.AddComment(data1).then((data) async {
          pr.hide();
          if (data.Data == "1") {
            setState(() {
              CommentList.add(data1);
              widget.Data[widget.index]["IsSelected"] = "true";
            });
            widget.onComment("Add", widget.Data[widget.index]["Id"].toString(),
                widget.Data[widget.index]["Photo"].toString());
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
            // Expanded(
            //     child: IsLoading
            //         ? LoadinComponent()
            //         : CommentList.length > 0
            //         ? ListView.builder(
            //       padding: EdgeInsets.all(0),
            //       itemCount: CommentList.length,
            //       itemBuilder: (BuildContext context, int index) {
            //         return PhotoCommentConponent(
            //             CommentList[index], CustomerId, (action, id) {
            //           if (action == "delete") {
            //             deleteComment(id, index);
            //           }
            //         });
            //       },
            //     )
            //         : NoDataComponent()),
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
