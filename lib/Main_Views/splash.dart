import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teams/Admin_Views/admin_main.dart';
import 'package:teams/Main_Views/login.dart';
import 'package:teams/Student_Views/student_view_team.dart';
import 'package:teams/Team_Views/team_main.dart';
import 'package:teams/Utils/styles.dart';
import 'package:teams/Team_Views/add_lecture.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'intro.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with WidgetsBindingObserver  {


  _getLibs() async {
    // var connectivityResult = await (Connectivity().checkConnectivity());
    // if (connectivityResult == ConnectivityResult.none){
    //   print('offline');
    //   TeamMain.dropDownLib.clear();
    //   List<Map> list = await database.rawQuery('SELECT * FROM Libraries');
    //   for(int i = 0; i < list.length; i++)
    //     TeamMain.dropDownLib[list[i]['name']] = list[i]['id'];
    // }
    // else{
      print("in lib:");
      TeamMain.dropDownLib.clear();
      var url = 'http://gene-team.com/public/api/librarys';
      var response = await http.get(url);
      var data = json.decode(response.body) as List;
      for(int i = 0; i < data.length; i++)
        TeamMain.dropDownLib[data[i]['name']] = data[i]['id'];
      print('librarys: ${TeamMain.dropDownLib}');
      await database.transaction((txn) async {
        var id1 = await txn.rawDelete(
            'DELETE FROM Libraries');
        for(int i = 0 ; i < data.length ; i++){
          int id1 = await txn.rawInsert(
              'INSERT INTO Libraries(id, name) VALUES(${data[i]['id']}, "${data[i]['name']}")');
          print('inserted$i: $id1');
        }
      });
    // }
  }
  _getUnis() async {
    TeamMain.dropDownUnis.clear();
    var url = 'http://gene-team.com/public/api/universitys';
    var response = await http.get(url);
    TeamMain.data = json.decode(response.body) as List;
    for(int i = 0; i < TeamMain.data.length; i++)
      TeamMain.dropDownUnis[TeamMain.data[i]['name']] = TeamMain.data[i]['id'];
    print(TeamMain.dropDownUnis);
  }
  _getTeamCourses() async {
    AddLecture.dropdownCourse.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _teamToken = prefs.getString('teamToken');
    var url = 'http://gene-team.com/public/api/teams/teamcourses?token=$_teamToken';
    var response = await http.post(url);
    var data = json.decode(response.body);
    print(response.statusCode);
    print('body: $data');
    AddLecture.myCourseSelection = data[0]['name'];
    print('first course name: ${AddLecture.myCourseSelection}');
    if(data.length < 0)
      return;
    else
      for(int i = 0 ; i < data.length ; i++)
        AddLecture.dropdownCourse[data[i]['name']] = data[i]['id'];
    print('Courses: ${AddLecture.dropdownCourse}');
  }


  Future checkFirstSeen() async {
    Future.delayed(Duration(seconds: 2), () {
      // 5s over, navigate to a new page
      this.initDynamicLinks();
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    bool _asAdmin = (prefs.getBool('asAdmin') ?? false);
    bool _asStudent = (prefs.getBool('asStudent') ?? false);
    bool _asTeam = (prefs.getBool('asTeam') ?? false);
    bool _asLib = (prefs.getBool('asLib') ?? false);
    if (_seen) {
      if(_asAdmin) {
        _getUnis();
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new AdminMain()));
      }
      else if(_asStudent){
        // initDynamicLinks();
        _getUnis();
        List<Map> list = await database.rawQuery('SELECT * FROM Code');
        print("splash test id: ${list[0]['codeID']} type: ${list[0]['codeType']}");
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new StudentViewTeam(list[0]['codeID'],list[0]['codeType'])));
      }
      else if(_asTeam){
        _getUnis();
        _getTeamCourses();
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new TeamMain()));
      }
      else {
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new LoginPage()));
      }
    }
    else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new Intro()));
    }
  }

  _openPDF(String lecName, int lecID) async{
    final filename = lecName;
    String dir = (await getApplicationDocumentsDirectory()).path;
    if (await File('$dir/$filename').exists()){
      navigatorKey.currentState.pushNamed('/pdf', arguments: '$dir/$filename');
    }
    else{
      var lecurl = lecID;
      print('path: $lecID');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var code_id = prefs.getInt('codeID');
      // print("hello");
      var url = 'http://gene-team.com/public/api/lectures/downloadThePDF/$lecurl/${code_id}';
      print('http://gene-team.com/public/api/lectures/downloadThePDF/$lecurl/${code_id}');
      // print("hello2");
      /// requesting http to get url
      var request = await HttpClient().getUrl(Uri.parse(url));
      // print("hello3");
      /// closing request and getting response
      var response = await request.close();
      // print("hello4");
      /// getting response data in bytes
      var bytes = await consolidateHttpClientResponseBytes(response);
      // print("hello5");
      /// generating a local system file with name as 'filename' and path as '$dir/$filename'
      File file = new File('$dir/$filename');
      // print("hello6");
      /// writing bytes data of response in the file.
      await file.writeAsBytes(bytes);
      // print("hello7");
      print("fuck");
      navigatorKey.currentState.pushNamed('/pdf', arguments: '$dir/$filename');
    }
  }

  void initDynamicLinks() async{
    print("in");
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          final Uri deepLink = dynamicLink?.link;
          if (deepLink != null) {
            print("deepLink splash: $deepLink");
            var isLec = deepLink.pathSegments.contains('lecture');
            if(isLec){
              var lecName = deepLink.queryParameters['lecName'];
              var lecID = int.parse(deepLink.queryParameters['lecID']);
              print("initDynamicLinks | lecName : $lecName lecID : $lecID");
              await _openPDF(lecName, lecID);
            }
          }
          else
            print('its null');
        }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deeplink = data?.link;
    print("outside deeplink: $deeplink");
    if(deeplink != null){
      var lecName = deeplink.queryParameters['lecName'];
      var lecID = int.parse(deeplink.queryParameters['lecID']);
      print("initDynamicLinks | lecName : $lecName lecID : $lecID");
      await _openPDF(lecName, lecID);
    }
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Future.delayed(Duration(seconds: 2), () {
      // 5s over, navigate to a new page
      // this.initDynamicLinks();
      checkFirstSeen();
    });
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Styles.primaryColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Image.asset("assets/images/logo.png"),
          new Text("Gene App",style: new TextStyle(fontSize: 38,color: Colors.white,decoration: TextDecoration.none,fontFamily: 'Markazi_Text',),),
          new Text("Your pen to study",style: new TextStyle(fontSize: 22,color: Colors.white,decoration: TextDecoration.none,fontFamily: 'Markazi_Text',fontWeight: FontWeight.normal),)
        ],
      ),
    );
  }
}
