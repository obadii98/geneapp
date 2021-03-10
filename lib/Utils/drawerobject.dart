import 'package:flutter/material.dart';

class DrawerObject {
  int codeID;
  String yearName;
  String semName;
  int codeType;

  DrawerObject();

  DrawerObject.give(this.codeID, this.yearName, this.semName, this.codeType);

  DrawerObject.fromJson(Map<String, dynamic> json)
      : codeID = json['codeID'],
        yearName = json['yearName'],
        semName = json['semName'];

  Map<String, dynamic> toJson() =>
      {
        'codeID': codeID,
        'yearName': yearName,
        'semName': semName,
      };
}