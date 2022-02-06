class DetailedInfo {
  DetailedInfo({
    this.header = '',
    this.value = 'Информация отсутствует',
  });

  late String header;
  late String value;

  DetailedInfo.fromJson(Map<String, dynamic> json) {
    header = json['Header'] ?? '';
    value = json['Value'] != null
        ? json['Value'] == ''
            ? 'Информация отсутствует'
            : json['Value']
        : 'Информация отсутствует';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['Header'] = header;
    data['Value'] = value;
    return data;
  }
}
