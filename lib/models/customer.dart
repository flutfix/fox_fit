class CustomerModel {
  CustomerModel({
    this.uid = '',
    this.fullName = '',
    this.phone = '',
    this.firstName = '',
    this.isVisible = false,
    this.trainerStageUid = '',
    this.trainerStageId = '',
    this.mainStageUid = '',
    this.image = '',
    this.birthDay = '',
    this.isBirthday = false,
    this.paidServicesBalance = 0,
    this.serviceUid,
    this.serviceName,
    this.balance,
    this.split,
    this.duration,
  });

  late String uid;
  late String fullName;
  late String phone;
  late String firstName;
  late bool isVisible;
  late String trainerStageUid;
  late String trainerStageId;
  late String mainStageUid;
  late String image;
  late String birthDay;
  late bool isBirthday;
  late int? paidServicesBalance;
  late String? serviceUid;
  late String? serviceName;
  late int? balance;
  late bool? split;
  late int? duration;

  CustomerModel.fromJson(Map<String, dynamic> json) {
    uid = json['Uid'] ?? '';
    fullName = json['Name'] ?? '';
    phone = json['Phone'] ?? '';
    firstName = json['FirstName'] ?? '';
    isVisible = json['IsVisible'] ?? false;
    trainerStageUid = json['TrainerStageUid'] ?? '';
    trainerStageId = json['TrainerStageId'] ?? '';
    mainStageUid = json['MainStageUid'] ?? '';
    image = json['PhotoBase64'] ?? '';
    birthDay = json['BirthDay'] ?? '';
    isBirthday = json['IsBirthDayToday'] ?? false;
    paidServicesBalance = json['PaidServicesBalance'] ?? 0;
    serviceUid = json['ServiceUid'];
    serviceName = json['NameService'];
    balance = json['Balance'];
    split = json['Split'];
    duration = json['Durations'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['Uid'] = uid;
    data['Name'] = fullName;
    data['Phone'] = phone;
    data['FirstName'] = firstName;
    data['IsVisible'] = isVisible;
    data['TrainerStageUid'] = trainerStageUid;
    data['TrainerStageId'] = trainerStageId;
    data['MainStageUid'] = mainStageUid;
    data['PhotoBase64'] = image;
    data['BirthDay'] = birthDay;
    data['IsBirthDayToday'] = isBirthday;
    data['PaidServicesBalance'] = paidServicesBalance;
    data['ServiceUid'] = serviceUid;
    data['NameService'] = serviceName;
    data['Balance'] = balance;
    data['Split'] = split;
    data['Durations'] = duration;
    return data;
  }
}
