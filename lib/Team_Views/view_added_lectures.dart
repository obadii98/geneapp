import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_skeleton/flutter_skeleton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teams/Team_Views/team_view_lec.dart';
import 'package:teams/Utils/styles.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'add_lecture.dart';

class ViewAddedLec extends StatefulWidget {
  @override
  _ViewAddedLecState createState() => _ViewAddedLecState();
}

class _ViewAddedLecState extends State<ViewAddedLec> {

  bool _longedBressed = false;
  bool _isbefore = true;
  Widget _before;
  Widget _after;
  String _dropdownUni = 'دمشق';
  String _dropdownFac = 'كلية الطب البشري';
  String _dropdownYear = '2020-2021';
  String _dropdownSem = 'الفصل الاول';


  Map<String,dynamic> dropdownCourse = new Map<String, dynamic>();
  String myCourseSelection;
  var courseData;

  Map<String,dynamic> _lecturesPDF = new Map<String, dynamic>();
  Map<String,dynamic> _lecturesNames = new Map<String, dynamic>();

  _getTeamCourese() async {
    dropdownCourse.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _teamType = prefs.getString('teamType');
    var url = 'http://gene-team.com/public/api/teams/teamcourses?token=${prefs.getString('teamToken')}';
    var response = await http.post(url);
    courseData = json.decode(response.body);
    print('course data: $courseData');
    print('course name: ${courseData[0]['name']}');
    // for(int i = 0 ; i < courseData.length ; i++)
    //   dropdownCourse[courseData[i]['name']] = courseData[i]['id'];
    // print('from getcourses: ${dropdownCourse}');
  }

  _getCourseLecs() async {
    var url = 'http://gene-team.com/public/api/courses/lectures/${dropdownCourse[myCourseSelection]}';
    var response = await http.get(url);
    var data = json.decode(response.body)as List;
    for(int i = 0 ; i < data.length ; i++){
      _lecturesPDF[data[i]['id']] = data[i]['lecture'];
    }
    for(int i = 0 ; i < data.length ; i++){
      _lecturesNames[data[i]['id']] = data[i]['name'];
    }

  }

