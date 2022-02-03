class MoreCardModel {
  MoreCardModel({
    this.icon = '',
    this.text = '',
    this.onTap,
  });
  
  final String icon;
  final String text;
  final Function()? onTap;
}