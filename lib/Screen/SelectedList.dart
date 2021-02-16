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
import 'package:opicxo/Components/NoDataComponent.dart';
import 'package:opicxo/Components/SelectedAlbumComponent.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:opicxo/Common/Constants.dart' as cnst;
import 'package:shared_preferences/shared_preferences.dart';

import 'Collage screen/Collage10Screen.dart';
import 'Collage screen/Collage11Screen.dart';
import 'Collage screen/Collage1Screen.dart';
import 'Collage screen/Collage2Screen.dart';
import 'Collage screen/Collage3Screen.dart';
import 'Collage screen/Collage4Screen.dart';
import 'Collage screen/Collage5Screen.dart';
import 'Collage screen/Collage6Screen.dart';
import 'Collage screen/Collage7Screen.dart';
import 'Collage screen/Collage8Screen.dart';
import 'Collage screen/Collage9Screen.dart';
import 'Collage screen/fade_route_transition.dart';
import 'ImageView.dart';
import 'SelectedAlbum.dart';

class SelectedList extends StatefulWidget {
  String albumId, albumName, totalImg;

  SelectedList({this.albumId, this.albumName, this.totalImg});

  @override
  _SelectedListState createState() => _SelectedListState();
}

class _SelectedListState extends State<SelectedList> {
  List albumData = new List();
  List selectedData = new List();
  List selectedPhoto = new List();
  List selectedPhone = new List();