  _forAnimation(){
    print(dropdownCourse);
    if(courseData == "init")
      return CardListSkeleton(
        style: SkeletonStyle(
          theme: SkeletonTheme.Light,
          isShowAvatar: true,
          isCircleAvatar: false,
          barCount: 2,
        ),
      );
    else if(courseData.length == 0)
      return Center(
        child: Text("لا يوجد اي محاضرات مضافة",style: TextStyle(fontSize: 30),),
      );
    else
      return ListView.builder(
        itemCount: courseData.length,
        itemBuilder: (context,index){
          return Container(
              child: Column(
                children: [
                  new FlatButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>TeamViewLec(courseData[index]['id'])));
                    },
                    child: Row(
                      children: [
                        new Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Container(
                              height: 160,
                              width: 100,
                              child: Image.asset("assets/images/team.png",height: 160,width: 100,fit: BoxFit.fitHeight,),
                            )
                        ),
                        new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            new Container(
                              width: 160,
                              height: 60,
                              child:  Text(courseData[index]['name'],style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),textAlign: TextAlign.right,),
                            ),
                            new Container(
                              height: 160,
                              width: 150,
                              child: Text("شرح عام عن المادة بما لا يزيد عن سطرين",style: TextStyle(fontSize: 16.0),maxLines: 3,overflow: TextOverflow.ellipsis,textAlign: TextAlign.right,),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  new Divider(
                    height: 1.0,
                    color: Colors.black,
                    thickness: 0.5,
                  ),
                ],
              )
          );
        },
      );
  }

  @override
  void initState() {
    courseData = "init";
    _before = FlatButton(
      onPressed: (){
        setState(() {
          _isbefore = false;
        });
      },
      child: Image.asset("assets/images/test.png"),
    );
    _after = FlatButton(
      onPressed: (){
        setState(() {
          _isbefore = true;
        });
      },
      child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/test.png"),
                  colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
                  fit: BoxFit.cover
              ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Text("تشريح 01",style: TextStyle(fontSize: 18.0),),
              new RaisedButton(
                onPressed: (){},
                color: Styles.primaryColor,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)
                ),
                child: Text("تنزيل", style: TextStyle(fontSize: 16.0),),
              ),
              new Container(
                height: 35,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0,color: Styles.primaryColor),
                  borderRadius: BorderRadius.circular(25.0)
                ),
                child: FlatButton(
                  onPressed: (){
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Container(
                              width: MediaQuery.of(context).size.width*(90/100),
                              height: MediaQuery.of(context).size.height*(70/100),
                              child: ListView(
                                children: [
                                  new ClipRRect(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0),topRight: Radius.circular(25.0)),
                                    child: Image.asset("assets/images/splash_logo.png",width: MediaQuery.of(context).size.width*(50/100)),
                                  ),
                                  new Form(
                                    child: Column(
                                      children: [
                                        new Container(
                                            margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                                            width: 280,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(25.0),
                                              border: Border.all(width: .5,color: Colors.blueGrey),
                                            ),
                                            child: Center(
                                              child: DropdownButton<String>(
                                                value: _dropdownUni,
                                                underline: Container(width: 0.0,height: 0.0),
                                                onChanged: (String newValue){
                                                  setState(() {
                                                    _dropdownUni = newValue;
                                                  });
                                                },
                                                items: <String>['دمشق','تشرين','البعث'].map<DropdownMenuItem<String>>((String value) {
                                                  return DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Center(child: Text(value)),
                                                  );
                                                }).toList(),
                                              ),
                                            )
                                        ),
                                        new Container(
                                          margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                                          width: 280,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(25.0),
                                            border: Border.all(width: .5,color: Colors.blueGrey),
                                          ),
                                          child: Center(
                                            child: DropdownButton<String>(
                                              value: _dropdownFac,
                                              underline: Container(width: 0.0,height: 0.0),
                                              onChanged: (String newValue){
                                                setState(() {
                                                  _dropdownFac = newValue;
                                                });
                                              },
                                              items: <String>['كلية الطب البشري','كلية طب الاسنان','كلية المعلوماتية'].map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                        new Container(
                                          margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                                          width: 280,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(25.0),
                                            border: Border.all(width: .5,color: Colors.blueGrey),
                                          ),
                                          child: Center(
                                            child: DropdownButton<String>(
                                              value: _dropdownYear,
                                              underline: Container(width: 0.0,height: 0.0),
                                              onChanged: (String newValue){
                                                setState(() {
                                                  _dropdownYear = newValue;
                                                });
                                              },
                                              items: <String>['2020-2021','2021-2022'].map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                        new Container(
                                          margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                                          width: 280,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(25.0),
                                            border: Border.all(width: .5,color: Colors.blueGrey),
                                          ),
                                          child: Center(
                                            child: DropdownButton<String>(
                                              value: _dropdownSem,
                                              underline: Container(width: 0.0,height: 0.0),
                                              onChanged: (String newValue){
                                                setState(() {
                                                  _dropdownSem = newValue;
                                                });
                                              },
                                              items: <String>['الفصل الاول','الفصل الثاني'].map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                        new Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(width: 1.0,color: Styles.primaryColor),
                                              borderRadius: BorderRadius.circular(25.0)
                                          ),
                                          child: FlatButton(
                                            onPressed: () async {
                                              // FilePickerResult result = await FilePicker.platform.pickFiles();
                                              // if(result != null) {
                                              //   File file = File(result.files.single.path);
                                              // } else {
                                              //   // User canceled the picker
                                              // }
                                            },
                                            shape:  RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(25.0)
                                            ),
                                            child: Text("اختر المحاضرة",style: TextStyle(fontSize: 18.0),),
                                          ),
                                        ),
                                        new Padding(
                                          padding: EdgeInsets.fromLTRB(0, 10.0, 0.0, 0.0),
                                          child: Row(
                                            children: [
                                              new Container(
                                                height: 37,
                                                width: 87 ,
                                                decoration: BoxDecoration(
                                                    border: Border.all(width: 1.0,color: Styles.primaryColor),
                                                    borderRadius: BorderRadius.circular(25.0)
                                                ),
                                                child: FlatButton(
                                                  onPressed: () async {},
                                                  shape:  RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(25.0)
                                                  ),
                                                  child: Text("حذف",style: TextStyle(fontSize: 18.0),),
                                                ),
                                              ),
                                              new RaisedButton(
                                                onPressed: (){},
                                                color: Styles.primaryColor,
                                                textColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(25.0)
                                                ),
                                                child: Text("تعديل",style: TextStyle(fontSize: 18.0),),
                                              )
                                            ],
                                            mainAxisAlignment: MainAxisAlignment.center,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  color: _longedBressed ? Styles.primaryColor:Colors.transparent,
                  shape:  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0)
                  ),
                  onLongPress: (){
                    setState(() {
                      _longedBressed = !_longedBressed;
                    });
                  },
                  child: Text("تعديل", style: TextStyle(fontSize: 16.0),),
                ),
              ),
            ],
          )
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Container(
        child: FutureBuilder(
          future: _getTeamCourese(),
          builder: (context,snapshot){
            return _forAnimation();
          },
        )
    );
  }
}
