import 'package:flutter/material.dart';
import 'package:teams/Main_Views/splash.dart';
import 'package:teams/Student_Views/pdf.dart';
import 'package:teams/main.dart';

class RouteGenerator {
  static Route<dynamic> generatorRoute(RouteSettings settings){
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => SplashScreen()
        );
      case '/pdf':
        if(args is String)
          return MaterialPageRoute(
              builder: (_) => pdfView(args)
          );
        else
          return MaterialPageRoute(
              builder: (_) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text("error"),
                  ),
                  body: Center(
                    child: Text("error"),
                  ),
                );
              }
          );
        break;
      default:
        return MaterialPageRoute(
          builder: (_) {
            return Scaffold(
              appBar: AppBar(
                title: Text("error"),
              ),
              body: Center(
                child: Text("error"),
              ),
            );
          }
        );
    }
  }
}