import 'package:flutter/material.dart';

class Course {
  int courseID;
  String courseName;
  int teamType;
  int codeID;

  Course(this.courseID, this.courseName, this.teamType, this.codeID);

  Map<String, dynamic> toMap() {
    return {
      'courseID': courseID,
      'courseName': courseName,
      'teamType': teamType,
      'codeID': codeID
    };
  }
}