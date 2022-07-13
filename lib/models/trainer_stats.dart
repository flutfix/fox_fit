import 'dart:developer';

class TrainerPerfomanceModel {
  TrainerPerfomanceModel({
    required this.month,
    required this.perfomanceStages,
    this.amount = '',
    this.plan = '',
    this.done = '',
    required this.historicalData,
  });

  late String month;
  late String amount;
  late String plan;
  late String done;
  late HistoricalDataModel historicalData;
  late List<TrainerPerfomanceStageModel> perfomanceStages;

  TrainerPerfomanceModel.fromJson(Map<String, dynamic> json) {
    month = json['Month'] ?? '';
    amount = json['Amount'] ?? '';
    plan = json['Plan'] ?? '';
    done = json['Done'] ?? '';
    historicalData = json['HistoricalData'] != null
        ? HistoricalDataModel.fromJson(json['HistoricalData'])
        : HistoricalDataModel();
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

class HistoricalDataModel {
  HistoricalDataModel({
    this.history = const <HistoryStats>[],
    this.services = const [],
    this.clients = const [],
  });

  late List<HistoryStats> history;
  late List<ServiceStats> services;
  late List<ClientStats> clients;

  HistoricalDataModel.fromJson(Map<String, dynamic> json) {
    if (json['ArrayServicesRendered'] != null) {
      history = [];
      json['ArrayServicesRendered'].forEach((v) {
        history.add(HistoryStats.fromJson(v));
      });
    }
    if (json['ArrayDifferentServices'] != null) {
      services = [];
      json['ArrayDifferentServices'].forEach((v) {
        services.add(ServiceStats.fromJson(v));
      });
    }
    if (json['ArrayDifferentClients'] != null) {
      clients = [];
      json['ArrayDifferentClients'].forEach((v) {
        clients.add(ClientStats.fromJson(v));
      });
    }
  }
}

class HistoryStats {
  late final String customer;
  late final String service;
  late final DateTime date;
  late final DateTime time;

  HistoryStats({
    required this.customer,
    required this.service,
    required this.date,
    required this.time,
  });

  HistoryStats.fromJson(Map<String, dynamic> json) {
    customer = json['Client'] ?? '';
    service = json['Service'] ?? '';
    date = json['ClassDate'] != null
        ? _convertToDate(json['ClassDate'])
        : DateTime.now();
    time = json['ClassTime'] != null
        ? _convertToTime(json['ClassTime'])
        : DateTime.now();
  }

  DateTime _convertToDate(String classDate) {
    DateTime date = DateTime(
      int.parse(classDate.split('.')[2]),
      int.parse(classDate.split('.')[1]),
      int.parse(classDate.split('.')[0]),
    );
    return date;
  }

  DateTime _convertToTime(String classTime) {
    DateTime time = DateTime(
      0,
      0,
      0,
      int.parse(classTime.split(':')[0]),
      int.parse(classTime.split(':')[1]),
    );
    return time;
  }
}

class ServiceStats {
  late final String service;
  late final int amount;

  ServiceStats({
    required this.service,
    required this.amount,
  });

  ServiceStats.fromJson(Map<String, dynamic> json) {
    service = json['Service'] ?? '';
    amount = json['CountServices'] ?? 0;
  }
}

class ClientStats {
  late final String customer;
  late final int amount;

  ClientStats({
    required this.customer,
    required this.amount,
  });

  ClientStats.fromJson(Map<String, dynamic> json) {
    customer = json['Client'] ?? '';
    amount = json['CountClients'] ?? 0;
  }
}
