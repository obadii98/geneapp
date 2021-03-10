import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_skeleton/flutter_skeleton.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:teams/Drawer/drawer_Contact.dart';
import 'package:teams/Drawer/drawer_about.dart';
import 'package:teams/Drawer/drawer_branchs.dart';
import 'package:teams/Drawer/drawer_learn.dart';
import 'package:teams/Student_Views/pdf.dart';
import 'package:teams/Student_Views/student_add_code.dart';
import 'package:teams/Student_Views/student_view_team.dart';
import 'package:teams/Team_Views/team_main.dart';
import 'package:teams/Utils/Lecture.dart';
import 'package:teams/Utils/course.dart';
import 'package:teams/Utils/styles.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../main.dart';
import 'add_order.dart';


class ViewTeamLectures extends StatefulWidget {

  var teamType;
  var teamCode;

  ViewTeamLectures(var id, var codeID){
    teamType = id;
    teamCode = codeID;
  }

  @override
  _ViewTeamLecturesState createState() => _ViewTeamLecturesState();
}

class _ViewTeamLecturesState extends State<ViewTeamLectures> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _libNameCont = new TextEditingController();
  TextEditingController _dateCont = new TextEditingController(text: DateTime.now().toString());
  final _formKey = GlobalKey<FormState>();
  var courses;
  bool _isOnline = true;
  List<Map> codeList = new List<Map>();
  var lectures;
  List<String> yearSem = new List<String>();
  List<Map> courseList = new List<Map>();
  List<Map> lecList = new List<Map>();
  int courseLength;
  String _studentName;
  Map<dynamic,dynamic> courseLec = new Map<dynamic,dynamic>();

  @override
  void initState() {
    _studentName = '';
    courses = 'init';
    lectures = 'init';
  }


  _getLibs(int teamType) async {
    print("in lib");
    TeamMain.dropDownLib.clear();
    var url = 'http://gene-team.com/public/api/team_librarys/TeamLibrary/$teamType';
    var response = await http.get(url);
    print("here $url");
    var data = json.decode(response.body) as List;
    print("here code: ${response.statusCode}");
    print("here data $data");
    for(int i = 0; i < data.length; i++)
      TeamMain.dropDownLib[data[i]['library']['name']] = data[i]['library_id'];
    print('library: ${TeamMain.myLibSelection}');
    print('from getLibs: ${TeamMain.dropDownLib}');
  }

  _getImg(var type){
    switch(type) {
      case 1:
        return AssetImage("assets/images/first_page/dna.png");
        break;
      case 2:
        return AssetImage("assets/images/first_page/online.png");
        break;
      case 3:
        return AssetImage("assets/images/first_page/xray.png");
        break;
      case 4:
        return AssetImage("assets/images/first_page/abc-team.png");
        break;
      case 5:
        return AssetImage("assets/images/first_page/for-all.png");
        break;
      case 6:
        return AssetImage("assets/images/first_page/for-all.png");
        break;
      case 7:
        return AssetImage("assets/images/first_page/dna.png");
        break;
      case 8:
        return AssetImage("assets/images/first_page/dna.png");
        break;
      default:
        return AssetImage("assets/images/first_page/dna.png");
        break;
    }
  }

  _getStudentInfo()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _studentName = prefs.getString('studentName');
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text("Gene App"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
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
                                  future: _getStudentInfo(),
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
          child: FutureBuilder(
            future: _getCourses(),
            builder: (contextBuilder, snapshot){
              return _forAnimation();
            },
          )
      ),
    );
  }

  _getCourses() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none){
      _isOnline = false;
      // print('offline');
      courses = '';
      courseLec.clear();
      courseList = await database.rawQuery('SELECT * FROM Course WHERE teamType= ? AND codeID = ?',['${widget.teamType}','${widget.teamCode}']);
      var test = await database.rawQuery('SELECT * FROM Lecture WHERE courseID=?',['42']);
      print("test offline $test");
      print("courseList offline: ${courseList}");
      for(int i = 0 ; i < courseList.length ; i++){
        courseLec[courseList[i]['courseID']] = await database.rawQuery('SELECT * FROM Lecture WHERE courseID=?',['${courseList[i]['courseID']}']);
      }
      print('courseLec offline: $courseLec');
      // print('test: ${courseLec[courseList[1]['courseID']]}');
      // courses = list;
      // print('data: ${courses[0]['id']}');
      // print("teams offline: $list");
      // print('data list: ${list[0]['id']}');
    }
    else{
      _isOnline = true;
      var url = 'http://gene-team.com/public/api/students/studentCourses';
      // print("hello");
      // print("team type: ${widget.teamType}");
      // print("team code: ${widget.teamCode}");
      var response = await http.post(url,body: {'team_id':widget.teamType.toString(), 'code_id': widget.teamCode.toString()});
      // print("after");
      courses = json.decode(response.body);
      // print('coueses length: ${courses.length}');
      courseLength = courses.length;
      print('courses online: $courses');
      await database.transaction((txn) async {
        // var id1 = await txn.rawDelete(
        //     'DELETE FROM Course');
        for(int i = 0 ; i < courses.length ; i++){
          Course c = new Course(courses[i]['id'], "${courses[i]['name']}", widget.teamType, widget.teamCode);
          var oo = await txn.insert(
            'Course',
            c.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
          // print("test online $oo");
          // int id1 = await txn.rawInsert(
          //     'INSERT INTO Course(courseID, courseName, teamType) VALUES(${courses[i]['id']}, "${courses[i]['name']}", ${widget.teamType})');
          // print('inserted$i: $id1');
        }
      });
      for(int i = 0 ; i < courses.length ; i++){
        var url = 'http://gene-team.com/public/api/courses/lectures/${courses[i]['id']}';
        var response = await http.get(url);
        courseLec[courses[i]['id']] = json.decode(response.body);
      }
      // print("courseLec online: $courseLec");
      // var coursele = courseLec[courses[1]['id']][1]['name'];
      await database.transaction((txn) async {
        // var id1 = await txn.rawDelete(
        //     'DELETE FROM Lecture');
        for(int i = 0 ; i < courses.length ; i++){
          for(int j = 0 ; j < courseLec[courses[i]['id']].length ; j++){
            Lecture l = new Lecture(courses[i]['id'], "${courseLec[courses[i]['id']][j]['name']}", courseLec[courses[i]['id']][j]['id'], widget.teamType, "${courseLec[courses[i]['id']][j]['lecture']}");
            var oo = await txn.insert(
              'Lecture',
              l.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
            // print('lec test $oo');
            // int id1 = await txn.rawInsert(
            //     'INSERT INTO Lecture(courseID, lecName, lecID, teamType) VALUES(${courses[i]['id']}, "${courseLec[courses[i]['id']][j]['name']}", ${courseLec[courses[i]['id']][j]['id']}, ${widget.teamType})');
            // print('inserted$i: $id1');
          }
        }
      });
      // print("courseLec: $courseLec");
      // print("map2: $coursesNameID");
    }

  }

  _forAnimation() {
    if(_isOnline){
      if(courses == "init"){
        return CardListSkeleton(
          style: SkeletonStyle(
            theme: SkeletonTheme.Light,
            isShowAvatar: true,
            isCircleAvatar: false,
            barCount: 2,
          ),
        );
      }
      else if(courses.length == 0){
        return Center(
          child: Text("لا يوجد محاضرات",style: TextStyle(fontSize: 32.0),),
        );
      }
      else
        return ListView.builder(
          itemCount: _isOnline ? courses.length:courseList.length,
          itemBuilder: (BuildContext context, int index){
            return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    new Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 10.0),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Styles.primaryColor,width: 2.0),
                            borderRadius: BorderRadius.circular(25.0)
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                          child: _isOnline ? Text(courses[index]['name'],style: TextStyle(fontSize: 22.0),textAlign: TextAlign.right,)
                              :Text(courseList[index]['courseName'],style: TextStyle(fontSize: 22.0),textAlign: TextAlign.right,),
                        ),
                      ),
                    ),
                    new Container(
                        height: 170,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          itemCount: _isOnline ? courseLec[courses[index]['id']].length:courseLec[courseList[index]['courseID']].length,
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          itemBuilder: (BuildContext context, int i){
                            return Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    new Padding(
                                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                      child: Container(
                                        width: 120,
                                        height: 170,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: _getImg(widget.teamType),
                                                fit: BoxFit.fill,
                                                colorFilter: ColorFilter.mode(Colors.grey.withOpacity(0.4), BlendMode.darken)
                                            )
                                        ),
                                        child: FlatButton(
                                          onPressed: () async{
                                            showDialog(
                                                context: context,
                                                builder: (_) => new AlertDialog(
                                                  title: new Center(
                                                    child: _isOnline? Text('${courseLec[courses[index]['id']][i]['name']}'):
                                                    Text('${courseLec[courseList[index]['id']][i]['lecName']}'),
                                                  ),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text('طلب طباعة'),
                                                      onPressed: () async{
                                                        showDialog(
                                                          context: context,
                                                          barrierDismissible: false,
                                                          builder: (BuildContext context) {
                                                            return Dialog(
                                                              backgroundColor: Colors.transparent,
                                                              child: new Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  new CircularProgressIndicator(),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        );
                                                        new Future.delayed(new Duration(seconds: 3), () async {
                                                          await _getLibs(widget.teamType);
                                                          Navigator.pop(context);
                                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AddOrder(widget.teamType, widget.teamCode, courseLec[courses[index]['id']][i]['id'])));
                                                        });
                                                      },
                                                    ),
                                                    FlatButton(
                                                      child: Text('عرض'),
                                                      onPressed: () async {
                                                        final filename = _isOnline ? courseLec[courses[index]['id']][i]['name']:courseLec[courseList[index]['courseID']][i]['lecName'];
                                                        String dir = (await getApplicationDocumentsDirectory()).path;
                                                        if (await File('$dir/$filename').exists()){
                                                          Navigator.pop(context);
                                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => pdfView('$dir/$filename')));
                                                        }
                                                        else{
                                                          showDialog(
                                                            context: context,
                                                            barrierDismissible: false,
                                                            builder: (BuildContext context) {
                                                              return Dialog(
                                                                backgroundColor: Colors.transparent,
                                                                child: new Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    new CircularProgressIndicator(),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          );
                                                          new Future.delayed(new Duration(seconds: 3), () async {
                                                            var lecurl = courseLec[courses[index]['id']][i]['id'];
                                                            print('path: ${courseLec[courses[index]['id']][i]['id']}');
                                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                                            var code_id = widget.teamCode;
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
                                                            Navigator.pop(context);
                                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => pdfView('$dir/$filename')));
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ));
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(43.0, 130.0, 0.0, 0.0),
                                            child: _isOnline ? Container(width: 35,height: 35,decoration: BoxDecoration(color: Styles.primaryColor,borderRadius: BorderRadius.circular(50.0)) ,child: Padding(padding: EdgeInsets.only(top: 8),child: Text('${courseLec[courses[index]['id']][i]['lecture']}',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),),)
                                                :Container(width: 35,height: 35,decoration: BoxDecoration(color: Styles.primaryColor,borderRadius: BorderRadius.circular(50.0)) ,child: Padding(padding: EdgeInsets.only(top: 8),child: Text('${courseLec[courseList[index]['courseID']][i]['lec']}',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),),)

                                          ),
                                        ),
                                      ),
                                    ),
                                    // Container(width: 35,height: 35,decoration: BoxDecoration(color: Styles.primaryColor,borderRadius: BorderRadius.circular(50.0)) ,child: Padding(padding: EdgeInsets.only(top: 8),child: Text('${courseLec[courses[index]['id']][i]['lecture']}',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),),)
                                  ],
                                )
                            );
                          },
                        )
                    ),
                    new Container(
                      width: MediaQuery.of(context).size.width,
                      height: 30,
                    )
                  ],
                )
            );
          },
        );
    }
    else{
      if(courseList.length == 0){
        print("courseList = 0");
        return Center(
          child: Text("لا يوجد محاضرات",style: TextStyle(fontSize: 32.0),),
        );
      }
      else
        return ListView.builder(
          itemCount: _isOnline ? courses.length:courseList.length,
          itemBuilder: (BuildContext context, int index){
            return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    new Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 10.0),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Styles.primaryColor,width: 2.0),
                            borderRadius: BorderRadius.circular(25.0)
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                          child: _isOnline ? Text(courses[index]['name'],style: TextStyle(fontSize: 22.0),textAlign: TextAlign.right,)
                              :Text(courseList[index]['courseName'],style: TextStyle(fontSize: 22.0),textAlign: TextAlign.right,),
                        ),
                      ),
                    ),
                    new Container(
                        height: 170,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          itemCount: _isOnline ? courseLec[courses[index]['id']].length:courseLec[courseList[index]['courseID']].length,
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          itemBuilder: (BuildContext context, int i){
                            return Container(
                                child: Row(
                                  children: [
                                    new Padding(
                                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                      child: Container(
                                        width: 120,
                                        height: 170,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: _getImg(widget.teamType),
                                                fit: BoxFit.fill,
                                                colorFilter: ColorFilter.mode(Colors.grey.withOpacity(0.4), BlendMode.darken)
                                            )
                                        ),
                                        child: FlatButton(
                                          onPressed: (){
                                            showDialog(
                                                context: context,
                                                builder: (_) => new AlertDialog(
                                                  title: new Center(
                                                    child: _isOnline ? Text('${courseLec[courses[index]['id']][i]['name']}')
                                                    :Text('${courseLec[courseList[index]['courseID']][i]['lecName']}'),
                                                  ),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text('طلب طباعة'),
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            builder: (_) => new AlertDialog(
                                                              title: new Center(
                                                                child: _isOnline ? Text('${courseLec[courses[index]['id']][i]['name']}')
                                                                    :Text('${courseLec[courseList[index]['courseID']][i]['lecName']}'),
                                                              ),
                                                              content: Center(
                                                                  child: Form(
                                                                    key: _formKey,
                                                                    child: Column(
                                                                      children: [
                                                                        new DropdownButton<String>(
                                                                          disabledHint: Text("اختر مكتبة"),
                                                                          hint: Text("اختر مكتبة"),
                                                                          value: TeamMain.myLibSelection,
                                                                          underline: Container(width: 0.0,height: 0.0),
                                                                          onChanged: (String newValue)async {
                                                                            setState(() {
                                                                              TeamMain.myLibSelection = newValue;
                                                                            });
                                                                          },
                                                                          items: TeamMain.dropDownLib.map((description, value) {
                                                                            return MapEntry(
                                                                                description,
                                                                                DropdownMenuItem<String>(
                                                                                  value: value.toString(),
                                                                                  child: Center(child: Text(description.toString())),
                                                                                ));
                                                                          }).values.toList(),
                                                                        ),
                                                                        new TextFormField(
                                                                          keyboardType: TextInputType.number,
                                                                          controller: _libNameCont,
                                                                          validator: (value){
                                                                            if(value.isEmpty)
                                                                              return "رجاء ادخل عدد النسخ";
                                                                            if(int.parse(value) > 2 || int.parse(value) < 0)
                                                                              return "عدد النسخ يجب ان يكون 1 او 2";
                                                                            return null;
                                                                          },
                                                                          textCapitalization: TextCapitalization.words,
                                                                          style: TextStyle(
                                                                              fontSize: 16.0,
                                                                              color: Colors.black),
                                                                          decoration: InputDecoration(
                                                                            border: InputBorder.none,
                                                                            icon: Icon(
                                                                              Icons.assignment_turned_in,
                                                                              color: Colors.black,
                                                                            ),
                                                                            hintText: "عدد النسخ",
                                                                            hintStyle: TextStyle(fontSize: 16.0),
                                                                          ),
                                                                        ),
                                                                        new Container(
                                                                          width: 250.0,
                                                                          height: 1.0,
                                                                          color: Colors.grey[400],
                                                                        ),
                                                                        new DateTimePicker(
                                                                          controller: _dateCont,
                                                                          icon: Icon(Icons.date_range),
                                                                          // initialValue: '',
                                                                          firstDate: DateTime(2000),
                                                                          lastDate: DateTime(2100),
                                                                          dateLabelText: 'Date',
                                                                          onChanged: (val) => print(val),
                                                                          validator: (val) {
                                                                            print(val);
                                                                            return null;
                                                                          },
                                                                          onSaved: (val) => print(val),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )
                                                              ),
                                                              actions: <Widget>[
                                                                FlatButton(
                                                                  child: Text('الغاء'),
                                                                  onPressed: () {
                                                                    Navigator.of(context).pop();

                                                                  },
                                                                ),
                                                                FlatButton(
                                                                  child: Text('طلب طباعة'),
                                                                  onPressed: () async{
                                                                    if (_formKey.currentState.validate()){
                                                                      showDialog(
                                                                        context: context,
                                                                        barrierDismissible: false,
                                                                        builder: (BuildContext context) {
                                                                          return Dialog(
                                                                            backgroundColor: Colors.transparent,
                                                                            child: new Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                new CircularProgressIndicator(),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        },
                                                                      );
                                                                      new Future.delayed(new Duration(seconds: 5), () async {
                                                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                                                        var _codeID = widget.teamCode;
                                                                        var _libID = TeamMain.dropDownLib[TeamMain.myLibSelection];
                                                                        var _lecID = courseLec[courses[index]['id']][i]['id'];
                                                                        print("num of copoies: ${_libNameCont.text}");
                                                                        print("date: ${_dateCont.text}");
                                                                        print("libraryID: $_libID");
                                                                        print('codeID: $_codeID');
                                                                        print('lecID: $_lecID');
                                                                        var url = 'http://gene-team.com/public/api/orders';
                                                                        var response = await http.post(url,body: {'code_id':_codeID.toString(),'library_id':_libID.toString(),'lecture_id':_lecID.toString(),'numberOfCopies':_libNameCont.text,"date": _dateCont.text});
                                                                        print('statuscode: ${response.statusCode}');
                                                                        print('body: ${response.body}');
                                                                        if(response.statusCode == 201){
                                                                          Navigator.pop(context);
                                                                          Navigator.pop(context);
                                                                          _scaffoldKey.currentState?.removeCurrentSnackBar();
                                                                          _scaffoldKey.currentState.showSnackBar(new SnackBar(
                                                                            content: new Row(
                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                              children: [
                                                                                Text("تم اضافة طلب",style: TextStyle(fontSize: 16)),
                                                                                Padding(
                                                                                  padding: EdgeInsets.fromLTRB(10.0,0.0,0.0,0.0),
                                                                                  child: Icon(Icons.done,color: Colors.grey,),
                                                                                )
                                                                              ],
                                                                            ),
                                                                            backgroundColor: Colors.green,
                                                                            duration: Duration(seconds: 3),
                                                                          ));
                                                                        }
                                                                        else if(response.body == 'sorry you cant order the same lecture more than tow times'){
                                                                          Navigator.pop(context);
                                                                          Navigator.pop(context);
                                                                          _scaffoldKey.currentState?.removeCurrentSnackBar();
                                                                          _scaffoldKey.currentState.showSnackBar(new SnackBar(
                                                                            content: new Row(
                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                              children: [
                                                                                Text("عذرا لايمكنك طلب نفس المحاضرة اكثر من مرتين",style: TextStyle(fontSize: 16)),
                                                                                Padding(
                                                                                  padding: EdgeInsets.fromLTRB(10.0,0.0,0.0,0.0),
                                                                                  child: Icon(Icons.error,color: Colors.grey,),
                                                                                )
                                                                              ],
                                                                            ),
                                                                            backgroundColor: Colors.red,
                                                                            duration: Duration(seconds: 3),
                                                                          ));
                                                                        }
                                                                        else{
                                                                          Navigator.pop(context);
                                                                          Navigator.pop(context);
                                                                          _scaffoldKey.currentState?.removeCurrentSnackBar();
                                                                          _scaffoldKey.currentState.showSnackBar(new SnackBar(
                                                                            content: new Row(
                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                              children: [
                                                                                Text("معطيات خاطئة",style: TextStyle(fontSize: 16)),
                                                                                Padding(
                                                                                  padding: EdgeInsets.fromLTRB(10.0,0.0,0.0,0.0),
                                                                                  child: Icon(Icons.error,color: Colors.grey,),
                                                                                )
                                                                              ],
                                                                            ),
                                                                            backgroundColor: Colors.red,
                                                                            duration: Duration(seconds: 3),
                                                                          ));
                                                                        }
                                                                      });
                                                                    }
                                                                  },
                                                                ),
                                                              ],
                                                            ));

                                                      },
                                                    ),
                                                    FlatButton(
                                                      child: Text('عرض'),
                                                      onPressed: () async {
                                                        final filename = _isOnline ? courseLec[courses[index]['id']][i]['name']:courseLec[courseList[index]['courseID']][i]['lecName'];
                                                        String dir = (await getApplicationDocumentsDirectory()).path;
                                                        if (await File('$dir/$filename').exists())
                                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => pdfView('$dir/$filename')));
                                                        else{
                                                          showDialog(
                                                            context: context,
                                                            barrierDismissible: false,
                                                            builder: (BuildContext context) {
                                                              return Dialog(
                                                                backgroundColor: Colors.transparent,
                                                                child: new Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    new CircularProgressIndicator(),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          );
                                                          new Future.delayed(new Duration(seconds: 3), () async {
                                                            var lecurl = _isOnline ?  courseLec[courses[index]['id']][i]['id'] : courseLec[courseList[index]['courseID']][i]['lecID'];
                                                            print('path: ${courseLec[courses[index]['id']][i]['id']}');
                                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                                            var code_id = widget.teamCode;
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
                                                            Navigator.pop(context);
                                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => pdfView('$dir/$filename')));
                                                          });

                                                        }

                                                        // var lecurl = lectures[index]['id'];
                                                        // var url = 'http://gene-team.com/public/api/lectures/downloadThePDF/$lecurl';
                                                        // var response = await http.get(url);
                                                        // print("statuscode: ${response.statusCode}");
                                                        // print("body: ${response.body}");
                                                        // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => pdfView(url,lectures[index]['name'])));
                                                      },
                                                    ),
                                                  ],
                                                ));
                                          },
                                          child: Padding(
                                              padding: EdgeInsets.fromLTRB(43.0, 130.0, 0.0, 0.0),
                                              child: _isOnline ? Container(width: 35,height: 35,decoration: BoxDecoration(color: Styles.primaryColor,borderRadius: BorderRadius.circular(50.0)) ,child: Padding(padding: EdgeInsets.only(top: 8),child: Text('${courseLec[courses[index]['id']][i]['lecture']}',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),),)
                                                  :Container(width: 35,height: 35,decoration: BoxDecoration(color: Styles.primaryColor,borderRadius: BorderRadius.circular(50.0)) ,child: Padding(padding: EdgeInsets.only(top: 8),child: Text('${courseLec[courseList[index]['courseID']][i]['lec']}',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),),)

                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                            );
                          },
                        )
                    ),
                    new Container(
                      width: MediaQuery.of(context).size.width,
                      height: 30,
                    )
                  ],
                )
            );
          },
        );
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

}
