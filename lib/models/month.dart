class MonthModel {
  const MonthModel({
    required this.year,
    required this.month,
    required this.number,
    required this.days,
  });

  final int year;
  final String month;
  final int number;
  final List<DaysModel> days;
}

class DaysModel {
  const DaysModel({
    required this.day,
    required this.number,
  });

  final String day;
  final int number;
}
