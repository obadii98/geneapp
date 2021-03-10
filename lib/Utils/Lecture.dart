import 'package:flutter/material.dart';

class Lecture {
  int courseID;
  String lecName;
  int lecID;
  int teamType;
  String lec;

  Lecture(this.courseID, this.lecName, this.lecID, this.teamType, this.lec);

  Map<String, dynamic> toMap() {
    return {
      'courseID': courseID,
      'lecName': lecName,
      'lecID': lecID,
      'teamType': teamType,
      'lec': lec
    };
  }
}