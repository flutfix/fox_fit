class NotificationModel {
  NotificationModel({
    this.text = '',
    this.date = '',
    this.time = '',
    this.phone = '',
    this.customerName = '',
    this.customerUid = '',
    this.pipelineUid = '',
    this.isVisible = false,
    this.isNew = false,
  });

  late String text;
  late String date;
  late String time;
  late String phone;
  late String customerName;
  late String customerUid;
  late String pipelineUid;
  late bool isVisible;
  late bool isNew;

  NotificationModel.fromJson(Map<String, dynamic> json) {
    text = json['Text'] ?? '';
    date = json['Date'] ?? '';
    time = json['Time'] ?? '';
    phone = json['Phone'] ?? '';
    customerName = json['Customer_Name'] ?? '';
    customerUid = json['Customer_Uid'] ?? '';
    pipelineUid = json['PipelineUid'] ?? '';
    isVisible = json['IsVisible'] ?? false;
    isNew = json['IsNew'] ?? false;
  }
}
