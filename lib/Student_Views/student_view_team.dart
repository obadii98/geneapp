import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_skeleton/flutter_skeleton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teams/Drawer/drawer_Contact.dart';
import 'package:teams/Drawer/drawer_about.dart';
import 'package:teams/Drawer/drawer_branchs.dart';
import 'package:teams/Drawer/drawer_learn.dart';
import 'package:teams/Main_Views/intro.dart';
import 'package:teams/Student_Views/student_add_code.dart';
import 'package:teams/Student_Views/view_team_lectures.dart';
import 'package:teams/Utils/drawerobject.dart';
import 'package:teams/Utils/styles.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:teams/Functions/secured_app.dart';
import 'package:teams/Utils/team.dart';
import '../main.dart';

class StudentViewTeam extends StatefulWidget {

  static List<dynamic> teamsIDs;
  var codeID;
  var codeType;

  StudentViewTeam(this.codeID, this.codeType);


  @override
  _StudentViewTeamState createState() => _StudentViewTeamState();
}

class _StudentViewTeamState extends State<StudentViewTeam> {

  var _studentID;
  bool _blocked = false;
  bool _isOnline = true;
  List<Map> list = new List<Map>();
  int _teamCount;
  String _studentName;
  var data;
  List<Map> codeList = new List<Map>();
  Map<String, int> yearSemCode = new Map<String, int>();
  bool _prefIsFive = true;


