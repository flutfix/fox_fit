class Service {
  late String name;
  late String uid;
  late String duration;
  late bool trial;

  Service({
    this.name = '',
    this.uid = '',
    this.duration = '',
    this.trial = false,
  });

  Service.fromJson(Map<String, dynamic> json) {
    name = json['Name'] ?? '';
    uid = json['Uid'] ?? '';
    duration = json['Duration'] ?? '';
    trial = json['Trial'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['Name'] = name;
    data['Uid'] = uid;
    data['Duration'] = duration;
    data['Trial'] = trial;
    return data;
  }
}

class PaidServiceBalance {
  late String uid;
  late int balance;

  PaidServiceBalance({
    this.uid = '',
    this.balance = 0,
  });

  PaidServiceBalance.fromJson(Map<String, dynamic> json) {
    uid = json['ServiceUid'] ?? '';
    balance = json['Balance'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['ServiceUid'] = uid;
    data['Balance'] = balance;
    return data;
  }
}
