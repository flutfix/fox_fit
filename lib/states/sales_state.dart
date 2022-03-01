class SalesState {
  SalesState({
    this.isPersonal = true,
    this.personalType = false,
    this.isStarting = false,
  });

  /// Выбранный тип тренировки (Персональная или групповая)
  bool isPersonal;

  ///----[Персональная]
  /// Выбранный тип персональной тренировки (Персональная или сплит)
  bool personalType;

  /// Продление или стартовый
  bool isStarting;

  ///----
}