  _isFiveFun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _prefIsFive = prefs.getBool("isFive");
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none)
      _isOnline = false;
    else
      _isOnline = true;
    // print('test from isFive: ${prefs.getBool("isFive")}');
    // print("isFiveFun: $_prefIsFive");
  }

  _getTeamsInfo() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none){
      _isOnline = false;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _studentName = prefs.getString("studentName");
      data = [];
      // print('offline');
      data = await database.rawQuery('SELECT name, type, codeID FROM Team WHERE codeID = ${widget.codeID}');
      // print('list: $data');
      _teamCount = data.length;
      // print("offline teamcount: $_teamCount");
      // print("offline test: ${data[0]['name']}");
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // bool _prefIsFive = prefs.getBool("isFive");
      // print("isfive offline: $_prefIsFive");
      // if(_prefIsFive){
      //   data = list;
      //   _teamCount = data.length;
      //   print("teams offline5: ${data}");
      //   print("count: $_teamCount");
      //   print("team[2]['type']: ${data[2]['code']}");
      // }
      // else{
      //   data = [list];
      //   _teamCount = data.length;
      //   print("teams offline: ${data}");
      //   print("team 1 offline: ${data[0][0]["name"]}");
      // }
      // print('data: ${data[0]['name']}');
      // print('data lis t: ${list[0]['id']}');
    }
    else{
      _isOnline = true;
      // print('online');
      var _codeType = widget.codeType;
      if(_codeType == 5){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        _prefIsFive = true;
        prefs.setBool("isFive", _prefIsFive);
        _studentID = prefs.getString("studentID");
        _studentName = prefs.getString("studentName");
        // print('code ID from StudentViewTeam: ${widget.codeID}');
        var url = 'http://gene-team.com/public/api/codes/codeTeams';
        var response = await http.post(url,body: {'code_id': widget.codeID.toString()});
        // print("body: ${response.body}");
        data = json.decode(response.body);
        _teamCount = data.length;
        // print("team count: ${_teamCount}");
        await database.transaction((txn) async {
          // var id1 = await txn.rawDelete(
          //     'DELETE FROM Team');
          // print('deleted: $id1');
          for(int i = 0 ; i < data.length ; i++){
            Team t = new Team("${data['${i+1}'][0]['name'].toString()}", data['${i+1}'][0]['type'], widget.codeID);
            await txn.insert(
              'Team',
              t.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
            // int id1 = await txn.rawInsert(
            //     'INSERT INTO Team(name, type, codeID) VALUES("${data['${i+1}'][0]['name'].toString()}", ${data['${i+1}'][0]['type']}, ${widget.codeID})');
            // print('inserted$i: $id1');
          }
        });
        List<Map> list = await database.rawQuery('SELECT * FROM Team');
        // print("teams SQLlite: $list");

        // if(data == 'this code is blocked !'){
        //   setState(() {
        //     _blocked = true;
        //   });
        //   await database.transaction((txn) async {
        //     var id1 = await txn.rawDelete(
        //         'DELETE FROM Team WHERE codeID = ? ', [widget.codeID]);
        //     print('deleted: $id1');
        //     // int id2 = await txn.rawInsert(
        //     //     'INSERT INTO Team(name, type, codeID) VALUES("${data[0]['name'].toString()}", ${data[0]['type']}, ${widget.codeID})');
        //     // print('inserted: $id2');
        //     // Team t = new Team("${data[0]['name'].toString()}", data[0]['type'], widget.codeID);
        //     // await txn.insert(
        //     //   'Team',
        //     //   t.toMap(),
        //     //   conflictAlgorithm: ConflictAlgorithm.replace,
        //     // );
        //
        //   });
        // }
        // else{
        //
        // }
        // var i =0;
        // print("test ${data['${i+1}'][0]['id']}");
        // print('test: ${temp[0][1]['userName']}');
        // print("temp server: $temp");
        // print("num of teams: ${temp.length}");
        // data.clear();
        // for(int i = 0 ; i < temp.length ; i++){
        //   data = data + temp[i];
        // }
        // print('test data: $data');
        // print('wtf is data: $data');
        // data = temp[0];
        // print("data: $data");
        // print("data length: ${data.length}");
        // print("data value: ${data[15]['type']}");
      }
      else{
        SharedPreferences prefs = await SharedPreferences.getInstance();
        _prefIsFive = false;
        prefs.setBool("isFive", _prefIsFive);
        _studentID = prefs.getString("studentID");
        _studentName = prefs.getString("studentName");
        // print('student ID from StudentViewTeam: $_studentID');
        // print("code id: ${widget.codeID}");
        var url = 'http://gene-team.com/public/api/codes/codeTeams';
        var response = await http.post(url,body: {'code_id': widget.codeID.toString()});
        data = json.decode(response.body);
        print("data server: $data");
        print("first json: ${data[0]['code']}");
        _teamCount = data.length;
        print("team count: $_teamCount");
        // print("prefISFive: $_prefIsFive");
        await database.transaction((txn) async {
          // var id1 = await txn.rawDelete(
          //     'DELETE FROM Team');
          // print('deleted: $id1');
          // int id2 = await txn.rawInsert(
          //     'INSERT INTO Team(name, type, codeID) VALUES("${data[0]['name'].toString()}", ${data[0]['type']}, ${widget.codeID})');
          // print('inserted: $id2');
          Team t = new Team("${data[0]['name'].toString()}", data[0]['type'], widget.codeID);
          await txn.insert(
            'Team',
            t.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        });
        List<Map> list = await database.rawQuery('SELECT * FROM Team');
        print("teams SQLlite: $list");
        // if(response.body == 'this code is blocked !'){
        //   setState(() {
        //     _blocked = true;
        //   });
        //   await database.transaction((txn) async {
        //     var id1 = await txn.rawDelete(
        //         'DELETE FROM Team WHERE codeID = ? ', [widget.codeID]);
        //     print('deleted: $id1');
        //     // int id2 = await txn.rawInsert(
        //     //     'INSERT INTO Team(name, type, codeID) VALUES("${data[0]['name'].toString()}", ${data[0]['type']}, ${widget.codeID})');
        //     // print('inserted: $id2');
        //     // Team t = new Team("${data[0]['name'].toString()}", data[0]['type'], widget.codeID);
        //     // await txn.insert(
        //     //   'Team',
        //     //   t.toMap(),
        //     //   conflictAlgorithm: ConflictAlgorithm.replace,
        //     // );
        //
        //   });
        // }
        // else{
        //
        // }
      }

    }
  }

  _getText(var type){
    switch(type){
      case 1:
        return Container(
          child: Text(
            "فريق طبي تطوعي يهدف لتقديم كل من شأنه مساعدة الطلاب في تحصيلهم الجامعي",
            style: TextStyle(fontSize: 18.0),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,),
        );
        break;
      case 2:
        return Text(
          "فريق طبي يسير معكم نحو النجاح ⁦❤️⁩",
          style: TextStyle(fontSize: 18.0),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,);
        break;
      case 3:
        return Text(
          "فريق طبي يقدم لكم كل ما هو متميز وفريد ⁦💚",
          style: TextStyle(fontSize: 18.0),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,);
        break;
      case 4:
        return Text(
          "فريق مختص بتلخيص المحاضرات وتحويلها لمخططات وجداول لتسهيل الدراسة ⁦♥️",
          style: TextStyle(fontSize: 18.0),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,);
        break;
      case 5:
        return Text(
          "شرح عن الفريق وميزاته وما يقدمه بما لا يزيد عن سطرين",
          style: TextStyle(fontSize: 18.0),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,);
        break;
      case 6:
        return Text(
          "شرح عن الفريق وميزاته وما يقدمه بما لا يزيد عن سطرين",
          style: TextStyle(fontSize: 18.0),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,);
        break;
      case 7:
        return Text(
          "فريق طلابي هدفه الوصول بكم للأفضل...💙 من أجلكم 💙🦷",
          style: TextStyle(fontSize: 18.0),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,);
        break;
      case 8:
        return Text(
          "يرافق جميع طلاب الكليات الطبية من السنة التحضيرية حتى التخرج بأعمال مميزة ومهمة",
          style: TextStyle(fontSize: 18.0),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,);
        break;
      default:
        return Text(
          "شرح عن الفريق وميزاته وما يقدمه بما لا يزيد عن سطرين",
          style: TextStyle(fontSize: 18.0),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,);
        break;

    }
  }

  _getImg(var type){
    switch(type) {
      case 1:
        return Image.asset("assets/images/DNALogo.png",
          height: 160,
          width: 100,
          fit: BoxFit.contain,);
        break;
      case 2:
        return Image.asset("assets/images/OnlineLogo.jpg",
          height: 160,
          width: 100,
          fit: BoxFit.contain,);
        break;
      case 3:
        return Image.asset("assets/images/XRayLogo.png",
          height: 160,
          width: 100,
          fit: BoxFit.contain,);
        break;
      case 4:
        return Image.asset("assets/images/ABCLogo.jpg",
          height: 160,
          width: 100,
          fit: BoxFit.contain,);
        break;
      case 5:
        return Image.asset("assets/images/team.png",
          height: 160,
          width: 100,
          fit: BoxFit.fitWidth,);
        break;
      case 6:
        return Image.asset("assets/images/team.png",
          height: 160,
          width: 100,
          fit: BoxFit.fitWidth,);
        break;
      case 7:
        return Image.asset("assets/images/ALogo.png",
          height: 160,
          width: 100,
          fit: BoxFit.contain,);
        break;
      case 8:
        return Image.asset("assets/images/HakemLogo.png",
          height: 160,
          width: 100,
          fit: BoxFit.contain,);
        break;
      default:
        return Image.asset("assets/images/team.png",
          height: 160,
          width: 100,
          fit: BoxFit.fitWidth,);
        break;
    }
  }

  _forAnimation() {
    if(_blocked == true){
      return Center(
        child: Text('محظور!! يرجى مراجعة الفريق',style: TextStyle(fontSize: 24.0),),
      );
    }
    else{
      if(data.length <= 0){
        return CardListSkeleton(
          style: SkeletonStyle(
            theme: SkeletonTheme.Light,
            isShowAvatar: true,
            isCircleAvatar: false,
            barCount: 2,
          ),
        );
      }
      else {
        // print('test _forAnimation: ${data['1'][0]['id']}');
        return ListView.builder(
          itemCount: _teamCount,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                child: Column(
                  children: [
                    new FutureBuilder(
                      future: _isFiveFun(),
                      builder: (context, snapshot){
                        return FlatButton(
                          onPressed: () async{
                            _isOnline ?
                            _prefIsFive?
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ViewTeamLectures(data['${index+1}'][0]['type'],widget.codeID))):
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ViewTeamLectures(data[index]['type'],widget.codeID)))
                                :Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ViewTeamLectures(data[index]['type'],widget.codeID)));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              new FutureBuilder(
                                future: _isFiveFun(),
                                builder: (context, snapshot){
                                  return Container(
                                    height: 150,
                                    width: MediaQuery.of(context).size.width,
                                    child: _isOnline ?
                                    _prefIsFive ? _getImg(data['${index+1}'][0]['type']):_getImg(data[0]['type'])
                                        :_getImg(data[index]['type']),
                                  );
                                },
                              ),
                              new FutureBuilder(
                                future: _isFiveFun(),
                                builder: (context, snapshot){
                                  return Container(
                                    child: _isOnline ?
                                    _prefIsFive ? Text(data['${index+1}'][0]['name'], style: TextStyle(
                                        fontSize: 26.0, fontWeight: FontWeight.bold),textAlign: TextAlign.right,):
                                    Text(data[0]['name'], style: TextStyle(
                                        fontSize: 26.0, fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
                                        :Text(data[index]['name'], style: TextStyle(
                                        fontSize: 26.0, fontWeight: FontWeight.bold),textAlign: TextAlign.right,),
                                  );
                                },
                              ),
                              new FutureBuilder(
                                future: _isFiveFun(),
                                builder: (context, snapshot){
                                  return Container(
                                    height: 80,
                                    width: MediaQuery.of(context).size.width,
                                    child: _isOnline ?
                                    _prefIsFive ? _getText(data['${index+1}'][0]['type']):_getText(data[0]['type'])
                                        :_getText(data[index]['type']),
                                  );
                                },
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    new Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 25.0),
                      child: Divider(
                        height: 1.0,
                        color: Colors.black,
                        thickness: 0.5,
                      ),
                    ),
                  ],
                )
            );
          },
        );
      }
    }
  }

  _getCodes() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // _studentID = prefs.getString('studentID');
    // print("studentid from getcodes: $_studentID");
    // var urlC = 'http://gene-team.com/public/api/students/studentCodes';
    // var responseC = await http.post(urlC,body: {'student_id': _studentID});
    // var body = json.decode(responseC.body);
    codeList = await database.rawQuery('SELECT * FROM Code');
    // print('wtfwtf wtf: $codeList');
    // print("test list 0 yearname: ${codeList[0]['yearName']}");
    // print("body from getcodes: $body");
    // _drawerObjectList.clear();
    // for(int i = 0; i < body.length; i++){
    //   DrawerObject d = new DrawerObject.give(body[i]['id'], body[i]['year']['name'], body[i]['semester']['name'], body[i]['team_id']);
    //   _drawerObjectList.add(d);
    //   // yearSemCode["${body[i]['year']['name']} ${body[i]['semester']['name']}"] = body[i]['id'];
    // }
    // print('test object: ${_drawerObjectList[0].semName}');
    // print("yearSemCode: $yearSemCode");
  }

  //when pressing the back button
  showConfirmation(){
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("هل تريد الخروج من التطبيق؟"),
          actions: [
            FlatButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text("الغاء"),
            ),
            FlatButton(
              onPressed: (){
                SystemNavigator.pop();
              },
              child: Text("موافق"),
            ),
          ],
        )
    );
  }

  @override
  void initState() {
    _studentName = '';
    _teamCount = 0;
    data = [];
    SecuredApp.secureScreen();

  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return WillPopScope(
      onWillPop: (){
        showConfirmation();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Gene App"),
          centerTitle: true,
          leading: Container(),
        ),
        endDrawer: Container(
          width: MediaQuery.of(context).size.width*(75/100),
          height: MediaQuery.of(context).size.height,
          child: Drawer(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new Column(
                    children: [
                      new Container(
                        width: MediaQuery.of(context).size.width*(75/100),
                        height: MediaQuery.of(context).size.height*(15/100),
                        color: Styles.primaryColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            new Row(
                              children: [
                                new Padding(
                                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                  child: Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      color: Colors.white,
                                    ),
                                    child: Icon(Icons.person,color: Colors.black,),
                                  ),
                                ),
                                new Container(
                                  width: 90,
                                  child: FutureBuilder(
                                    builder: (context, snapshot){
                                      return Padding(
                                        padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                        child: Text(_studentName,style: TextStyle(fontSize: 18.0,color: Colors.white,fontWeight: FontWeight.bold)),
                                      );
                                    },
                                    future: _getTeamsInfo(),
                                  ),
                                ),
                              ],
                            ),
                            new Image.asset('assets/images/logo.png',width: 75),
                          ],
                        ),
                      ),
                      new FutureBuilder(
                        future: _getCodes(),
                        builder: (contextBuilder, snapshot){
                          return Container(
                            height: 100,
                            child: ListView.builder(
                              itemCount: codeList.length,
                              itemBuilder: (BuildContext context,int i){
                                return Container(
                                    child: FlatButton(
                                      onPressed: (){
                                        print("test from onpress ID: ${codeList[i]['codeID']}");
                                        print("test from onpress type: ${codeList[i]['codeType']}");
                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => StudentViewTeam(codeList[i]['codeID'], codeList[i]['codeType'])));
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          new Padding(
                                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                            child: Text('${codeList[i]['yearName']} ${codeList[i]['semName']}',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold)),
                                          ),
                                          new Icon(Icons.payment),
                                        ],
                                      ),
                                    )
                                );
                              },
                            ),
                          );
                        },
                      ),
                      new Divider(
                        height: 1.0,
                        color: Colors.black,
                        thickness: .5,
                      ),
                      new Container(
                          child: FlatButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => StudentAddCode()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                new Padding(
                                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                  child: Text("إضافة رمز تفعيل",style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold)),
                                ),
                                new Icon(Icons.payment),
                              ],
                            ),
                          )
                      ),
                      new Divider(
                        height: 1.0,
                        color: Colors.black,
                        thickness: .5,
                      ),
                      new Container(
                          child: FlatButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DrawerBranches()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                new Padding(
                                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                  child: Text("مراكز البيع",style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold)),
                                ),
                                new Icon(Icons.map,),
                              ],
                            ),
                          )
                      ),
                      new Container(
                          child: FlatButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DrawerLearn()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                new Padding(
                                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                                  child: Text("خطوات التفعيل",style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold)),
                                ),
                                new Icon(Icons.assignment),
                              ],
                            ),
                          )
                      ),
                      new Divider(
                        height: 1.0,
                        color: Colors.black,
                        thickness: .5,
                      ),
                      new Container(
                          child: FlatButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DrawerAbout()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                new Padding(
                                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                                  child: Text("حول التطبيق",style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold)),
                                ),
                                new Icon(Icons.info),
                              ],
                            ),
                          )
                      ),
                      new Container(
                          child: FlatButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DrawerContact()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                new Padding(
                                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                  child: Text("اتصل بنا",style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold)),
                                ),
                                new Icon(Icons.mail),
                              ],
                            ),
                          )
                      ),
                      // new Container(
                      //     child: FlatButton(
                      //       onPressed: (){
                      //         Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Intro()));
                      //       },
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.end,
                      //         children: [
                      //           new Padding(
                      //             padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                      //             child: Text("الدعم الفني",style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold)),
                      //           ),
                      //           new Icon(Icons.help),
                      //         ],
                      //       ),
                      //     )
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
            child: FutureBuilder(
              future: _getTeamsInfo(),
              builder: (context,snapshot){
                return _forAnimation();
              },
            )
        ),
      ),
    );
  }
}
