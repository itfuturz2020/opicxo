import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opicxo/Screen/RedeemOffers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Common/Constants.dart';
import 'package:intl/intl.dart';

class OfferDetailScreen extends StatefulWidget {
  Map<String, dynamic> PhotographerListData;
  List PhotographerList = [];
  int index = 0, current;

  OfferDetailScreen(
      {this.PhotographerListData,
      this.PhotographerList,
      this.index,
      this.current});

  @override
  _OfferDetailScreenState createState() => _OfferDetailScreenState();
}

class _OfferDetailScreenState extends State<OfferDetailScreen> {
  String anotherDt, customerid;

  @override
  void initState() {
    print(widget.index);
    getcustomerid();
    super.initState();
    if (widget.current == 0) {
      anotherDt = widget.PhotographerListData["ValidTillFormat"];
    } else {
      anotherDt = widget.PhotographerList[widget.index]["ValidTillFormat"];
    }
  }

  var currDt = DateTime.now();

  getcustomerid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customerid = prefs.getString(Session.CustomerId);
    return customerid;
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime lastdate = DateTime.parse(anotherDt);
    var diffdays = lastdate.difference(now);
    print(now);
    print(anotherDt);
    print("diffdays");
    print(diffdays.inDays);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back,
          ),
        ),
        centerTitle: true,
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
        automaticallyImplyLeading: false,
        title: Text(
          "Offer Details",
          style: GoogleFonts.aBeeZee(
            textStyle: TextStyle(
                fontSize: 25, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
        actions: <Widget>[
          // Padding(
          //   padding: const EdgeInsets.only(right:8.0),
          //   child: GestureDetector(
          //     onTap: (){
          //       setState(() {
          //         EditName.text = name;
          //         EditMobile.text = mobile;
          //         EditEmail.text = email;
          //         editpressed = true;
          //       });
          //     },
          //       child: !editpressed ||updatepressed? Icon(
          //           Icons.edit,
          //       ) : GestureDetector(
          //         onTap: (){
          //           setState(() {
          //             name  =EditName.text;
          //             mobile = EditMobile.text;
          //             email = EditEmail.text;
          //           });
          //           _updateProfile();
          //           setState(() {
          //             updatepressed = true;
          //           });
          //         },
          //         child: Icon(
          //           Icons.update,
          //         ),
          //       ),
          //   ),
          // ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10),
            child: ListView(
              children: [
                SizedBox(
                  height: 18,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => widget.current == 0
                                ? RedeemOffers(
                                    widget.PhotographerListData["ValidTill"],
                                    widget.PhotographerListData["Title"],
                                    widget.PhotographerListData["Id"],
                                    widget.PhotographerListData["StudioId"],
                                    customerid,
                                  )
                                : RedeemOffers(
                                    widget.PhotographerList[widget.index]
                                        ["ValidTill"],
                                    widget.PhotographerList[widget.index]
                                        ["Title"],
                                    widget.PhotographerList[widget.index]["Id"],
                                    widget.PhotographerList[widget.index]
                                        ["StudioId"],
                                    customerid,
                                  )));
                  },
                  child: Container(
                    height: 180,
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: widget.current == 0
                          ? Image.network(
                              "${widget.PhotographerListData["Image"]}",
                              fit: BoxFit.fill,
                            )
                          : Image.network(
                              "${widget.PhotographerList[widget.index]["Image"]}",
                              fit: BoxFit.fill,
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                // Text(
                //   "Offer Created By",
                //   style: TextStyle(
                //       color: Colors.black,
                //       fontSize: 18,
                //       fontWeight: FontWeight.w500),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(right: 250.0),
                //   child: Container(
                //     color: appPrimaryMaterialColor,
                //     height: 3,
                //   ),
                // ),
                // SizedBox(
                //   height: 15,
                //   width: 20,
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 8.0),
                //   child: Container(
                //       height: 80,
                //       color: Colors.white,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: <Widget>[
                //           Container(
                //             width: 80,
                //             decoration: BoxDecoration(
                //               color: Colors.white,
                //               border: Border.all(color: Colors.grey[200], width: 1),
                //               borderRadius: BorderRadius.all(Radius.circular(20.0)),
                //             ),
                //             child: ClipRRect(
                //                 borderRadius: BorderRadius.circular(20),
                //                 child: Image.asset(
                //                   'assets/pic.png',
                //                   fit: BoxFit.cover,
                //                 )),
                //           ),
                //           Padding(
                //             padding: const EdgeInsets.only(left: 6.0),
                //             child: Text(
                //               "IT Futurz InfoSolution",
                //               maxLines: 2,
                //               overflow: TextOverflow.ellipsis,
                //               style: TextStyle(
                //                   color: appPrimaryMaterialColor,
                //                   fontWeight: FontWeight.w500,
                //                   fontSize: 22),
                //             ),
                //           )
                //         ],
                //       )),
                // ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "Offer Expires On",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 250.0),
                  child: Container(
                    height: 3,
                    width: 40,
                    color: appPrimaryMaterialColor,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 35,
                          color: Color(0xff367a98),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Container(
                            height: 45,
                            child: Card(
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: widget.current == 0
                                    ? Text(
                                        "${widget.PhotographerListData["ValidTill"]}",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      )
                                    : Text(
                                        "${widget.PhotographerList[widget.index]["ValidTill"]}",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18)),
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Container(
                        height: 45,
                        child: Card(
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text("${diffdays.inDays} Days to Go",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18)),
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "Description",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 250.0),
                  child: Container(
                    height: 3,
                    width: 40,
                    color: appPrimaryMaterialColor,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                widget.current == 0
                    ? Text(
                        "${widget.PhotographerListData["Descri"]}",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            letterSpacing: 0.2),
                      )
                    : Text(
                        "${widget.PhotographerList[widget.index]["Descri"]}",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            letterSpacing: 0.2),
                      ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              children: [
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.09,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.09,
                  child: RaisedButton(
                    child: Text(
                      "Redeem Offer",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        widget.current == 0
                            ? MaterialPageRoute(
                                builder: (context) => RedeemOffers(
                                      widget.PhotographerListData["ValidTill"],
                                      widget.PhotographerListData["Title"],
                                      widget.PhotographerListData["Id"],
                                      widget.PhotographerListData["StudioId"],
                                      customerid,
                                    ))
                            : MaterialPageRoute(
                                builder: (context) => RedeemOffers(
                                  widget.PhotographerList[widget.index]
                                      ["ValidTill"],
                                  widget.PhotographerList[widget.index]
                                      ["Title"],
                                  widget.PhotographerList[widget.index]["Id"],
                                  widget.PhotographerList[widget.index]
                                      ["StudioId"],
                                  customerid,
                                ),
                              ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
