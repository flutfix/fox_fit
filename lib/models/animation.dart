/// Конфигурация анимации для выбора типа (Персональной или Сплит)
class AnimationModel {
  AnimationModel({
    this.activeWidth = 145,
    this.activeHeight = 60,
    this.inactiveWidth = 111,
    this.inactiveHeight = 46,
    this.duration = 150,
  });

  double activeWidth;
  double activeHeight;
  double inactiveWidth;
  double inactiveHeight;
  int duration;
}
