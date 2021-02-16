import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:opicxo/Common/Constants.dart';
import 'package:opicxo/Common/Services.dart';
import 'package:opicxo/Components/AllAlbumComponent.dart';
import 'package:opicxo/Components/NoDataComponent.dart';
import 'package:opicxo/Screen/AllImageSlideShow.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:opicxo/Common/Constants.dart' as cnst;
import 'package:shared_preferences/shared_preferences.dart';
import 'ImageView.dart';
import 'SelectedAlbum.dart';
import 'SelectedPhotoShow.dart';

class AlbumAllImages extends StatefulWidget {
  String albumId, albumName, totalImg;

  AlbumAllImages({this.albumId, this.albumName, this.totalImg});

  @override
  _AlbumAllImagesState createState() => _AlbumAllImagesState();
}

class _AlbumAllImagesState extends State<AlbumAllImages> {
  List albumData = new List();
  List selectedData = new List();
  List selectedPhoto = new List();
  bool isLoading = false;

  TextEditingController edtPIN = new TextEditingController();
  bool isSaveButton = false;
  ProgressDialog pr;
  String selectedCount = "0";

  ProgressDialog pr1;

  String SelectedPin = "", PinSelection = "";

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
    getAlbumAllData();
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
                  pr1 = new ProgressDialog(context,
                      type: ProgressDialogType.Normal);
                  pr1.style(
                      message: "Please Wait",
                      borderRadius: 10.0,
                      progressWidget: Container(
                        padding: EdgeInsets.all(15),
                        child: CircularProgressIndicator(),
                      ),
                      elevation: 10.0,
                      insetAnimCurve: Curves.easeInOut,
                      messageTextStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w600));

                  if (type == "Share") {
                    shareFile();
                  } else {
                    downloadAll();
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

  getAlbumAllData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isLoading = true;
        Future res = Services.GetAlbumAllData(widget.albumId);
        res.then((data) async {
          if (data != null && data.length > 0) {
            isLoading = false;

            setState(() {
              albumData = data[0]["PhotoList"];
            });
            setState(() {
              for (int i = 0; i < data[0]["PhotoList"].length; i++) {
                if (data[0]["PhotoList"][i]["IsSelected"] == true) {
                  var data1 = {
                    'Id': data[0]["PhotoList"][i]["Id"],
                    'ImageUrl': data[0]["PhotoList"][i]["Photo"],
                  };
                  selectedPhoto.add(data1);
                }
              }
              selectedCount = data[0]["SelectedCount"].toString();
            });
          } else {
            isLoading = true;
            //showMsg("Try Again.");
            setState(() {
              albumData.clear();
            });
          }
        }, onError: (e) {
          setState(() {
            pr.hide();
          });

          print("Error : on Login Call $e");
          setState(() {
            albumData.clear();
          });
          //showMsg("$e");
        });
      } else {
        setState(() {
          pr.hide();
        });

        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  setNewArrayList(String Id, String isSelected, String ImageUrl) {
    bool ischeck = false;
    bool ischeckimage = false;
    if (selectedData.length > 0) {
      for (int i = 0; i < selectedData.length; i++) {
        if (selectedData[i]["Id"].toString() == Id) {
          setState(() {
            ischeck = true;
            selectedData[i]["IsSelected"] = isSelected;
          });
        }
        /*else {
          var data = {
            'Id': Id,
            'IsSelected': isSelected,
          };
          selectedData.add(data);
        }*/
      }
      if (ischeck == false) {
        var data = {
          'Id': Id,
          'IsSelected': isSelected,
        };
        selectedData.add(data);
      }
    } else {
      var data = {
        'Id': Id,
        'IsSelected': isSelected,
      };
      selectedData.add(data);
    }
    print(selectedData.toString());

    if (selectedPhoto.length > 0) {
      for (int i = 0; i < selectedPhoto.length; i++) {
        if (selectedData[i]["Id"].toString() == Id) {
          setState(() {
            ischeckimage = true;
            selectedPhoto.removeAt(i);
          });
        }
      }
      if (ischeckimage == false) {
        if (isSelected == "true") {
          var data1 = {
            'Id': Id,
            'ImageUrl': ImageUrl,
          };
          selectedPhoto.add(data1);
        }
      }
    } else {
      if (isSelected == "true") {
        var data1 = {
          'Id': Id,
          'ImageUrl': ImageUrl,
        };
        selectedPhoto.add(data1);
      }
    }

    setState(() {
      pr1.hide();
    });

    setState(() {});
    print("Select Image = ${selectedPhoto.toString()}");
  }

  sendSelectImage() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isLoading = true;

        Services.UploadSelectedImage(selectedData).then((data) async {
          if (data.Data == "1") {
            setState(() {
              isLoading = false;
            });

            setState(() {
              signUpDone("Image Saved Successfully.");
              selectedData.clear();
            });
          } else {
            setState(() {
              isLoading = false;
            });

            showMsg(data.Message);
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });

          showMsg("Try Again.");
        });
      } else {
        setState(() {
          isLoading = false;
        });

        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  downloadAll() async {
    setState(() {
      pr1.show();
    });

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
    setState(() {
      pr1.hide();
    });
  }

  downloadAndroid(String path) async {
    var response = await Dio()
        .get(path, options: Options(responseType: ResponseType.bytes));
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print(result);
    Fluttertoast.showToast(
        msg: "Download Completed",
        backgroundColor: cnst.appPrimaryMaterialColorYellow,
        textColor: Colors.white,
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_SHORT);
  }

  shareFile() async {
    setState(() {
      pr1.show();
    });

    String filename = "";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Session.PinSelection, "true");
    //var imagedata = {};
    Map<String, List<int>> imagedata = {};

    for (int i = 0; i < selectedPhoto.length; i++) {
      filename = selectedPhoto[i]["ImageUrl"].split('/').last;
      var request = await HttpClient().getUrl(Uri.parse(cnst.ImgUrl +
          selectedPhoto[i]["ImageUrl"].toString().replaceAll(" ", "%20")));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);

      imagedata["${filename}"] = bytes;
    }

    setState(() {
      pr1.hide();
    });

    await Share.files('esys images', imagedata, '*/*', text: '');
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
          //centerTitle: true,
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
          leading: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelectedAlbum(
                          albumId: widget.albumId,
                          albumName: widget.albumName,
                          totalImg: widget.totalImg)));
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AllImageSlideShow(
                              albumData: albumData,
                            )));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(Icons.play_circle_outline,
                    color: Colors.white, size: 30),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                child: GestureDetector(
                  onTap: () {
                    if (selectedData.length > 0) {
                      sendSelectImage();
                    } else {
                      Fluttertoast.showToast(
                          msg: "No Image Selected.",
                          backgroundColor: cnst.appPrimaryMaterialColorYellow,
                          textColor: Colors.white,
                          gravity: ToastGravity.BOTTOM,
                          toastLength: Toast.LENGTH_SHORT);
                    }
                  },
                  child: Container(
                      width: 65,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 3),
                        child: Center(
                          child: Text("Save",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.aBeeZee(
                                  textStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white))),
                        ),
                      )),
                )),
          ],
          actionsIconTheme: IconThemeData.fallback(),
          title: Text("${widget.albumName}",
              style: GoogleFonts.aBeeZee(
                  textStyle: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)))),
      body: WillPopScope(
        onWillPop: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => SelectedAlbum(
                      albumId: widget.albumId,
                      albumName: widget.albumName,
                      totalImg: widget.totalImg)));
        },
        child: Container(
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Card(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(15),
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              "${"Selected Images : "}${selectedCount} / ${widget.totalImg}",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                if (int.parse(selectedCount) > 0) {
                                  if (SelectedPin != "" &&
                                      (PinSelection == "false" ||
                                          PinSelection == "" ||
                                          PinSelection.toString() == "null")) {
                                    downloadAll();
                                  } else {
                                    pr1 = new ProgressDialog(context,
                                        type: ProgressDialogType.Normal);
                                    pr1.style(
                                        message: "Please Wait",
                                        borderRadius: 10.0,
                                        progressWidget: Container(
                                          padding: EdgeInsets.all(15),
                                          child: CircularProgressIndicator(),
                                        ),
                                        elevation: 10.0,
                                        insetAnimCurve: Curves.easeInOut,
                                        messageTextStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w600));
                                    downloadAll();
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      backgroundColor:
                                          cnst.appPrimaryMaterialColorYellow,
                                      msg: "No Image Selected.",
                                      textColor: Colors.white,
                                      gravity: ToastGravity.BOTTOM,
                                      toastLength: Toast.LENGTH_SHORT);
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.all(5),
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: cnst.appPrimaryMaterialColorPink,
                                ),
                                child: Icon(
                                  Icons.file_download,
                                  size: 17,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (selectedPhoto.length > 0) {
                                  if (SelectedPin != "" &&
                                      (PinSelection == "false" ||
                                          PinSelection == "" ||
                                          PinSelection.toString() == "null")) {
                                    // _openDialog("Share");
                                    downloadAll();
                                  } else {
                                    pr1 = new ProgressDialog(context,
                                        type: ProgressDialogType.Normal);
                                    pr1.style(
                                        message: "Please Wait",
                                        borderRadius: 10.0,
                                        progressWidget: Container(
                                          padding: EdgeInsets.all(15),
                                          child: CircularProgressIndicator(),
                                        ),
                                        elevation: 10.0,
                                        insetAnimCurve: Curves.easeInOut,
                                        messageTextStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w600));
                                    shareFile();
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      backgroundColor:
                                          cnst.appPrimaryMaterialColorYellow,
                                      msg: "No Image Selected.",
                                      textColor: Colors.white,
                                      gravity: ToastGravity.BOTTOM,
                                      toastLength: Toast.LENGTH_SHORT);
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.all(5),
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: cnst.appPrimaryMaterialColorPink,
                                ),
                                child: Icon(
                                  Icons.share,
                                  size: 17,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: albumData.length != 0 && albumData != null
                        /*? GridView.builder(
                            padding: EdgeInsets.only(top: 5),
                            itemCount: albumData.length,
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: MediaQuery.of(context)
                                      .size
                                      .width /
                                  (MediaQuery.of(context).size.height / 1.7),
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return AllAlbumComponent(albumData[index], index,
                                  (action, Id) {
                                if (action.toString() == "Show") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ImageView(
                                              albumData: albumData,
                                              albumIndex: index)));
                                } else if (action.toString() == "Remove") {
                                  int count = int.parse(selectedCount);
                                  count = count - 1;
                                  setState(() {
                                    selectedCount = count.toString();
                                  });
                                  setNewArrayList(Id, "false");
                                } else {
                                  int count = int.parse(selectedCount);
                                  count = count + 1;
                                  setState(() {
                                    selectedCount = count.toString();
                                  });
                                  setNewArrayList(Id, "true");
                                }
                              });
                            })*/
                        ? StaggeredGridView.countBuilder(
                            padding: const EdgeInsets.only(
                                left: 3, right: 3, top: 5),
                            crossAxisCount: 4,
                            itemCount: albumData.length,
                            addRepaintBoundaries: false,
                            itemBuilder: (BuildContext context, int index) {
                              return AllAlbumComponent(
                                albumData[index],
                                index,
                                (action, Id, ImageUrl) {
                                  if (action.toString() == "Show") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ImageView(
                                            albumData: albumData,
                                            albumIndex: index,
                                            onChange: (action, Id, ImageUrl) {
                                              if (action.toString() ==
                                                  "Remove") {
                                                pr1 = new ProgressDialog(
                                                    context,
                                                    type: ProgressDialogType
                                                        .Normal);
                                                pr1.style(
                                                    message: "Please Wait",
                                                    borderRadius: 10.0,
                                                    progressWidget: Container(
                                                      padding:
                                                          EdgeInsets.all(15),
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                    elevation: 10.0,
                                                    insetAnimCurve:
                                                        Curves.easeInOut,
                                                    messageTextStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 17.0,
                                                        fontWeight:
                                                            FontWeight.w600));
                                                int count =
                                                    int.parse(selectedCount);
                                                count = count - 1;
                                                setState(() {
                                                  selectedCount =
                                                      count.toString();
                                                });
                                                setNewArrayList(
                                                    Id, "false", ImageUrl);
                                              } else {
                                                pr1 = new ProgressDialog(
                                                    context,
                                                    type: ProgressDialogType
                                                        .Normal);
                                                pr1.style(
                                                    message: "Please Wait",
                                                    borderRadius: 10.0,
                                                    progressWidget: Container(
                                                      padding:
                                                          EdgeInsets.all(15),
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                    elevation: 10.0,
                                                    insetAnimCurve:
                                                        Curves.easeInOut,
                                                    messageTextStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 17.0,
                                                        fontWeight:
                                                            FontWeight.w600));
                                                int count =
                                                    int.parse(selectedCount);
                                                count = count + 1;
                                                setState(() {
                                                  selectedCount =
                                                      count.toString();
                                                });
                                                setNewArrayList(
                                                    Id, "true", ImageUrl);
                                              }
                                            }),
                                      ),
                                    );
                                  } else if (action.toString() == "Remove") {
                                    pr1 = new ProgressDialog(context,
                                        type: ProgressDialogType.Normal);
                                    pr1.style(
                                        message: "Please Wait",
                                        borderRadius: 10.0,
                                        progressWidget: Container(
                                          padding: EdgeInsets.all(15),
                                          child: CircularProgressIndicator(),
                                        ),
                                        elevation: 10.0,
                                        insetAnimCurve: Curves.easeInOut,
                                        messageTextStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w600));
                                    int count = int.parse(selectedCount);
                                    count = count - 1;
                                    setState(() {
                                      selectedCount = count.toString();
                                    });
                                    setNewArrayList(Id, "false", ImageUrl);
                                    //setImageArray("","");
                                  } else {
                                    pr1 = new ProgressDialog(context,
                                        type: ProgressDialogType.Normal);
                                    pr1.style(
                                        message: "Please Wait",
                                        borderRadius: 10.0,
                                        progressWidget: Container(
                                          padding: EdgeInsets.all(15),
                                          child: CircularProgressIndicator(),
                                        ),
                                        elevation: 10.0,
                                        insetAnimCurve: Curves.easeInOut,
                                        messageTextStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w600));
                                    int count = int.parse(selectedCount);
                                    count = count + 1;
                                    setState(() {
                                      selectedCount = count.toString();
                                    });
                                    setNewArrayList(Id, "true", ImageUrl);
                                  }
                                },
                                selectedCount: selectedCount,
                              );
                            },
                            staggeredTileBuilder: (_) => StaggeredTile.fit(2),
                            mainAxisSpacing: 3,
                            crossAxisSpacing: 3,
                          )
                        : NoDataComponent(),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
