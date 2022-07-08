abstract class Mocks {
  /// История для тренерской статистики
  static final History historyStats = History(
    fullName: 'Агапитова Лариса Николаевна',
    service: '1ПТ 45мин Мастер Аква',
    dataTime: DateTime(21, 3, 14, 12, 55),
  );

  /// Сервисы для тренерской статистики
  static const Service serviceStats = Service(
    name: '1 пт 55мин Матер ТЗ',
    count: 2,
    amount: 23,
  );

  /// Сервисы для тренерской статистики
  static const Service clientStats = Service(
    name: 'Уолтер Уайт',
    count: 2,
    amount: 23,
  );
}

class History {
  final String fullName;
  final String service;
  final DateTime dataTime;

  const History({
    required this.fullName,
    required this.service,
    required this.dataTime,
  });
}

class Service {
  final String name;
  final int count;
  final int amount;

  const Service({
    required this.name,
    required this.count,
    required this.amount,
  });
}

class Client {
  final String name;
  final String count;
  final String amount;

  const Client({
    required this.name,
    required this.count,
    required this.amount,
  });
}
