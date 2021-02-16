import 'package:flutter/material.dart';
import 'package:opicxo/Common/Constants.dart' as cnst;

class ReferAndEarn extends StatefulWidget {
  @override
  _ReferAndEarnState createState() => _ReferAndEarnState();
}

class _ReferAndEarnState extends State<ReferAndEarn> {
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
        title: Text("Refer & Earn"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 90),
                child: Image.asset(
                  "images/logo1.png",
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 8.0),
                child: Text(
                  "Refer & Earn",
                  style: TextStyle(
                      color: cnst.appPrimaryMaterialColorPink,
                      fontWeight: FontWeight.w900,
                      fontSize: 25),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 11.0),
                child: Text(
                  "Current Point",
                  style: TextStyle(
                      color: cnst.appPrimaryMaterialColorPink,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "images/dollar.png",
                  height: 35,
                  width: 35,
                ),
              ),
              Text(
                "100",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 35, left: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "SHARE YOUR INVITE CODE",
                    style: TextStyle(
                        color: cnst.appPrimaryMaterialColorPink,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  //  margin: EdgeInsets.only(top: 20),
                  width: MediaQuery.of(context).size.width / 1.1,
                  height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            cnst.appPrimaryMaterialColorYellow,
                            cnst.appPrimaryMaterialColorPink
                          ])),
                  child: Center(
                    child: Text(
                      "SKDJD2KFKD",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          letterSpacing: 2),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 45,
                  width: 350,
                  child: RaisedButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(11.0),
                        side: BorderSide(
                            color: cnst.appPrimaryMaterialColorPink)),
                    onPressed: () {
                      /* Share.share(
                          'Check Out This App And Register With My Referral Code- $referralCode To Find Your Required Schools\nhttps://bit.ly/2V5212g');*/
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Refer ",
                          style: TextStyle(
                              color: cnst.appPrimaryMaterialColorPink),
                        ),
                        Icon(
                          Icons.share,
                          color: cnst.appPrimaryMaterialColorPink,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, left: 10, right: 10, bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        "Note:",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
