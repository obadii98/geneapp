import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teams/Team_Views/team_main.dart';
import 'package:http/http.dart' as http;
import 'package:teams/Login_Utils/style/theme.dart' as Theme;
import 'dart:convert';

class AddCourse extends StatefulWidget {
  @override
  _AddCourseState createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _courseCont = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

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


  _getFacs() async {
    TeamMain.dropDownFac.clear();
    TeamMain.dropDownYear.clear();
    TeamMain.dropDownSem.clear();
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
      var url = 'http://gene-team.com/public/api/universitys/facilites/${TeamMain.dropDownUnis[TeamMain.myUniSelection].toString()}';
      var response = await http.get(url);
      var data = json.decode(response.body) as List;
      for(int i = 0; i < data.length; i++)
        TeamMain.dropDownFac[data[i]['name']] = data[i]['id'];
      print('from getfacs ${TeamMain.dropDownFac}');
      setState(() {
        TeamMain.myFacSelection = data[0]['name'];
      });
      print('from getfacs ${TeamMain.myFacSelection}');
      Navigator.pop(context);
    });
  }
  _getYears() async {
    TeamMain.dropDownYear.clear();
    TeamMain.dropDownSem.clear();
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
      var url = 'http://gene-team.com/public/api/facilitys/years/${TeamMain.dropDownFac[TeamMain.myFacSelection].toString()}';
      var response = await http.get(url);
      var data = json.decode(response.body) as List;
      print("Wtf");
      for(int i = 0; i < data.length; i++)
        TeamMain.dropDownYear[data[i]['name']] = data[i]['id'];
      print("Wtf out");
      print("sex ${data[0]['name']}");
      setState(() {
        TeamMain.myYearSelection = data[0]['name'];
      });
      print('from getYears: ${TeamMain.dropDownYear}');
      print('from getYears: ${TeamMain.myYearSelection}');
      Navigator.pop(context);
    });
  }
  _getSems() async {
    TeamMain.dropDownSem.clear();
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
      var url = 'http://gene-team.com/public/api/years/semsters/${TeamMain.dropDownYear[TeamMain.myYearSelection].toString()}';
      var response = await http.get(url);
      var data = json.decode(response.body) as List;
      for(int i = 0; i < data.length; i++)
        TeamMain.dropDownSem[data[i]['name']] = data[i]['id'];
      setState(() {
        TeamMain.mySemSelection = data[0]['name'];
      });
      print(TeamMain.dropDownSem);
      print(TeamMain.mySemSelection);
      Navigator.pop(context);
    });
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
                          height: 490.0,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                                  child: Center(
                                    child: DropdownButton<String>(
                                      disabledHint: Text("اختر جامعة"),
                                      hint: Text("اختر جامعة"),
                                      value: TeamMain.myUniSelection,
                                      underline: Container(width: 0.0,height: 0.0),
                                      onChanged: (TeamMain.dropDownUnis.length > 0) ? (String newValue) async {
                                        await _getFacs();
                                        setState(() {
                                          TeamMain.myUniSelection = newValue;
                                        });
                                        print("myfacselection: ${TeamMain.myFacSelection}");
                                      }:null,
                                      items: TeamMain.dropDownUnis.map((description,  value) {
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
                                      value: TeamMain.myFacSelection,
                                      underline: Container(width: 0.0,height: 0.0),
                                      onChanged: (TeamMain.dropDownFac.length > 0) ? (String newValue) async {
                                        await _getYears();
                                        setState(() {
                                          TeamMain.myFacSelection  = newValue;
                                        });
                                      } : null,
                                      items: TeamMain.dropDownFac.map((description,  value) {
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
                                      value: TeamMain.myYearSelection,
                                      underline: Container(width: 0.0,height: 0.0),
                                      onChanged: (TeamMain.dropDownYear.length > 0) ? (String newValue) async {
                                        await _getSems();
                                        setState(() {
                                          TeamMain.myYearSelection  = newValue;
                                        });
                                      } : null,
                                      items: TeamMain.dropDownYear.map((description,  value) {
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
                                      value: TeamMain.mySemSelection,
                                      underline: Container(width: 0.0,height: 0.0),
                                      onChanged: (TeamMain.dropDownSem.length > 0) ? (value) {
                                        setState(() {
                                          TeamMain.mySemSelection = value;
                                        });
                                      } : null,
                                      items: TeamMain.dropDownSem.map((description,  value) {
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
                                TextFormField(
                                  controller: _courseCont,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: "اسم المادة",
                                    hintStyle: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 460.0),
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
                                "اضافة مادة",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.0,),
                              ),
                            ),
                            onPressed: () async{
                              SharedPreferences prefs = await SharedPreferences.getInstance();
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
                                var url = 'http://gene-team.com/public/api/courses?token=${prefs.getString('teamToken')}';
                                print('token ${prefs.getString('teamToken')}');
                                print('course name: ${_courseCont.text}');
                                print('sem ID: ${TeamMain.dropDownSem[TeamMain.mySemSelection]}');
                                var response = await http.post(url, body: {'name': _courseCont.text, "semester_id": TeamMain.dropDownSem[TeamMain.mySemSelection].toString()});
                                print('fuck');
                                print('body ${response.body}');
                                print('status code ${response.statusCode}');
                                if(response.statusCode == 201) {
                                  Navigator.pop(context);Navigator.pop(context);
                                  TeamMain.teamScaffoldKey.currentState?.removeCurrentSnackBar();
                                  TeamMain.teamScaffoldKey.currentState.showSnackBar(new SnackBar(
                                    content: new Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text("تمت العملية بنجاح",style: TextStyle(fontSize: 16)),
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
                                else {
                                  Navigator.pop(context);Navigator.pop(context);
                                  TeamMain.teamScaffoldKey.currentState?.removeCurrentSnackBar();
                                  TeamMain.teamScaffoldKey.currentState.showSnackBar(new SnackBar(
                                    content: new Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text("خطأ",style: TextStyle(fontSize: 16)),
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
                                print(response.statusCode);
                                print(response.body);
                              });
                            }
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
