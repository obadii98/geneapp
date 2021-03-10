import 'package:flutter/material.dart';

class Team {
  String name;
  int type;
  int codeID;

  Team(this.name, this.type, this.codeID);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'codeID': codeID,
    };
  }
}