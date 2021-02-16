class MemberClass1 {
  String Id;
  String Name;
  String Company;
  String Role;
  String website;
  String About;
  String Image;
  String Mobile;
  String Email;
  String Whatsappno;
  String Facebooklink;
  String CompanyAddress;
  String CompanyPhone;
  String CompanyUrl;
  String CompanyEmail;
  String GMap;
  String Twitter;
  String Google;
  String Linkedin;
  String Youtube;
  String Instagram;
  String CoverImage;
  String MyReferralCode;
  String RegistrationRefCode;
  String JoinDate;
  String ExpDate;
  String MemberType;
  String RegistrationPoints;
  String PersonalPAN;
  String CompanyPAN;
  String GstNo;
  String AboutCompany;
  String ShareMsg;
  bool IsActivePayment;

  MemberClass1({
    this.Id,
    this.Name,
    this.Company,
    this.Role,
    this.website,
    this.About,
    this.Image,
    this.Mobile,
    this.Email,
    this.Whatsappno,
    this.Facebooklink,
    this.CompanyAddress,
    this.CompanyPhone,
    this.CompanyUrl,
    this.CompanyEmail,
    this.GMap,
    this.Twitter,
    this.Google,
    this.Linkedin,
    this.Youtube,
    this.Instagram,
    this.CoverImage,
    this.MyReferralCode,
    this.RegistrationRefCode,
    this.JoinDate,
    this.ExpDate,
    this.MemberType,
    this.RegistrationPoints,
    this.PersonalPAN,
    this.CompanyPAN,
    this.GstNo,
    this.AboutCompany,
    this.ShareMsg,
    this.IsActivePayment,
  });

  factory MemberClass1.fromJson(Map<String, dynamic> json) {
    return MemberClass1(
      Id: json['Id'] as String,
      Name: json['Name'] as String,
      Company: json['Company'] as String,
      Role: json['Role'] as String,
      website: json['website'] as String,
      About: json['About'] as String,
      Image: json['Image'] as String,
      Mobile: json['Mobile'] as String,
      Email: json['Email'] as String,
      Whatsappno: json['Whatsappno'] as String,
      Facebooklink: json['Facebooklink'] as String,
      CompanyAddress: json['CompanyAddress'] as String,
      CompanyPhone: json['CompanyPhone'] as String,
      CompanyUrl: json['CompanyUrl'] as String,
      CompanyEmail: json['CompanyEmail'] as String,
      GMap: json['Map'] as String,
      Twitter: json['Twitter'] as String,
      Google: json['Google'] as String,
      Linkedin: json['Linkedin'] as String,
      Youtube: json['Youtube'] as String,
      Instagram: json['Instagram'] as String,
      CoverImage: json['CoverImage'] as String,
      MyReferralCode: json['MyReferralCode'] as String,
      RegistrationRefCode: json['RegistrationRefCode'] as String,
      JoinDate: json['JoinDate'] as String,
      ExpDate: json['ExpDate'] as String,
      MemberType: json['MemberType'] as String,
      RegistrationPoints: json['RegistrationPoints'] as String,
      PersonalPAN: json['PersonalPAN'] as String,
      CompanyPAN: json['CompanyPAN'] as String,
      GstNo: json['GstNo'] as String,
      AboutCompany: json['AboutCompany'] as String,
      ShareMsg: json['ShareMsg'] as String,
      IsActivePayment: json['IsActivePayment'] as bool,
    );
  }
}

class MemberDataClass1 {
  String MESSAGE;
  String ORIGINAL_ERROR;
  bool ERROR_STATUS;
  bool RECORDS;
  List<MemberClass1> Data;

  MemberDataClass1(
      {this.MESSAGE,
        this.ORIGINAL_ERROR,
        this.ERROR_STATUS,
        this.RECORDS,
        this.Data});

  factory MemberDataClass1.fromJson(Map<String, dynamic> json) {
    return MemberDataClass1(
        MESSAGE: json['MESSAGE'] as String,
        ORIGINAL_ERROR: json['ORIGINAL_ERROR'] as String,
        ERROR_STATUS: json['ERROR_STATUS'] as bool,
        RECORDS: json['RECORDS'] as bool,
        Data: json['Data']
            .map<MemberClass1>((json) => MemberClass1.fromJson(json))
            .toList());
  }
}

class SaveDataClass1 {
  String MESSAGE;
  String ORIGINAL_ERROR;
  bool ERROR_STATUS;
  bool RECORDS;

  SaveDataClass1(
      {this.MESSAGE, this.ORIGINAL_ERROR, this.ERROR_STATUS, this.RECORDS});

  factory SaveDataClass1.fromJson(Map<String, dynamic> json) {
    return SaveDataClass1(
        MESSAGE: json['MESSAGE'] as String,
        ORIGINAL_ERROR: json['ORIGINAL_ERROR'] as String,
        ERROR_STATUS: json['ERROR_STATUS'] as bool,
        RECORDS: json['RECORDS'] as bool);
  }
}

class SaveDataClass{
  String Message;
  bool IsSuccess;
  String Data;

  SaveDataClass({this.Message, this.IsSuccess, this.Data});

  factory SaveDataClass.fromJson(Map<String, dynamic> json) {
    return SaveDataClass(
        Message: json['Message'] as String,
        IsSuccess: json['IsSuccess'] as bool,
        Data: json['Data'] as String);
  }
}
class MemberClassData {
  String MESSAGE;
  String ORIGINAL_ERROR;
  bool ERROR_STATUS;
  bool RECORDS;
  List<MemberClass> Data;

  MemberClassData({
    this.MESSAGE,
    this.ORIGINAL_ERROR,
    this.ERROR_STATUS,
    this.RECORDS,
    this.Data,
  });

  factory MemberClassData.fromJson(Map<String, dynamic> json) {
    return MemberClassData(
        MESSAGE: json['MESSAGE'] as String,
        ORIGINAL_ERROR: json['ORIGINAL_ERROR'] as String,
        ERROR_STATUS: json['ERROR_STATUS'] as bool,
        RECORDS: json['RECORDS'] as bool,
        Data: json['Data']
            .map<MemberClass>((json) => MemberClass.fromJson(json))
            .toList());
  }
}

class MemberClass {
  String memberId;
  String memberName;

  MemberClass({this.memberId, this.memberName});

  factory MemberClass.fromJson(Map<String, dynamic> json) {
    return MemberClass(
        memberId: json['groupcode'] as String,
        memberName: json['groupname'] as String);
  }
}



class timeClassData {
  String Message;
  bool IsSuccess;
  List<timeClass> Data;

  timeClassData({
    this.Message,
    this.IsSuccess,
    this.Data,
  });

  factory timeClassData.fromJson(Map<String, dynamic> json) {
    return timeClassData(
        Message: json['Message'] as String,
        IsSuccess: json['IsSuccess'] as bool,
        Data: json['Data']
            .map<timeClass>((json) => timeClass.fromJson(json))
            .toList());
  }
}

class timeClass {
  String id;
  String time;
  String IsBooked;

  timeClass({this.id, this.time, this.IsBooked});

  factory timeClass.fromJson(Map<String, dynamic> json) {
    return timeClass(
      id: json['Id'].toString() as String,
      time: json['Title'].toString() as String,
      IsBooked: json['IsBooked'].toString() as String,
    );
  }
}
