import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Common/Constants.dart' as cnst;
import 'Screen/ContactList.dart';
import 'Screen/GuestDashboard.dart';
import 'Screen/GuestAboutUs.dart';
import 'Screen/AddCustomer.dart';
import 'Screen/BookAppointment.dart';
import 'Screen/CustomerAboutUs.dart';
import 'Screen/Dashboard.dart';
import 'Screen/Login.dart';
import 'Screen/MyInvites.dart';
import 'Screen/CustomerNotificationPage.dart';
import 'Screen/OTPVerification.dart';
import 'Screen/PortfolioScreen.dart';
import 'Screen/ReferAndEarn.dart';
import 'Screen/SelectSound.dart';
import 'Screen/SignUpGuest.dart';
import 'Screen/SocialLink.dart';
import 'Screen/Splash.dart';
import 'Screen/StudioLocation.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "OPI",
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => Splash(),
          '/Login': (context) => Login(),
          '/OTPVerification': (context) => OTPVerification(),
          '/Dashboard': (context) => Dashboard(),
          '/SignUpGuest': (context) => SignUpGuest(),
          '/SelectSound': (context) => SelectSound(),
          '/AddCustomer': (context) => AddCustomer(),
          '/ContactList': (context) => ContactList(),
          '/PortfolioScreen': (context) => PortfolioScreen(),
          '/ReferAndEarn': (context) => ReferAndEarn(),
          '/GuestAboutUs': (context) => GuestAboutUs(),
          '/SocialLink': (context) => SocialLink(),
          '/MyCustomer': (context) => MychildCustomerList(),
          '/BookAppointment': (context) => BookAppointment(),
          '/CustomerNotificationPage': (context) => CustomerNotificationPage(),
          '/GuestDashboard': (context) => GuestDashboard(),
          '/StudioLocation': (context) => StudioLocation(),
          '/CustomerAboutUs': (context) => CustomerAboutUs(),
        },
        theme: ThemeData(
          textTheme: GoogleFonts.aBeeZeeTextTheme(
            Theme.of(context).textTheme,
          ),
          primarySwatch: cnst.appPrimaryMaterialColorPink,
          accentColor: cnst.appPrimaryMaterialColorPink,
          buttonColor: cnst.appPrimaryMaterialColorPink,
        ));
  }
}
