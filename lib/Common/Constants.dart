import 'dart:io';

import 'package:flutter/material.dart';

const String API_URL = "http://pictick.itfuturz.com/api/AppAPI/";
const String ImgUrl = "http://pictick.itfuturz.com/";
const String profileUrl = "http://digitalcard.co.in?uid=#id";
const String playstoreUrl = "shorturl.at/rEFWY";
const String smsLink = "sms:#mobile?body=#msg"; //mobile no with country code
const String mailLink = "mailto:#mail?subject=#subject&body=#msg";
//const String API_URL = "${cnst.ImgUrl}api/AppAPI/";
//const String API_URL = "http://thestudioom.itfuturz.com/AppAPI/";
const Inr_Rupee = "₹";
const String digitalcard = "http://digitalcard.co.in/DigitalcardService.asmx/";
const Studio_Id = "8";
const Color appcolor = Color.fromRGBO(0, 171, 199, 1);
const Color secondaryColor = Color.fromRGBO(85, 96, 128, 1);
const Color buttoncolor = Color.fromRGBO(85, 96, 128, 1);
const String mobileno = "mobileno";

const String whatsAppLink =
    "https://wa.me/#mobile?text=#msg"; //mobile no with country code

Map<int, Color> appprimarycolors = {
  50: Color.fromRGBO(0, 152, 219, .1),
  100: Color.fromRGBO(0, 152, 219, .2),
  200: Color.fromRGBO(0, 152, 219, .3),
  300: Color.fromRGBO(0, 152, 219, .4),
  400: Color.fromRGBO(0, 152, 219, .5),
  500: Color.fromRGBO(0, 152, 219, .6),
  600: Color.fromRGBO(0, 152, 219, .7),
  700: Color.fromRGBO(0, 152, 219, .8),
  800: Color.fromRGBO(0, 152, 219, .9),
  900: Color.fromRGBO(0, 152, 219, 1)
};

MaterialColor appPrimaryMaterialColor =
    MaterialColor(0xFF0098db, appprimarycolors);

Map<int, Color> appprimarycolorspink = {
  50: Color.fromRGBO(1, 102, 165, .1),
  100: Color.fromRGBO(1, 102, 165, .2),
  200: Color.fromRGBO(1, 102, 165, .3),
  300: Color.fromRGBO(1, 102, 165, .4),
  400: Color.fromRGBO(1, 102, 165, .5),
  500: Color.fromRGBO(1, 102, 165, .6),
  600: Color.fromRGBO(1, 102, 165, .7),
  700: Color.fromRGBO(1, 102, 165, .8),
  800: Color.fromRGBO(1, 102, 165, .9),
  900: Color.fromRGBO(1, 102, 165, 1)
};

MaterialColor appPrimaryMaterialColorPink =
    MaterialColor(0xFF0166a5, appprimarycolorspink);

Map<int, Color> appprimarycolorsyellow = {
  50: Color.fromRGBO(1, 102, 165, .1),
  100: Color.fromRGBO(1, 102, 165, .2),
  200: Color.fromRGBO(1, 102, 165, .3),
  300: Color.fromRGBO(1, 102, 165, .4),
  400: Color.fromRGBO(1, 102, 165, .5),
  500: Color.fromRGBO(1, 102, 165, .6),
  600: Color.fromRGBO(1, 102, 165, .7),
  700: Color.fromRGBO(1, 102, 165, .8),
  800: Color.fromRGBO(1, 102, 165, .9),
  900: Color.fromRGBO(1, 102, 165, 1)
};

MaterialColor appPrimaryMaterialColorYellow =
    MaterialColor(0xFF0166a5, appprimarycolorsyellow);

class MESSAGES {
  static const String INTERNET_ERROR = "No Internet Connection";
  static const String INTERNET_ERROR_RETRY =
      "No Internet Connection.\nPlease Retry";
}

class Session {
  static File profilephoto;
  static const String CustomerId = "CustomerId";
  static const String ParentId = "ParentId";
  static const String StudioName = "StudioName";
  static const String StudioMobileNo = "StudioMobileNo";
  static const String StudioEmail = "StudioEmail";
  static const String StudioLogo = "StudioLogo";
  static const String BranchId = "BranchId";
  static const String Password = "Password";
  static const String UserName = "UserName";
  static const String isSuccess = "false";
  static const String dataaddedd = "false";
  static const String Mobile = "Mobile";
  static const String StudioMobile = "StudioMobile";
  static const String Name = "Name";
  static const String CompanyName = "CompanyName";
  static const String Email = "Email";
  static const String IsVerified = "IsVerified";
  static const String GalleryId = "GalleryId";
  static const String StudioId = "StudioId";
  static const String Type = "Type";
  static const String PinSelection = "PinSelection";
  static const String SelectedPin = "SelectedPin";
  static String Image = "Image";
  static const String Photo = "Photo";

  static const String DOB = "DOB";
  static const String Gender = "Gender";
  static const String Address = "Address";
  static const String Pincode = "Pincode";
  static const String HospitalName = "HospitalName";
  static const String HospitalAddress = "HospitalAddress";
  static const String DoctorName = "DoctorName";
  static const String DoctorRegistrationNo = "DoctorRegistrationNo";
  static const String HandicappedNature_DisabilityPercentage =
      "HandicappedNature_DisabilityPercentage";

  static const String Landline = "Landline";
  static const String RegistrationDate = "RegistrationDate";
  static const String Place = "Place";
  static const String SignImage = "SignImage";
  static const String RailwayCertificate = "RailwayCertificate";
  static const String DisabilityCertificate = "DisabilityCertificate";
  static const String PhotoIdProof = "PhotoIdProof";
  static const String AddressProof = "AddressProof";
  static const String CurrentStatus = "CurrentStatus";
  static const String CardNo = "CardNo";
  static const String IssueDate = "IssueDate";
  static const String ValidTill = "ValidTill";

  //temp store
  //static const String ChapterId = "ChapterId";
  static const String CommitieId = "CommitieId";
  static const String SlideShowSpeed = "SlideShowSpeed";
  static const String PlayMusic = "PlayMusic";
  static const String MusicURLId = "MusicURLId";
  static const String MusicURL = "MusicURL";
  static const String SlideTime = "SlideTime";
}
