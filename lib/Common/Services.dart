import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:opicxo/Common/ClassList.dart';
import 'package:opicxo/Common/Constants.dart' as cnst;
import 'ClassList.dart';
import 'package:xml2json/xml2json.dart';
import 'Constants.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

Xml2Json xml2json = new Xml2Json();
Dio dio = new Dio();

class Services {
  //login with username
  static Future<List> PhotographerLogin(
      String mobileNo, String username, String password) async {
    String url = cnst.API_URL +
        'PhotographerLogin?mobileNo=$mobileNo&Username=$username&Password=$password';
    print("PhotographerLogin URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("PhotographerLogin Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("PhotographerLogin Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  //login funtion
  static Future<List> MemberLogin(String mobileNo) async {
    String url = API_URL + 'CustomerLogin?mobileNo=$mobileNo';
    print("MemberLogin URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("MemberLogin Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["Data"].length > 0) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("something went wrong");
      }
    } catch (e) {
      print("MemberLogin Erorr : " + e.toString());
      throw Exception("something went wrong");
    }
  }

  static Future<String> StudioDigitalCard(String mobileNo) async {
    String url = API_URL + 'CheckDigitalCardMember?mobileNo=$mobileNo';
    print("StudioDigitalCard URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        String data = "";
        print("StudioDigitalCard Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["Data"].length > 0) {
          print(memberDataClass["Data"]);
          data = memberDataClass["Data"];
        } else {
          data = "";
        }
        return data;
      } else {
        throw Exception("something went wrong");
      }
    } catch (e) {
      print("StudioDigitalCard Erorr : " + e.toString());
      throw Exception("something went wrong");
    }
  }

