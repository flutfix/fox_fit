class Trainer {
  Trainer({
    this.uid = '',
    this.name = '',
  });

  late String uid;
  late String name;

  Trainer.fromJson(Map<String, dynamic> json) {
    uid = json['Uid'] ?? '';
    name = json['Name'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['Uid'] = uid;
    data['Name'] = name;
    return data;
  }
}
