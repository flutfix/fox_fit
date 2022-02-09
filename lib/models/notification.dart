class NotificationModel {
  NotificationModel({
    this.text = '',
    this.date = '',
    this.time = '',
    this.customerName = '',
    this.customerUid = '',
    this.isVisible = false,
    this.isNew = false,
  });

  late String text;
  late String date;
  late String time;
  late String customerName;
  late String customerUid;
  late bool isVisible;
  late bool isNew;

  NotificationModel.fromJson(Map<String, dynamic> json) {
    text = json['Text'] ?? '';
    date = json['Date'] ?? '';
    time = json['Time'] ?? '';
    customerName = json['Customer_Name'] ?? '';
    customerUid = json['Customer_Uid'] ?? '';
    isVisible = json['IsVisible'] ?? false;
    isNew = json['IsNew'] ?? false;
  }
}
