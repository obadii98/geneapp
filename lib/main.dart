import 'dart:async';
import 'dart:io';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teams/Functions/notifications.dart';
import 'package:teams/Functions/secured_app.dart';
import 'package:teams/Student_Views/pdf.dart';
import 'package:teams/Utils/styles.dart';
import 'package:teams/route_generator.dart';
import 'Functions/dynamic_link_Service.dart';
import 'Main_Views/splash.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


Database database;
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() async {
  runApp(MyApp());
  SecuredApp.secureScreen();
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'gene.db');
  database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        'CREATE TABLE Team (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, type INTEGER, codeID INTEGER, UNIQUE(codeID,name))');
    await db.execute(
        'CREATE TABLE Course (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, courseID INTEGER UNIQUE, courseName TEXT, teamType INTEGER, codeID INTEGER)');
    await db.execute(
        'CREATE TABLE Lecture (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, courseID INTEGER, lecName TEXT, lecID INTEGER UNIQUE, teamType INTEGER, lec TEXT)');
    await db.execute(
        'CREATE TABLE Code (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, codeID INTEGER, codeType INTEGER, semID INTEGER, semName TEXT, yearName TEXT)');
  });
}

// private val CHANNEL = "poc.deeplink.flutter.dev/channel";

// _openPDF(String lecName, int lecID) async{
//   final filename = lecName;
//   String dir = (await getApplicationDocumentsDirectory()).path;
//   if (await File('$dir/$filename').exists()){
//     print("fuck");
//     navigatorKey.currentState.pushNamed('/pdf', arguments: '$dir/$filename');
//   }
//   else{
//     var lecurl = lecID;
//     print('path: $lecID');
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var code_id = prefs.getInt('codeID');
//     // print("hello");
//     var url = 'http://gene-team.com/public/api/lectures/downloadThePDF/$lecurl/${code_id}';
//     print('http://gene-team.com/public/api/lectures/downloadThePDF/$lecurl/${code_id}');
//     // print("hello2");
//     /// requesting http to get url
//     var request = await HttpClient().getUrl(Uri.parse(url));
//     // print("hello3");
//     /// closing request and getting response
//     var response = await request.close();
//     // print("hello4");
//     /// getting response data in bytes
//     var bytes = await consolidateHttpClientResponseBytes(response);
//     // print("hello5");
//     /// generating a local system file with name as 'filename' and path as '$dir/$filename'
//     File file = new File('$dir/$filename');
//     // print("hello6");
//     /// writing bytes data of response in the file.
//     await file.writeAsBytes(bytes);
//     // print("hello7");
//     print("fuck");
//     navigatorKey.currentState.pushNamed('/pdf', arguments: '$dir/$filename');
//   }
// }
//
// void initDynamicLinks() async{
//   // print("outside link");
//   FirebaseDynamicLinks.instance.onLink(
//       onSuccess: (PendingDynamicLinkData dynamicLink) async {
//         final Uri deepLink = dynamicLink?.link;
//         // print("outside link $deepLink");
//         if (deepLink != null) {
//           // print("dynamic link ouside $deepLink");
//           var lecName = deepLink.queryParameters['lecName'];
//           var lecID = int.parse(deepLink.queryParameters['lecID']);
//           // print("initDynamicLinks | lecName : $lecName lecID : $lecID");
//           _openPDF(lecName, lecID);
//         }
//       }, onError: (OnLinkErrorException e) async {
//     print('onLinkError');
//     print(e.message);
//   });
//
//   final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
//   final Uri deeplink = data?.link;
//   // print("outside also $deeplink");
//
//   if(deeplink != null){
//     // print("dynamic link 1haha $deeplink");
//     var lecName = deeplink.queryParameters['lecName'];
//     var lecID = int.parse(deeplink.queryParameters['lecID']);
//     // print("initDynamicLinks | lecName : $lecName lecID : $lecID");
//     _openPDF(lecName, lecID);
//   }
// }

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  bool _bool = false;

  PushNotificationManager test = new PushNotificationManager();
  final DynamicLinkService _dynamicLinkService = DynamicLinkService();
  Timer _timerLink;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    test.init();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _timerLink = new Timer(
        const Duration(milliseconds: 1000),
            () {
          _dynamicLinkService.retrieveDynamicLink(this.context);
        },
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timerLink != null) {
      _timerLink.cancel();
    }
    super.dispose();
  }


  // _openPDF(String lecName, int lecID) async{
  //   final filename = lecName;
  //   String dir = (await getApplicationDocumentsDirectory()).path;
  //   if (await File('$dir/$filename').exists()){
  //     print("fuck");
  //     navigatorKey.currentState.pushNamed('/pdf', arguments: '$dir/$filename');
  //   }
  //   else{
  //     var lecurl = lecID;
  //     print('path: $lecID');
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     var code_id = prefs.getInt('codeID');
  //     // print("hello");
  //     var url = 'http://gene-team.com/public/api/lectures/downloadThePDF/$lecurl/${code_id}';
  //     print('http://gene-team.com/public/api/lectures/downloadThePDF/$lecurl/${code_id}');
  //     // print("hello2");
  //     /// requesting http to get url
  //     var request = await HttpClient().getUrl(Uri.parse(url));
  //     // print("hello3");
  //     /// closing request and getting response
  //     var response = await request.close();
  //     // print("hello4");
  //     /// getting response data in bytes
  //     var bytes = await consolidateHttpClientResponseBytes(response);
  //     // print("hello5");
  //     /// generating a local system file with name as 'filename' and path as '$dir/$filename'
  //     File file = new File('$dir/$filename');
  //     // print("hello6");
  //     /// writing bytes data of response in the file.
  //     await file.writeAsBytes(bytes);
  //     // print("hello7");
  //     print("fuck");
  //     navigatorKey.currentState.pushNamed('/pdf', arguments: '$dir/$filename');
  //   }
  // }

  // void initDynamicLinks() async{
  //   // print('deepkink main 1');
  //   FirebaseDynamicLinks.instance.onLink(
  //       onSuccess: (PendingDynamicLinkData dynamicLink) async {
  //         final Uri deepLink = dynamicLink?.link;
  //         // print("hello deeplink22 $deepLink");
  //         // print("lec name ${deepLink.queryParameters['lecName']}");
  //         // print("lec id ${int.parse(deepLink.queryParameters['lecID'])}");
  //         if (deepLink != null) {
  //           _bool = true;
  //           // print("hello deeplink1 $deepLink");
  //           // print("dynamic link shi");
  //           var lecName = deepLink.queryParameters['lecName'];
  //           var lecID = int.parse(deepLink.queryParameters['lecID']);
  //           // print("initDynamicLinks | lecName : $lecName lecID : $lecID");
  //           await _openPDF(lecName, lecID);
  //         }
  //         else
  //           print('its null');
  //       }, onError: (OnLinkErrorException e) async {
  //     print('onLinkError');
  //     print(e.message);
  //   });
  //   final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
  //   // print("data???? $data");
  //   final Uri deeplink = data?.link;
  //   // print("hello deeplink $deeplink");
  //   // print('fuck69 $deeplink');
  //   if(deeplink != null){
  //     _bool = true;
  //     // print("dynamic link shu1");
  //     var lecName = deeplink.queryParameters['lecName'];
  //     var lecID = int.parse(deeplink.queryParameters['lecID']);
  //     // print("initDynamicLinks | lecName : $lecName lecID : $lecID");
  //     await _openPDF(lecName, lecID);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // DeepLinkBloc _bloc = DeepLinkBloc();
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Hacen Digital Arabia',
        primaryColor: Styles.primaryColor,
      ),
      onGenerateRoute: RouteGenerator.generatorRoute,
      initialRoute: _bool ? '/pdf':'/',
      // home: Scaffold(
      //   body: Provider<DeepLinkBloc>(
      //       create: (context) => _bloc,
      //       dispose: (context, bloc) => bloc.dispose(),
      //       child: SplashScreen()
      //   ),
      // ),
    );
  }
}
