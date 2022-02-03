class DetailedInfo {
  DetailedInfo({
    this.header = '',
    this.value = '',
  });

  late String header;
  late String value;

  DetailedInfo.fromJson(Map<String, dynamic> json) {
    header = json['Header'] ?? '';
    value = json['Value'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['Header'] = header;
    data['Value'] = value;
    return data;
  }
}