  static Future<List> userloginwithusername(
      String username, String password) async {
    String url =
        API_URL + 'CustomerLogin?username=$username&password=$password';
    print("userloginwithusername URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("userloginwithusername Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["Data"].length > 0) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("something went wrong");
      }
    } catch (e) {
      print("userloginwithusername Erorr : " + e.toString());
      throw Exception("something went wrong");
    }
  }

  static Future<SaveDataClass> sendOtpCode(String mobileno, String code) async {
    String url = API_URL + 'SendVerificationCode?mobileNo=$mobileno&code=$code';
    print("sendOtpCode URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: "0");
        print("sendOtpCode Response: " + response.data.toString());
        var memberDataClass = response.data;
        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        throw Exception("something went wrong");
      }
    } catch (e) {
      print("sendOtpCode Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  //Get Album Details
  static Future<List> getAlbumData(String galleryId) async {
    String url = API_URL + 'GetDashboardAlbumList?customerId=$galleryId';
    print("getAlbumData URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("getAlbumData Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["Data"].length > 0) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = null;
        }
        return list;
      } else {
        throw Exception("something went wrong");
      }
    } catch (e) {
      print("getAlbumData Erorr : " + e.toString());
      throw Exception("something went wrong");
    }
  }

  static Future<List> GetAboutUs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String StudioId = preferences.getString(Session.StudioId);
    String url = API_URL + 'GetStudioAboutList?studioId=$StudioId';
    print("GetAboutUs URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetAboutUs Response: " + response.data.toString());
        var data = response.data;
        if (data["IsSuccess"] == true && data["Data"].length > 0) {
          list = data["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("something went wrong");
      }
    } catch (e) {
      print("GetAboutUs Erorr : " + e.toString());
      throw Exception("something went wrong");
    }
  }

  static Future<List> GetAlbumData(String AlbumId) async {
    String url = API_URL + 'GetCustomerAlbumByAlbumId?albumId=$AlbumId';
    print("GetAlbumData URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetAlbumData Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["Data"].length > 0) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("something went wrong");
      }
    } catch (e) {
      print("GetAlbumData Erorr : " + e.toString());
      throw Exception("something went wrong");
    }
  }

  static Future<List> GetAlbumAllData(String AlbumId) async {
    String url = API_URL + 'GetAlbumPhotoList?AlbumId=$AlbumId';
    print("GetAlbumAllData URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetAlbumAllData Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["Data"].length > 0) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("something went wrong");
      }
    } catch (e) {
      print("GetAlbumAllData Erorr : " + e.toString());
      throw Exception("something went wrong");
    }
  }

  static Future<List> GetCategoryAlbumAllData(String AlbumId) async {
    String url = API_URL + 'GetPortfolioList?CategoryId=$AlbumId';
    print("GetPortfolioList URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetPortfolioList Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["Data"].length > 0) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("something went wrong");
      }
    } catch (e) {
      print("GetPortfolioList Erorr : " + e.toString());
      throw Exception("something went wrong");
    }
  }

  static Future<List> GetSelectedAlbumData(String AlbumId) async {
    String url = API_URL + 'GetSelectedAlbumPhotoList?AlbumId=$AlbumId';
    print("GetSelectedAlbumData URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetSelectedAlbumData Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["Data"].length > 0) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("something went wrong");
      }
    } catch (e) {
      print("GetSelectedAlbumData Erorr : " + e.toString());
      throw Exception("something went wrong");
    }
  }

  static Future<List> GetPendingAlbumData(String AlbumId) async {
    String url = API_URL + 'GetPendingAlbumPhotoList?AlbumId=$AlbumId';
    print("GetPendingAlbumData URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetPendingAlbumData Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["Data"].length > 0) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("something went wrong");
      }
    } catch (e) {
      print("GetPendingAlbumData Erorr : " + e.toString());
      throw Exception("something went wrong");
    }
  }

  static Future<SaveDataClass> UploadSelectedImage(body) async {
    print(body.toString());
    String url = API_URL + 'UpdateAlbumSelection';
    print("UploadSelectedImage url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: "0");
        print("UploadSelectedImage Response: " + response.data.toString());
        var memberDataClass = response.data;
        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("UploadSelectedImage");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("UploadSelectedImage Error ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  //Send Fcm Token
  static Future<List> SendTokanToServer(String fcmToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String CustomerId = prefs.getString(Session.CustomerId);

    String url = API_URL +
        'UpdateCustomerFCMToken?customerId=$CustomerId&fcmToken=$fcmToken';
    print("SendTokanToServer URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("SendTokanToServer  URL: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true) {
          print(memberDataClass["Data"]);
          //list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("something went wrong");
      }
    } catch (e) {
      print("SendTokanToServer URL : " + e.toString());
      throw Exception("something went wrong");
    }
  }

  //get Notification From Server
  static Future<List> GetNotificationFromServer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String CustomerId = prefs.getString(Session.CustomerId);

    String url = API_URL + 'GetCustomerNotificationList?customerId=$CustomerId';
    print("GetNotificationFromServer URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetNotificationFromServer: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("something went wrong");
      }
    } catch (e) {
      print("GetNotificationFromServer Error : " + e.toString());
      throw Exception("something went wrong");
    }
  }

  static Future<List<MemberClass1>> CardIdNight(String mobileno) async {
    String url = "http://digitalcard.co.in/DigitalcardService.asmx/" +
        'Member_login?type=mobilelogin&mobileno=$mobileno';
    print("CardIdNight URL: " + url);
    final response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        List<MemberClass1> list = [];
        print("CardIdNight Response: " + response.body);

        final jsonResponse = json.decode(response.body);
        MemberDataClass1 memberDataClass =
            new MemberDataClass1.fromJson(jsonResponse);

        if (memberDataClass.ERROR_STATUS == false)
          list = memberDataClass.Data;
        else
          list = [];

        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("CardIdNight Check Login Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> GetCardIdLogin(String type, String MobileNo) async {
    String url = "http://pmc.studyfield.com/Service.asmx/" +
        'Login?type=$type&mobile=$MobileNo';
    //String url = API_URL + 'GetLoginWithFCM?mobile=$mobileNo&fcmToken=$fcmToken';
    print("CheckCardId URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("CheckCardId Data: " + response.data.toString());
        var memberDataClass = jsonDecode(response.data);
        if (memberDataClass["RECORDS"] == true) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("CardIdLogin Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List<MemberClass1>> UpdateCardId(
      String type, String cardid, String userid) async {
    String url = "http://pmc.studyfield.com/Service.asmx/" +
        'UpdateDigitalCardId?type=$type&cardid=$cardid&userid=$userid';
    print("UpdateCardId URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List<MemberClass1> list;
        print("UpdateCardId: " + response.data.toString());
        // var memberDataClass = response.data;
        // if (memberDataClass["MESSAGE"] == "Successfully !" ) {
        //   print(memberDataClass["Data"]);
        //   list = memberDataClass["Data"];
        // } else {
        //   list = [];
        // }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("UpdateCardId : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List<MemberClass1>> MemberLogin1(String mobileno) async {
    String url = "http://digitalcard.co.in/DigitalcardService.asmx/" +
        'Member_login?type=mobilelogin&mobileno=$mobileno';
    print("MemberLogin123 URL: " + url);
    final response = await http.get(url);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (response.statusCode == 200) {
        List<MemberClass1> list;
        print("MemberLogin123 Response: " + response.body);
        final jsonResponse = json.decode(response.body);
        MemberDataClass1 memberDataClass =
            new MemberDataClass1.fromJson(jsonResponse);
        if (memberDataClass.ERROR_STATUS == false) {
          list = memberDataClass.Data;
        } else
          list = [];
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("Check Login Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass1> MemberSignUp(data) async {
    String url = cnst.digitalcard + 'MemberSignUp';
    print("digitalcardsignup URL: " + url);
    final response = await http.post(url, body: data);
    try {
      if (response.statusCode == 200) {
        SaveDataClass1 data;
        final jsonResponse = json.decode(response.body);
        SaveDataClass1 saveDataClass =
            new SaveDataClass1.fromJson(jsonResponse);
        print("digitalcardsignup data: ");
        print(jsonResponse);
        return saveDataClass;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      print("digitalcardsignup Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> CodeVerification(String MemberId) async {
    String url = API_URL + 'CustomerOTPVerification?customerId=$MemberId';
    print("CodeVerification URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: "0");
        print("CodeVerification Response: " + response.data.toString());
        var memberDataClass = response.data;
        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        throw Exception("something went wrong");
      }
    } catch (e) {
      print("CodeVerification Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<List> GetCustomerGalleryList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String CustomerId = prefs.getString(Session.CustomerId);
    String url = API_URL + 'GetCustomerGalleryList?customerId=$CustomerId';
    print("GetCustomerGalleryList URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetCustomerGalleryList Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["Data"].length > 0) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("something went wrong");
      }
    } catch (e) {
      print("GetCustomerGalleryList Erorr : " + e.toString());
      throw Exception("something went wrong");
    }
  }

  static Future<List> GetportfolioGalleryList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String StudioId = prefs.getString(Session.StudioId);

    String url = API_URL + 'GetCategoryList?studioId=$StudioId';
    print("GetportfolioGalleryList URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetCategoryList Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["Data"].length > 0) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("something went wrong");
      }
    } catch (e) {
      print("GetportfolioGalleryList Erorr : " + e.toString());
      throw Exception("something went wrong");
    }
  }

  static Future<List> GetCustomerAlbumList(String galleryId) async {
    String url = API_URL + 'GetCustomerAlbumList?galleryId=$galleryId';
    print("GetCustomerAlbumList URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetCustomerAlbumList Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["Data"].length > 0) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("something went wrong");
      }
    } catch (e) {
      print("GetCustomerAlbumList Erorr : " + e.toString());
      throw Exception("something went wrong");
    }
  }

  static Future<SaveDataClass> AddCustomer(body) async {
    print(body.toString());
    String url = API_URL + 'SaveCustomerList';
    print("AddCustomer url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: "0");
        print("AddCustomer Response: " + response.data.toString());
        var memberDataClass = response.data;
        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("Error AddGuestList");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error AddCustomer ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> GuestSignUp(body) async {
    print(body.toString());
    String url = API_URL + 'SaveCustomerList';
    print("AddCustomer url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: "0");
        print("AddCustomer Response: " + response.data.toString());
        var memberDataClass = response.data;
        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("Error AddGuestList");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error AddCustomer ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> GetStudioSocialLinkList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String customerId = prefs.getString(Session.StudioId);

    String url = API_URL + 'GetStudioSocialLinkList?customerId=$customerId';
    print("GetStudioSocialLinkList URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetStudioSocialLinkList Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["Data"].length > 0) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("something went wrong");
      }
    } catch (e) {
      print("GetStudioSocialLinkList Erorr : " + e.toString());
      throw Exception("something went wrong");
    }
  }

  static Future<List<timeClass>> getTimeSlots(date) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String StudioId = preferences.getString(Session.StudioId);
    String url =
        API_URL + 'GetAppointmentSlotList?studioId=$StudioId&date=$date';
    print("getTimeSlots Url:" + url);

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        List<timeClass> timeClassList = [];
        print("getTimeSlots Response" + response.data.toString());

        final jsonResponse = response.data;
        timeClassData data = new timeClassData.fromJson(jsonResponse);

        timeClassList = data.Data;

        return timeClassList;
      } else {
        throw Exception("No Internet Connection");
      }
    } catch (e) {
      print("Check getTimeSlots Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> BookAppointment(body) async {
    print(body.toString());
    String url = API_URL + 'SaveAppointment';
    print("BookAppointment url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: "0");
        print("BookAppointment Response: " + response.data.toString());
        var memberDataClass = response.data;
        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("Error AddGuestList");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error BookAppointment ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> MyCustomerList(String CustomerId) async {
    String url = API_URL + 'GetCustomerChildList?customerId=$CustomerId';
    print("GetChildCustomerList URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetChildCustomerList Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["Data"].length > 0) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("something went wrong");
      }
    } catch (e) {
      print("GetChildCustomerList Erorr : " + e.toString());
      throw Exception("something went wrong");
    }
  }

  static Future<SaveDataClass> DeleteChileCustomer(String ChildGuestId) async {
    String url = API_URL + 'DeleteCustomerWithChild?id=$ChildGuestId';
    print("Delete ChildGuest URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: "");
        print("Delete ChildGuest Response: " + response.data.toString());
        var responseData = response.data;
        saveData.Message = responseData["Message"];
        saveData.IsSuccess = responseData["IsSuccess"];
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("Delete ChildGuest Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> UpdateInviteStatus(String ChildGuestId) async {
    String url = API_URL + 'UpdateCustomerStatus?customerId=$ChildGuestId';
    print("UpdateInvite Status URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: "");
        print("UpdateInvite Status Response: " + response.data.toString());
        var responseData = response.data;
        saveData.Message = responseData["Message"];
        saveData.IsSuccess = responseData["IsSuccess"];
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("UpdateInvite Status Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> ShareAppMessage(String StudioId) async {
    String url = API_URL + 'GetStudioInviteMessage?studioId=$StudioId';
    print("Studio App Share URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: "");
        print("Studio App Share Response: " + response.data.toString());
        var responseData = response.data;
        saveData.Message = responseData["Message"];
        saveData.IsSuccess = responseData["IsSuccess"];
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("Studio App Share Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> UpdateGallrySelection(
      String galleryId, String status) async {
    String url = API_URL +
        'UpdateGallerySelectionStatus?galleryId=$galleryId&status=$status';
    print("Studio App Share URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: "");
        print("Studio App Share Response: " + response.data.toString());
        var responseData = response.data;
        saveData.Message = responseData["Message"];
        saveData.IsSuccess = responseData["IsSuccess"];
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("Studio App Share Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<List> GetSoundData() async {
    String url = API_URL + 'GetBackgroundMusic';
    print("GetBackgroundMusic URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetBackgroundMusic Response: " + response.data.toString());
        var data = response.data;
        if (data["IsSuccess"] == true && data["Data"].length > 0) {
          list = data["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("something went wrong");
      }
    } catch (e) {
      print("GetBackgroundMusic Erorr : " + e.toString());
      throw Exception("something went wrong");
    }
  }

  static Future<List> GetImageComment(String Imageid) async {
    String url = API_URL + 'GetAlbumPhotoComment?albumPhotoId=$Imageid';
    print("GetAlbumPhotoComment URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetAlbumPhotoComment Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["Data"].length > 0) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("something went wrong");
      }
    } catch (e) {
      print("GetAlbumPhotoComment Erorr : " + e.toString());
      throw Exception("something went wrong");
    }
  }

  static Future<List> GetPhotogrpaherOffers(String photographerid) async {
    String url = API_URL +
        'GetPhotographerOffers?type=offers&photographerid=$photographerid';
    print("GetPhotogrpaherOffers URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetPhotogrpaherOffers Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["Data"].length > 0) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("something went wrong");
      }
    } catch (e) {
      print("GetPhotogrpaherOffers Erorr : " + e.toString());
      throw Exception("something went wrong");
    }
  }

  static Future<SaveDataClass> AddComment(body) async {
    print(body.toString());
    String url = API_URL + 'SaveAlbumPhotoComment';
    print("SaveAlbumPhotoComment url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: "0");
        print("SaveAlbumPhotoComment Response: " + response.data.toString());
        var memberDataClass = response.data;
        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("Error SaveAlbumPhotoComment");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error SaveAlbumPhotoComment ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> DeleteComment(String id) async {
    String url = API_URL + 'DeleteAlbumPhotoComment?id=$id';
    print(" DeleteAlbumPhotoComment URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: "0");
        print("DeleteAlbumPhotoComment Response: " + response.data.toString());
        var memberDataClass = response.data;
        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("Error DeleteAlbumPhotoComment");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("DeleteAlbumPhotoComment URL : " + e.toString());
      throw Exception("something went wrong");
    }
  }

  static Future<List> GetAllAdvertisement() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String StudioId = preferences.getString(Session.StudioId);
    String url = API_URL + 'GetStudioAdvertisement?studioId=$StudioId';
    print("GetStudioAdvertisement URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetStudioAdvertisement Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["Data"].length > 0) {
          print("memberclass" + memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("something went wrong");
      }
    } catch (e) {
      print("GetStudioAdvertisement Erorr : " + e.toString());
      throw Exception("something went wrong");
    }
  }

  static Future<Map> GetUserData(String parentid, String name, String mobile,
      String email, String studioid, String fcmtoken) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String StudioId = preferences.getString(Session.StudioId);
    String url = API_URL +
        'UpdateUserData?parentid=$parentid&name=$name&mobile=$mobile&email=$email&studioid=$studioid&fcmtoken=$fcmtoken';
    print("UpdateUserData URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        Map list;
        print("UpdateUserData Response: " + response.data.toString());
        var memberDataClass = response.data;
        // if (memberDataClass["IsSuccess"] == true &&
        //     memberDataClass["Data"].length > 0) {
        list = memberDataClass;
        // } else {
        //   list = "";
        // }
        return list;
      } else {
        throw Exception("something went wrong");
      }
    } catch (e) {
      print("GetStudioAdvertisement Erorr : " + e.toString());
      throw Exception("something went wrong");
    }
  }

  static Future<List> GetAdvertisementDetail(String id) async {
    String url = API_URL + 'GetAdvertisementDetail?advertisementId=$id';
    print("GetStudioAdvertisement URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetStudioAdvertisement Response: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["Data"].length > 0) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("something went wrong");
      }
    } catch (e) {
      print("GetStudioAdvertisement Erorr : " + e.toString());
      throw Exception("something went wrong");
    }
  }

  static Future<String> CheckDigitalCardMember(String mobileNo) async {
    String url = API_URL +
        'CheckDigitalCardMember?type=digitalcard&mobileNo=${mobileNo}';
    print("CheckDigitalCardMember URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        String responceData;
        print("res: ${response.data["IsSuccess"]}");

        print("CheckDigitalCardMember Response: " + response.data.toString());
        var dataCardResponse = response.data;
        if (dataCardResponse["IsSuccess"].toString() == "true") {
          print("in");
          responceData = dataCardResponse["Data"];
        } else {
          responceData = "";
        }
        return responceData;
      } else {
        throw Exception("something went wrong");
      }
    } catch (e) {
      print("CheckDigitalCardMember URL : " + e.toString());
      throw Exception("something went wrong");
    }
  }

  static Future<SaveDataClass> SaveShare(data) async {
    String url = 'http://digitalcard.co.in/DigitalCardService.asmx/AddShare';
    print("AddShare URL: " + url);
    final response = await http.post(url, body: data);
    try {
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        SaveDataClass saveDataClass = new SaveDataClass.fromJson(jsonResponse);
        return saveDataClass;
      } else {
        throw Exception("something went wrong");
      }
    } catch (e) {
      print("SaveTA Error : " + e.toString());
      throw Exception("something went wrong");
    }
  }

  static Future<SaveDataClass> UpdateProfile(
      String customerId, String name, String mobile, String email) async {
    String url = API_URL +
        'UpdateCustomerData?customerId=$customerId&name=$name&mobile=$mobile&email=$email';
    print(" UpdateCustomerData URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: "0");
        print("UpdateCustomerData Response: " + response.data.toString());
        var memberDataClass = response.data;
        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("Error UpdateCustomerData");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("UpdateCustomerData URL : " + e.toString());
      throw Exception("something went wrong");
    }
  }

  static Future<SaveDataClass> UpdateCustomerPhoto(body) async {
    print(body.toString());
    String url = API_URL + 'UpdateCustomerPhoto';
    print("UpdateCustomerPhoto : " + url);
    dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.options.responseType = ResponseType.json;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: '0');

        xml2json.parse(response.data.toString());
        var jsonData = xml2json.toParker();
        var responseData = json.decode(jsonData);

        print("UpdateCustomerPhoto Response: " +
            responseData["ResultData"].toString());

        saveData.Message = responseData["ResultData"]["Message"].toString();
        saveData.IsSuccess = responseData["ResultData"]["IsSuccess"] == "true";
        saveData.Data = responseData["ResultData"]["Data"].toString();

        return saveData;
      } else {
        print("Server Error");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("App Error ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> GetAddressBranch(String customerId) async {
    String url = API_URL + 'GetAddressBranch?customerId=$customerId';
    print("GetAddressBranch URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetAddressBranch Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("GetAddressBranch Erorr : " + e.toString());
      throw Exception(e);
    }
  }
}
