import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teams/Student_Views/student_view_team.dart';
import 'package:teams/Login_Utils/style/theme.dart' as Theme;
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:teams/main.dart';




class StudentSelection extends StatefulWidget {

  static Map<dynamic, dynamic> codeSem = new Map<dynamic,dynamic>();

  static Map<String,dynamic> dropDownUnis = new Map<String, dynamic>();
  static String myUniSelection;

  static Map<String,dynamic> dropDownFac = new Map<String, dynamic>();
  static String myFacSelection;

  static Map<String,dynamic> dropDownYear = new Map<String, dynamic>();
  static String myYearSelection;

  static Map<String,dynamic> dropDownSem = new Map<String, dynamic>();
  static String mySemSelection;
  @override
  _StudentSelectionState createState() => _StudentSelectionState();
}

class _StudentSelectionState extends State<StudentSelection> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  Future<void> _onButtonPress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(StudentSelection.mySemSelection == null || StudentSelection.myYearSelection == null || StudentSelection.myFacSelection == null || StudentSelection.myUniSelection == null)
      showInSnackBar();
    else {
      print('sem id: ${StudentSelection.dropDownSem[StudentSelection.mySemSelection]}');
      print('code id: ${prefs.getInt('codeID')}');
      StudentSelection.codeSem[StudentSelection.dropDownSem[StudentSelection.mySemSelection]]=prefs.getInt('codeID');
      print("sem: code (map): ${StudentSelection.codeSem}");
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
        var data = await database.rawQuery('SELECT * FROM Code');
        var _codeID = prefs.getInt('codeID');
        var _codeType = prefs.getInt('codeType');
        var _studentID = prefs.getString('studentID');
        var _semID = StudentSelection.dropDownSem[StudentSelection.mySemSelection];
        var url = 'http://gene-team.com/public/api/students/s?code_id=${_codeID.toString()}&semester_id=${StudentSelection.dropDownSem[StudentSelection.mySemSelection]}';
        print('CODE: $_codeID');
        print('Semester ID: $_semID');
        var response = await http.post(url);
        print("body: ${response.body}");
        print('status code: ${response.statusCode}');
        var body = json.decode(response.body);
        var _semName = body['semester']['name'];
        var _yearName = body['Year']['name'];
        print("sem ID: $_semID");
        print("sem name: $_semName");
        print("year name: $_yearName");
        if(response.statusCode == 201){
          await database.transaction((txn) async {
            // var id1 = await txn.rawDelete(
            //     'DELETE FROM Code');
            var id2 = await txn.rawUpdate(
                'UPDATE Code SET semID = $_semID, semName = "$_semName", yearName = "$_yearName" WHERE codeID = $_codeID');
            print('done: $id2');
          });
          prefs.setBool('asStudent',true);
          Navigator.pop(context);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => StudentViewTeam(_codeID, _codeType)));
        }
        else{
          Navigator.pop(context);
          showInSnackBar();
        }
      });
    }
  }

  _getFacs() async {
    StudentSelection.dropDownFac.clear();
    StudentSelection.dropDownYear.clear();
    StudentSelection.dropDownSem.clear();
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
      var url = 'http://gene-team.com/public/api/universitys/facilites/${StudentSelection.dropDownUnis[StudentSelection.myUniSelection].toString()}';
      var response = await http.get(url);
      var data = json.decode(response.body) as List;
      for(int i = 0; i < data.length; i++)
        StudentSelection.dropDownFac[data[i]['name']] = data[i]['id'];
      print('from getfacs ${StudentSelection.dropDownFac}');
      setState(() {
        StudentSelection.myFacSelection = data[0]['name'];
      });
      print('from getfacs ${StudentSelection.myFacSelection}');
      Navigator.pop(context);
    });
  }
  _getYears() async {
    StudentSelection.dropDownYear.clear();
    StudentSelection.dropDownSem.clear();
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
    new Future.delayed(new Duration(seconds: 1), () async {
      var url = 'http://gene-team.com/public/api/facilitys/years/${StudentSelection.dropDownFac[StudentSelection.myFacSelection].toString()}';
      var response = await http.get(url);
      var data = json.decode(response.body) as List;
      print("Wtf");
      for(int i = 0; i < data.length; i++)
        StudentSelection.dropDownYear[data[i]['name']] = data[i]['id'];
      print("Wtf out");
      print("sex ${data[0]['name']}");
      setState(() {
        StudentSelection.myYearSelection = data[0]['name'];
      });
      print('from getYears: ${StudentSelection.dropDownYear}');
      print('from getYears: ${StudentSelection.myYearSelection}');
      Navigator.pop(context);
    });
  }
  _getSems() async {
    StudentSelection.dropDownSem.clear();
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
      var url = 'http://gene-team.com/public/api/years/semsters/${StudentSelection.dropDownYear[StudentSelection.myYearSelection].toString()}';
      var response = await http.get(url);
      var data = json.decode(response.body) as List;
      for(int i = 0; i < data.length; i++)
        StudentSelection.dropDownSem[data[i]['name']] = data[i]['id'];
      setState(() {
        StudentSelection.mySemSelection = data[0]['name'];
      });
      print(StudentSelection.dropDownSem);
      print(StudentSelection.mySemSelection);
      Navigator.pop(context);
    });
  }

  void showInSnackBar() {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text("الرجاء اختيار جميع المعلوات و بالترتيب",style: TextStyle(fontSize: 16)),
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

  @override
  void initState(){
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Gene App"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          new ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0),topRight: Radius.circular(25.0)),
            child: Image.asset("assets/images/splash_logo.png",width: MediaQuery.of(context).size.width*(50/100)),
          ),
          new Container(
            padding: EdgeInsets.only(top: 23.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  Stack(
                    alignment: Alignment.topCenter,
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Card(
                        elevation: 2.0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Container(
                          width: 300.0,
                          height: 420.0,
                          child: Form(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                                  child: Center(
                                    child: DropdownButton<String>(
                                      disabledHint: Text("اختر جامعة"),
                                      hint: Text("اختر جامعة"),
                                      value: StudentSelection.myUniSelection,
                                      underline: Container(width: 0.0,height: 0.0),
                                      onChanged: (StudentSelection.dropDownUnis.length > 0) ? (String newValue) async {
                                        await _getFacs();
                                        setState(()  {
                                          StudentSelection.myUniSelection  = newValue;
                                        });
                                      }:null,
                                      items: StudentSelection.dropDownUnis.map((description,  value) {
                                        return MapEntry(
                                            value,
                                            DropdownMenuItem<String>(
                                              value: description,
                                              child: Center(child: Text(description)),
                                            ));
                                      }).values.toList(),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 250.0,
                                  height: 1.0,
                                  color: Colors.grey[400],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                                  child: Center(
                                    child: DropdownButton<String>(
                                      disabledHint: Text("اختر كلية"),
                                      hint: Text("اختر كلية"),
                                      value: StudentSelection.myFacSelection,
                                      underline: Container(width: 0.0,height: 0.0),
                                      onChanged:(StudentSelection.dropDownUnis.length > 0) ? (String newValue) async {
                                        await _getYears();
                                        setState(() {
                                          StudentSelection.myFacSelection  = newValue;
                                        });
                                      }:null,
                                      items: StudentSelection.dropDownFac.map((description,  value) {
                                        return MapEntry(
                                            value,
                                            DropdownMenuItem<String>(
                                              value: description.toString(),
                                              child: Center(child: Text(description.toString())),
                                            ));
                                      }).values.toList(),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 250.0,
                                  height: 1.0,
                                  color: Colors.grey[400],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                                  child: Center(
                                    child: DropdownButton<String>(
                                      disabledHint: Text("اختر سنة"),
                                      hint: Text("اختر سنة"),
                                      value: StudentSelection.myYearSelection,
                                      underline: Container(width: 0.0,height: 0.0),
                                      onChanged: (StudentSelection.dropDownYear.length > 0) ? (String newValue) async {
                                        await _getSems();
                                        setState(() {
                                          StudentSelection.myYearSelection  = newValue;
                                        });
                                      } : null,
                                      items: StudentSelection.dropDownYear.map((description,  value) {
                                        return MapEntry(
                                            value,
                                            DropdownMenuItem<String>(
                                              value: description.toString(),
                                              child: Center(child: Text(description.toString())),
                                            ));
                                      }).values.toList(),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 250.0,
                                  height: 1.0,
                                  color: Colors.grey[400],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                                  child: Center(
                                    child: DropdownButton<String>(
                                      disabledHint: Text("اختر فصل"),
                                      hint: Text("اختر فصل"),
                                      value: StudentSelection.mySemSelection,
                                      underline: Container(width: 0.0,height: 0.0),
                                      onChanged: (StudentSelection.dropDownSem.length > 0) ? (value) => setState(() => StudentSelection.mySemSelection = value) : null,
                                      items: StudentSelection.dropDownSem.map((description,  value) {
                                        return MapEntry(
                                            value,
                                            DropdownMenuItem<String>(
                                              value: description.toString(),
                                              child: Center(child: Text(description.toString())),
                                            ));
                                      }).values.toList(),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 250.0,
                                  height: 1.0,
                                  color: Colors.grey[400],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 400.0),
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.teal[400],
                              offset: Offset(1.0, 6.0),
                              blurRadius: 20.0,
                            ),
                            BoxShadow(
                              color: Colors.teal[700],
                              offset: Offset(1.0, 6.0),
                              blurRadius: 20.0,
                            ),
                          ],
                          gradient: new LinearGradient(
                              colors: [
                                Colors.teal[400],
                                Colors.teal[500]
                              ],
                              begin: const FractionalOffset(0.2, 0.2),
                              end: const FractionalOffset(1.0, 1.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                        ),
                        child: MaterialButton(
                            highlightColor: Colors.transparent,
                            splashColor: Theme.Colors.loginGradientEnd,
                            //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 42.0),
                              child: Text(
                                "اعتماد",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.0,),
                              ),
                            ),
                            onPressed: _onButtonPress
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
