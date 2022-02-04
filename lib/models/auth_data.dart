class AuthDataModel {
  AuthDataModel({
    this.data,
    this.emails,
    this.users = const [],
    this.buggedAppVersions = const [],
  });

  late DataModel? data;
  late EmailsModel? emails;
  late List<UserModel>? users;
  late List<BuggedAppVersions>? buggedAppVersions;

  AuthDataModel.fromJson(Map<String, dynamic> json) {
    data =
        json['AuthData'] != null ? DataModel.fromJson(json['AuthData']) : null;
    emails =
        json['Emails'] != null ? EmailsModel.fromJson(json['Emails']) : null;
    if (json['Users'] != null) {
      users = [];
      json['Users'].forEach((v) {
        users!.add(UserModel.fromJson(v));
      });
    }
    if (json['BuggedAppVersions'] != null) {
      buggedAppVersions = [];
      json['BuggedAppVersions'].forEach((v) {
        buggedAppVersions!.add(BuggedAppVersions.fromJson(v));
      });
    }
  }
}


class DataModel {
  DataModel({
    this.hashL = '',
    this.hashP = '',
    this.pathToBase = '',
    this.hash = '',
    this.licenseKey = '',
    this.vApple = '',
    this.vAndroid = '',
    this.clubName = '',
    this.customerName = '',
    this.whatsAppDefaultGreeting = '',
    this.supportPhone = '',
    this.id = '',
  });

  late String hashL;
  late String hashP;
  late String pathToBase;
  late String hash;
  late String licenseKey;
  late String vApple;
  late String vAndroid;
  late String clubName;
  late String customerName;
  late String whatsAppDefaultGreeting;
  late String supportPhone;
  late String id;

  DataModel.fromJson(Map<String, dynamic> json) {
    hashL = json['HashL'] ?? '';
    hashP = json['HashP'] ?? '';
    pathToBase = json['PathToBase'] ?? '';
    hash = json['Hash'] ?? '';
    licenseKey = json['License_key'] ?? '';
    vApple = json['VersionApple'] ?? '';
    vAndroid = json['VersionAndroid'] ?? '';
    clubName = json['ClubName'] ?? '';
    customerName = json['CustomerName'] ?? '';
    whatsAppDefaultGreeting = json['WhatsAppDefaultGreeting'] ?? '';
    supportPhone = json['SupportPhoneNumber'] ?? '';
    id = json['Id'] ?? '';
  }
}

class EmailsModel {
  EmailsModel({
    this.admin = '',
    this.foxFit = '',
  });

  late String admin;
  late String foxFit;

  EmailsModel.fromJson(Map<String, dynamic> json) {
    admin = json['Admin_email'];
    foxFit = json['Foxfit_email'];
  }
}

class UserModel {
  UserModel({
    this.name = '',
    this.id = '',
    this.role = '',
  });

  late String name;
  late String id;
  late String role;

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    id = json['Uid'];
    role = json['Role'];
  }
}

class BuggedAppVersions {
  BuggedAppVersions({
    this.planform = '',
    this.version = '',
  });

  late String planform;
  late String version;

  BuggedAppVersions.fromJson(Map<String, dynamic> json) {
    planform = json['PlatformString'];
    version = json['AppVersion'];
  }
}
