class ServicesModel {
  late final String name;
  late final String uid;
  late final int duration;
  late final bool trial;
  late final bool split;
  late final int price;

  ServicesModel({
    this.name = '',
    this.uid = '',
    this.duration = 0,
    this.trial = false,
    this.split = false,
    this.price = 0,
  });

  ServicesModel.fromJson(Map<String, dynamic> json) {
    name = json['Name'] ?? '';
    uid = json['Uid'] ?? '';
    duration = json['Duration'] != null ? int.parse(json['Duration']) : 0;
    trial = json['Trial'] ?? false;
    split = json['Split'] ?? false;
    price = json['Price'] ?? 0;
  }
}

class PaidServiceBalance {
  late final String uid;
  late final int balance;

  PaidServiceBalance({
    this.uid = '',
    this.balance = 0,
  });

  PaidServiceBalance.fromJson(Map<String, dynamic> json) {
    uid = json['ServiceUid'] ?? '';
    balance = json['Balance'] ?? 0;
  }
}
