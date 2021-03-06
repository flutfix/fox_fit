class TrainerPerfomanceModel {
  TrainerPerfomanceModel({
    required this.month,
    required this.perfomanceStages,
    this.amount = '',
    this.plan = '',
    this.done = '',
  });

  late String month;
  late String amount;
  late String plan;
  late String done;
  late List<TrainerPerfomanceStageModel> perfomanceStages;

  TrainerPerfomanceModel.fromJson(Map<String, dynamic> json) {
    month = json['Month'] ?? '';
    amount = json['Amount'] ?? '';
    plan = json['Plan'] ?? '';
    done = json['Done'] ?? '';
    if (json['TrainerPerformanceStages'] != null) {
      perfomanceStages = [];
      json['TrainerPerformanceStages'].forEach((v) {
        perfomanceStages.add(TrainerPerfomanceStageModel.fromJson(v));
      });
    }
  }
}

class TrainerPerfomanceStageModel {
  TrainerPerfomanceStageModel({
    this.name = '',
    this.quantity = '',
    this.conversion = '',
  });

  late String name;
  late String quantity;
  late String conversion;

  TrainerPerfomanceStageModel.fromJson(Map<String, dynamic> json) {
    name = json['Name'] ?? '';
    quantity = json['Quantity'] ?? '';
    conversion = json['Conversion'] ?? '';
  }
}
