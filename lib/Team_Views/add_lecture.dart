import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teams/Admin_Views/admin_main.dart';
import 'package:teams/Team_Views/team_main.dart';
import 'package:teams/Team_Views/team_main.dart';
import 'package:teams/Team_Views/team_main.dart';
import 'package:teams/Utils/styles.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:teams/Login_Utils/style/theme.dart' as Theme;
import 'package:gx_file_picker/gx_file_picker.dart';
import 'dart:convert';
import 'package:path/path.dart' as ph;
import 'package:http/http.dart' as http;


class AddLecture extends StatefulWidget {
  static Map<String,dynamic> dropdownCourse = new Map<String, dynamic>();
  static String myCourseSelection;
  static var courseData;
  @override
  _AddLectureState createState() => _AddLectureState();
}

class _AddLectureState extends State<AddLecture> with SingleTickerProviderStateMixin {

  final _genCodeKey = GlobalKey<FormState>();

  TextEditingController _numOfCodeCont = new TextEditingController();
  TextEditingController _courseNameCont = new TextEditingController();
  File result;


  bool isVisible = true;

  _getTeamCourses() async {
    AddLecture.dropdownCourse.clear();
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
      var _teamToken = prefs.getString('teamToken');
      print("token test: $_teamToken");
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
    });
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
      body: Center(
        child: ListView(
          children: [
            new ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0),topRight: Radius.circular(25.0)),
              child: Image.asset("assets/images/splash_logo.png",width: MediaQuery.of(context).size.width*(35/100)),
            ),
            _buildStudent(context)
          ],
        ),
      ),
    );
  }

  Widget _buildStudent(BuildContext context) {
    return Container(
      height: 400,
      padding: EdgeInsets.only(top: 23.0),
      child: ListView(
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
                  height: 300.0,
                  child: Form(
                    key: _genCodeKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 20.0, right: 20.0),
                          child: Center(
                            child: DropdownButton<String>(
                              hint: Text("اختر مادة"),
                              disabledHint: Text("اختر مادة"),
                              value: AddLecture.myCourseSelection,
                              underline: Container(width: 0.0,height: 0.0),
                              onChanged: (String newValue) {
                                setState(() {
                                  AddLecture.myCourseSelection  = newValue;
                                });
                              },
                              items: AddLecture.dropdownCourse.map((description,  value) {
                                return MapEntry(
                                    value,
                                    DropdownMenuItem<String>(
                                      value: description.toString(),
                                      child: Center(child: Text(description.toString(),overflow: TextOverflow.clip,)),
                                    ));
                              }).values.toList(),
                            )
                          ),
                        ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            controller: _courseNameCont,
                            validator: (value){
                              if(value.isEmpty)
                                return "ادخل اسم للمحاضرة";
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.people,
                                color: Colors.black,
                              ),
                              hintText: "اسم المحاضرة",
                              hintStyle: TextStyle(fontSize: 16.0),
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
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(width: 1.0,color: Styles.primaryColor),
                                borderRadius: BorderRadius.circular(25.0)
                            ),
                            child: FlatButton(
                              onPressed: () async {
                                result = await FilePicker.getFile(
                                  type: FileType.custom,
                                  allowedExtensions: ['pdf'],
                                );
                              },
                              shape:  RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0)
                              ),
                              child: Text("اختر المحاضرة",style: TextStyle(fontSize: 18.0),),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 280.0),
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
                        "رفع محاضرة",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,),
                      ),
                    ),
                    onPressed: () async {
                      print('filename: ${result}');
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      if(_genCodeKey.currentState.validate()){
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
                          var url = 'http://gene-team.com/public/api/lectures?token=${prefs.getString('teamToken')}';
                          print("test token ${prefs.getString('teamToken')}");
                          print('course id: ${AddLecture.dropdownCourse[AddLecture.myCourseSelection]}');
                          print('course name: ${_courseNameCont.text}');
                          String baseName = result.path.split('/').last;
                          print('file: ${result.path}');
                          print('filename: ${baseName}');
                          print("team type: ${prefs.getString('teamType')}");
                          var req = http.MultipartRequest('POST', Uri.parse(url));
                          req.files.add(await http.MultipartFile.fromPath('pdf', result.path));
                          req.fields['name'] = _courseNameCont.text;
                          req.fields['type'] = prefs.getString('teamType');
                          req.fields['course_id'] = AddLecture.dropdownCourse[AddLecture.myCourseSelection].toString();
                          var res = await req.send();
                          var test = await res.stream.bytesToString();
                          print("test: $test");
                          print('shit: ${req}');
                          print('res: ${res}');
                          print("status code: ${res.statusCode}");
                          print('res.reasonPhrase: ${res.reasonPhrase}');
                          if(res.statusCode == 201){
                            Navigator.pop(context);
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
                          else{
                            Navigator.pop(context);
                            TeamMain.teamScaffoldKey.currentState?.removeCurrentSnackBar();
                            TeamMain.teamScaffoldKey.currentState.showSnackBar(new SnackBar(
                              content: new Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("حدث خطأ",style: TextStyle(fontSize: 16)),
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
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
