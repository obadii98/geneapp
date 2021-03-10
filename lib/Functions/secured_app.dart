import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class SecuredApp extends StatefulWidget {

  static Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  _SecuredAppState createState() => _SecuredAppState();
}

class _SecuredAppState extends State<SecuredApp> {




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
