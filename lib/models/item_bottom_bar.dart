import 'package:flutter/material.dart';

class ItemBottomBarModel {
  ItemBottomBarModel({
    this.icon = '',
    this.name = '',
    this.shortName = '',
    this.uid = '',
    this.id = '',
    this.visible = false,
    this.transferedToAdmin = false,
    this.order = -1,
    this.initialStage = false,
    this.changingDateStage = false,
  });

  late String icon;
  late String name;
  late String shortName;
  late String uid;
  late String id;
  late bool visible;
  late bool transferedToAdmin;
  late int order;
  late bool initialStage;
  late bool changingDateStage;

  ItemBottomBarModel.fromJson(Map<String, dynamic> json) {
    name = json['Name'] ?? '';
    uid = json['Uid'] ?? '';
    id = json['Id'] ?? '';
    shortName = json['ShortName'] ?? '';
    visible = json['Visible'] ?? false;
    transferedToAdmin = json['TransferredToAdministrator'] ?? false;
    order = json['Order'] ?? -1;
    initialStage = json['InitialStage'] ?? false;
    changingDateStage = json['ChangingDateStage'] ?? false;
  }
}
