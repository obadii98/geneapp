import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teams/Drawer/drawer_Contact.dart';
import 'package:teams/Drawer/drawer_about.dart';
import 'package:teams/Drawer/drawer_branchs.dart';
import 'package:teams/Drawer/drawer_learn.dart';
import 'package:teams/Drawer/drawer_support.dart';
import 'package:teams/Main_Views/login.dart';
import 'package:teams/Team_Views/add_course.dart';
import 'package:teams/Team_Views/add_lecture.dart';
import 'package:teams/Team_Views/send_notification.dart';
import 'package:teams/Team_Views/team_view_statistic.dart';
import 'package:teams/Team_Views/view_added_lectures.dart';
import 'package:teams/Utils/styles.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TeamMain extends StatefulWidget {
  static GlobalKey<ScaffoldState> teamScaffoldKey = new GlobalKey<ScaffoldState>();

  static Map<String,dynamic> dropDownUnis = new Map<String, dynamic>();
  static String myUniSelection;

  static Map<String,dynamic> dropDownFac = new Map<String, dynamic>();
  static String myFacSelection;

  static Map<String,dynamic> dropDownYear = new Map<String, dynamic>();
  static String myYearSelection;

  static Map<String,dynamic> dropDownSem = new Map<String, dynamic>();
  static String mySemSelection;

  static var data;


  static Map<dynamic,dynamic> dropDownLib = new Map<dynamic, dynamic>();
  static String myLibSelection;

  @override
  _TeamMainState createState() => _TeamMainState();
}

class _TeamMainState extends State<TeamMain> {

  final pageController = PageController(
    initialPage: 0,
  );
  int _selectedIndex = 0;




  TextEditingController _courseCont = new TextEditingController();

  bool _selectedUni = false;
  bool _selectedFac = false;
  bool _selectedYear = false;

  TextEditingController _uniCont = new TextEditingController();
  TextEditingController _facCont = new TextEditingController();
  TextEditingController _yearCont = new TextEditingController();
  TextEditingController _semCont = new TextEditingController();

  var _teamUsername;




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
  _getTeamInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _teamUsername = prefs.get('teamUser');
  }

  @override
  void initState() {
    _teamUsername='';
    print("from init: ${AddLecture.myCourseSelection}");
    print("from init: ${AddLecture.dropdownCourse}");
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: TeamMain.teamScaffoldKey,
      appBar: AppBar(
        title: Text("Gene App"),
        centerTitle: true,
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
                                    image: DecorationImage(
                                        image: AssetImage("assets/images/team_pic.png"),
                                        fit: BoxFit.fitHeight
                                    ),
                                  ),

                                ),
                              ),
                              new FutureBuilder(
                                builder: (context,snapshot){
                                  return Padding(
                                    padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                    child: Text(_teamUsername,style: TextStyle(fontSize: 18.0,color: Colors.white,fontWeight: FontWeight.bold)),
                                  );
                                },
                                future: _getTeamInfo(),
                              ),
                            ],
                          ),
                          new Image.asset('assets/images/logo.png',width: 75),
                        ],
                      ),
                    ),
                    new Container(
                        child: FlatButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AddCourse()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              new Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                child: Text("اضافة مادة",style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold)),
                              ),
                              new Icon(Icons.library_books,),
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
                    new Divider(
                      height: 1.0,
                      color: Colors.black,
                      thickness: .5,
                    ),
                    new Container(
                        child: FlatButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SendNotification()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              new Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                child: Text("ارسال اشعار",style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold)),
                              ),
                              new Icon(Icons.notifications_active),
                            ],
                          ),
                        )
                    ),
                  ],
                ),
                new Column(
                  children: [
                    new Divider(
                      height: 1.0,
                      color: Colors.black,
                      thickness: 1.0,
                    ),
                    new Container(
                        child: FlatButton(
                          onPressed: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setBool('asStudent',false);
                            prefs.setBool('asAdmin',false);
                            prefs.setBool('asTeam',false);
                            prefs.setBool('asLib',false);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              new Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                child: Text("تسجيل خروج",style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold)),
                              ),
                              new Icon(Icons.close),
                            ],
                          ),
                        )
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: _onPageChanged,
        children: [
          ViewAddedLec(),
          AddLecture(),
          TeamViewStatistic()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('الرئيسية'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle),
              title: Text('اضافة')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              title: Text('احصائيات')
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
      ),
    );
  }

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
      pageController.animateToPage(_selectedIndex, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    });
  }

  void _onPageChanged(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

}