  bool isLoading = true;
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
      filename = selectedPhoto[i]["Photo"].split('/').last;
      var request = await HttpClient().getUrl(Uri.parse(cnst.ImgUrl +
          selectedPhoto[i]["Photo"].toString().replaceAll(" ", "%20")));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);

      imagedata["${filename}"] = bytes;
    }

    setState(() {
      pr1.hide();
    });

    await Share.files('esys images', imagedata, '*/*', text: '');
  }

  /* downloadAll() async {
    pr.show();
    for (int i = 0; i < selectedPhone.length; i++) {
      String path =
          "${cnst.ImgUrl}${selectedPhone[i]["ImageUrl"].toString().replaceAll(" ", "%20")}";
      */ /*await GallerySaver.saveImage(path).then((bool success) {
        print("Success = ${success}");
        Fluttertoast.showToast(
            msg: "Download Complete",
            gravity: ToastGravity.TOP,
            toastLength: Toast.LENGTH_SHORT);
      });*/ /*
      Platform.isIOS
          ? await GallerySaver.saveImage(path).then((bool success) {
              print("Success = ${success}");
              Fluttertoast.showToast(
                  msg: "Download Completed",
                  backgroundColor: cnst.appPrimaryMaterialColorYellow,
                  textColor: Colors.white,
                  gravity: ToastGravity.TOP,
                  toastLength: Toast.LENGTH_SHORT);
            })
          : await downloadAndroid(path);
    }
    isLoading = false;
  }*/
  downloadAll() async {
    setState(() {
      pr1.show();
    });

    for (int i = 0; i < selectedPhoto.length; i++) {
      String path =
          "${cnst.ImgUrl}${selectedPhoto[i]["Photo"].toString().replaceAll(" ", "%20")}";
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
        .get("${path}", options: Options(responseType: ResponseType.bytes));
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

  getAlbumAllData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isLoading = true;

        Future res = Services.GetSelectedAlbumData(widget.albumId);
        res.then((data) async {
          if (data != null && data.length > 0) {
            isLoading = false;
            setState(() {
              albumData = data;
              selectedPhoto = data;
            });
            setState(() {
              selectedCount = data.length.toString();
            });
          } else {
            pr.hide();
            //showMsg("Try Again.");
            setState(() {
              albumData.clear();
            });
          }
        }, onError: (e) {
          isLoading = false;
          print("Error : on Login Call $e");
          //showMsg("$e");
          setState(() {
            albumData.clear();
          });
        });
      } else {
        isLoading = false;
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
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SelectedAlbum(
                            albumId: widget.albumId,
                            albumName: widget.albumName,
                            totalImg: widget.totalImg)));
              },
            ),
          ],
        );
      },
    );
  }

  /* setNewArrayList(String Id, String isSelected) {
    bool ischeck = false;
    if (selectedData.length > 0) {
      for (int i = 0; i < selectedData.length; i++) {
        if (selectedData[i]["Id"].toString() == Id) {
          setState(() {
            ischeck = true;
            selectedData[i]["IsSelected"] = isSelected;
          });
        } else {
          var data = {
            'Id': Id,
            'IsSelected': isSelected,
          };
          selectedData.add(data);
        }
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
  }*/

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

    if (selectedPhone.length > 0) {
      for (int i = 0; i < selectedPhone.length; i++) {
        if (selectedData[i]["Id"].toString() == Id) {
          setState(() {
            ischeckimage = true;
            selectedPhone.removeAt(i);
          });
        }
      }
      if (ischeckimage == false) {
        var data1 = {
          'Id': Id,
          'ImageUrl': ImageUrl,
        };
        selectedPhone.add(data1);
      }
    } else {
      var data1 = {
        'Id': Id,
        'ImageUrl': ImageUrl,
      };
      selectedPhone.add(data1);
    }
    setState(() {});
    print("Select Image = ${selectedPhone.toString()}");
  }

  sendSelectImage() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isLoading = true;

        Services.UploadSelectedImage(selectedData).then((data) async {
          if (data.Data == "1") {
            isLoading = false;
            setState(() {
              signUpDone("Data Saved Successfully.");
              selectedData.clear();
              getAlbumAllData();
            });
          } else {
            /*setState(() {
              isLoading = false;
            });*/
            isLoading = false;
            showMsg(data.Message);
          }
        }, onError: (e) {
          isLoading = false;
          showMsg("Try Again.");
        });
      } else {
        isLoading = false;
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  _openDialog(String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("PICTIK"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
          selectedData.length > 0
              ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
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
                      sendSelectImage();
                    },
                    child: Container(
                        width: 70,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 3, right: 3, top: 2, bottom: 2),
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
                  ))
              : Container(),
        ],
        actionsIconTheme: IconThemeData.fallback(),
        title: Text("${widget.albumName}",
            style: GoogleFonts.aBeeZee(
                textStyle: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Colors.white))),
        centerTitle: true,
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          _settingModalBottomSheet();
        },
        child: Container(
          height: 60,
          // color: cnst.appPrimaryMaterialColor,
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
          child: Center(
              child: Text(
            "Collage Photos",
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
          )),
        ),
      ),
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
                  margin: EdgeInsets.all(0),
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
                                  _openDialog("Share");
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
                            childAspectRatio:
                                MediaQuery.of(context).size.width /
                                    //(370),
                                    (MediaQuery.of(context).size.height / 1.7),
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return SelectedAlbumComponent(
                                albumData[index], index, (action, Id) {
                              if(action.toString()=="Show"){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ImageView(
                                            albumData: albumData,albumIndex: index
                                        )));
                              }
                              else if (action.toString() == "Remove") {
                                //pr.show();
                                int count = int.parse(selectedCount);
                                count = count - 1;
                                setState(() {
                                  selectedCount = count.toString();
                                  //albumData[index]["IsSelected"]="false";
                                });
                                setNewArrayList(Id, "false");
                                //pr.hide();
                              } else {
                                //pr.show();
                                int count = int.parse(selectedCount);
                                count = count + 1;
                                setState(() {
                                  selectedCount = count.toString();
                                  //albumData[index]["IsSelected"]="true";
                                });
                                setNewArrayList(Id, "true");
                                //pr.hide();
                              }
                            });
                          })*/
                      ? StaggeredGridView.countBuilder(
                          padding:
                              const EdgeInsets.only(left: 3, right: 3, top: 5),
                          crossAxisCount: 4,
                          itemCount: albumData.length,
                          itemBuilder: (BuildContext context, int index) {
                            return SelectedAlbumComponent(
                                albumData[index], index,
                                (action, Id, ImageUrl) {
                              if (action.toString() == "Show") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ImageView(
                                        albumData: albumData,
                                        albumIndex: index,
                                        onChange: (action, Id, ImageUrl) {
                                          if (action.toString() == "Remove") {
                                            pr1 = new ProgressDialog(context,
                                                type:
                                                    ProgressDialogType.Normal);
                                            pr1.style(
                                                message: "Please Wait",
                                                borderRadius: 10.0,
                                                progressWidget: Container(
                                                  padding: EdgeInsets.all(15),
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
                                              selectedCount = count.toString();
                                            });
                                            setNewArrayList(
                                                Id, "false", ImageUrl);
                                          } else {
                                            pr1 = new ProgressDialog(context,
                                                type:
                                                    ProgressDialogType.Normal);
                                            pr1.style(
                                                message: "Please Wait",
                                                borderRadius: 10.0,
                                                progressWidget: Container(
                                                  padding: EdgeInsets.all(15),
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
                                              selectedCount = count.toString();
                                            });
                                            setNewArrayList(
                                                Id, "true", ImageUrl);
                                          }
                                        }),
                                  ),
                                );
                              } else if (action.toString() == "Remove") {
                                int count = int.parse(selectedCount);
                                count = count - 1;
                                setState(() {
                                  selectedCount = count.toString();
                                });
                                setNewArrayList(Id, "false", ImageUrl);
                              } else {
                                int count = int.parse(selectedCount);
                                count = count + 1;
                                setState(() {
                                  selectedCount = count.toString();
                                });
                                setNewArrayList(Id, "true", ImageUrl);
                              }
                            });
                          },
                          staggeredTileBuilder: (_) => StaggeredTile.fit(2),
                          mainAxisSpacing: 3,
                          crossAxisSpacing: 3,
                        )
                      : NoDataComponent(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _settingModalBottomSheet() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (builder) {
          return new Container(
              //height: 190.0,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        "Collage Images",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w600
                            //fontWeight: FontWeight.bold
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 15, right: 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Navigator.pushNamed(context, '/CollageScreen');
                              Navigator.of(context).push(
                                FadeRouteTransition(
                                    //  page: CollageSample(CollageType.VSplit)),
                                    page: Collage1Screen(
                                  albumId: widget.albumId,
                                  albumName: widget.albumName,
                                  totalImg: widget.totalImg,
                                )),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                //color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 70,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        size: 10,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 3.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        height: 70,
                                        width: 40,
                                        child: Icon(
                                          Icons.add,
                                          size: 10,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10),
                            child: GestureDetector(
                              onTap: () {
                                // Navigator.pushNamed(context, '/CollageScreen');
                                Navigator.of(context).push(
                                  FadeRouteTransition(
                                      page: Collage2Screen(
                                    albumId: widget.albumId,
                                    albumName: widget.albumName,
                                    totalImg: widget.totalImg,
                                  )),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  //color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 33,
                                        width: 75,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          size: 10,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 3.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          height: 33,
                                          width: 75,
                                          child: Icon(
                                            Icons.add,
                                            size: 10,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigator.pushNamed(context, '/CollageScreen');
                              Navigator.of(context).push(
                                FadeRouteTransition(
                                    page: Collage3Screen(
                                  albumId: widget.albumId,
                                  albumName: widget.albumName,
                                  totalImg: widget.totalImg,
                                )),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                //color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 33,
                                          width: 35,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Icon(
                                            Icons.add,
                                            size: 10,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 3.0),
                                          child: Container(
                                            height: 33,
                                            width: 35,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              size: 10,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 33,
                                            width: 35,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              size: 10,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 3.0),
                                            child: Container(
                                              height: 33,
                                              width: 35,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                size: 10,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Navigator.pushNamed(context, '/CollageScreen');
                              Navigator.of(context).push(
                                FadeRouteTransition(
                                    page: Collage4Screen(
                                  albumId: widget.albumId,
                                  albumName: widget.albumName,
                                  totalImg: widget.totalImg,
                                )),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                //color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 20,
                                          width: 23,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Icon(
                                            Icons.add,
                                            size: 10,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 3.0),
                                          child: Container(
                                            height: 20,
                                            width: 23,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              size: 10,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 3.0),
                                          child: Container(
                                            height: 20,
                                            width: 23,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              size: 10,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 20,
                                            width: 23,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              size: 10,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 3.0),
                                            child: Container(
                                              height: 20,
                                              width: 23,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                size: 10,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 3.0),
                                            child: Container(
                                              height: 20,
                                              width: 23,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                size: 10,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 20,
                                            width: 23,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              size: 10,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 3.0),
                                            child: Container(
                                              height: 20,
                                              width: 23,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                size: 10,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 3.0),
                                            child: Container(
                                              height: 20,
                                              width: 23,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                size: 10,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10),
                            child: GestureDetector(
                              onTap: () {
                                // Navigator.pushNamed(context, '/CollageScreen');
                                Navigator.of(context).push(
                                  FadeRouteTransition(
                                      page: Collage5Screen(
                                    albumId: widget.albumId,
                                    albumName: widget.albumName,
                                    totalImg: widget.totalImg,
                                  )),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  //color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 70,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          size: 10,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 3.0),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 33,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                size: 10,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 3.0),
                                              child: Container(
                                                height: 33,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Icon(
                                                  Icons.add,
                                                  size: 10,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigator.pushNamed(context, '/CollageScreen');
                              Navigator.of(context).push(
                                FadeRouteTransition(
                                    page: Collage6Screen(
                                  albumId: widget.albumId,
                                  albumName: widget.albumName,
                                  totalImg: widget.totalImg,
                                )),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                //color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 33,
                                      width: 75,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        size: 10,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 33,
                                            width: 35,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              size: 10,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 3.0),
                                            child: Container(
                                              height: 33,
                                              width: 35,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                size: 10,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Navigator.pushNamed(context, '/CollageScreen');
                              Navigator.of(context).push(
                                FadeRouteTransition(
                                    page: Collage7Screen(
                                  albumId: widget.albumId,
                                  albumName: widget.albumName,
                                  totalImg: widget.totalImg,
                                )),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                //color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 45,
                                          width: 48,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Icon(
                                            Icons.add,
                                            size: 10,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 3.0),
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Icon(
                                                  Icons.add,
                                                  size: 10,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 3.0),
                                                child: Container(
                                                  height: 20,
                                                  width: 20,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 10,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              size: 10,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 3.0),
                                            child: Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                size: 10,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 3.0),
                                            child: Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                size: 10,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10),
                            child: GestureDetector(
                              onTap: () {
                                // Navigator.pushNamed(context, '/CollageScreen');
                                Navigator.of(context).push(
                                  FadeRouteTransition(
                                      page: Collage8Screen(
                                    albumId: widget.albumId,
                                    albumName: widget.albumName,
                                    totalImg: widget.totalImg,
                                  )),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  //color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Icon(
                                                  Icons.add,
                                                  size: 10,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 3.0),
                                                child: Container(
                                                  height: 20,
                                                  width: 20,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 10,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 3.0),
                                            child: Container(
                                              height: 45,
                                              width: 48,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                size: 10,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 3.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 20,
                                              width: 21,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                size: 10,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3.0),
                                              child: Container(
                                                height: 20,
                                                width: 21,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Icon(
                                                  Icons.add,
                                                  size: 10,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3.0),
                                              child: Container(
                                                height: 20,
                                                width: 21,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Icon(
                                                  Icons.add,
                                                  size: 10,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigator.pushNamed(context, '/CollageScreen');
                              Navigator.of(context).push(
                                FadeRouteTransition(
                                    page: Collage9Screen(
                                  albumId: widget.albumId,
                                  albumName: widget.albumName,
                                  totalImg: widget.totalImg,
                                )),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                //color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 70,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        size: 10,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 3.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 22,
                                            width: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              size: 10,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 3.0),
                                            child: Container(
                                              height: 22,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                size: 10,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 3.0),
                                            child: Container(
                                              height: 22,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                size: 10,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Navigator.pushNamed(context, '/CollageScreen');
                              Navigator.of(context).push(
                                FadeRouteTransition(
                                    page: Collage10Screen(
                                  albumId: widget.albumId,
                                  albumName: widget.albumName,
                                  totalImg: widget.totalImg,
                                )),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                //color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          height: 24,
                                          width: 33,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Icon(
                                            Icons.add,
                                            size: 10,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 1.0),
                                          child: Container(
                                            height: 24,
                                            width: 33,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              size: 10,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 1.0),
                                          child: Container(
                                            height: 24,
                                            width: 33,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              size: 10,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 3.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 18,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              size: 10,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 1.0),
                                            child: Container(
                                              height: 18,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                size: 10,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 1.0),
                                            child: Container(
                                              height: 18,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                size: 10,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 1.0),
                                            child: Container(
                                              height: 18,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                size: 10,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: GestureDetector(
                              onTap: () {
                                // Navigator.pushNamed(context, '/CollageScreen');
                                Navigator.of(context).push(
                                  FadeRouteTransition(
                                      page: Collage11Screen(
                                    albumId: widget.albumId,
                                    albumName: widget.albumName,
                                    totalImg: widget.totalImg,
                                  )),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  //color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            height: 24,
                                            width: 20,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              size: 10,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 1.0),
                                            child: Container(
                                              height: 24,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                size: 10,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 1.0),
                                            child: Container(
                                              height: 24,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                size: 10,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 3.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          height: 73,
                                          width: 30,
                                          child: Icon(
                                            Icons.add,
                                            size: 10,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 3.0),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 24,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                size: 10,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 1.0),
                                              child: Container(
                                                height: 24,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Icon(
                                                  Icons.add,
                                                  size: 10,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 1.0),
                                              child: Container(
                                                height: 24,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Icon(
                                                  Icons.add,
                                                  size: 10,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ));
        });
  }
}
