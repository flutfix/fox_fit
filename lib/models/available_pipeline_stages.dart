class AvailablePipelineStages {
  late String uid;
  late String name;
  late String id;

  AvailablePipelineStages({
    this.uid = '',
    this.name = '',
    this.id = '',
  });

  AvailablePipelineStages.fromJson(Map<String, dynamic> json) {
    uid = json['Uid'] ?? '';
    name = json['Name'] ?? '';
    id = json['Id'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['Uid'] = uid;
    data['Name'] = name;
    data['Id'] = id;
    return data;
  }
}
