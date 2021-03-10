import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:teams/Admin_Views/admin_main.dart';
import 'package:teams/Drawer/drawer_Contact.dart';
import 'package:teams/Drawer/drawer_about.dart';
import 'package:teams/Drawer/drawer_branchs.dart';
import 'package:teams/Drawer/drawer_learn.dart';
import 'package:teams/Functions/notifications.dart';
import 'package:teams/Functions/secured_app.dart';
import 'package:teams/Login_Utils/utils/bubble_indication_painter.dart';
import 'package:teams/Login_Utils/style/theme.dart' as Theme;
import 'package:teams/Main_Views/splash.dart';
import 'package:teams/Student_Views/student_add_code.dart';
import 'package:teams/Team_Views/add_lecture.dart';
import 'package:teams/Team_Views/team_main.dart';
import 'dart:convert';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teams/Utils/styles.dart';



class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {


  PushNotificationManager p = new PushNotificationManager();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();

  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  final _studentKey = GlobalKey<FormState>();
  final _studentSignupKey = GlobalKey<FormState>();
  final _teamSigninKey = GlobalKey<FormState>();

  TextEditingController signupNameController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();
  TextEditingController signupConfirmPasswordController =
  new TextEditingController();

  //team/admin
  TextEditingController signinTeamNameController = new TextEditingController();
  TextEditingController signinTeamPassController = new TextEditingController();
  //student
  TextEditingController _studentCodeCont = new TextEditingController();
  TextEditingController _studentNameCont = new TextEditingController();
  //lib
  TextEditingController _libUserCont = new TextEditingController();
  TextEditingController _libPassCont = new TextEditingController();

  PageController _pageController;
  PageController _studentPageView;

  Color left = Colors.black;
  Color mid = Colors.white;
  Color right = Colors.white;

  bool _logedIn = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return new WillPopScope(
        onWillPop: (){
          showConfirmation();
        },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(),
        endDrawer: Container(
          width: MediaQuery.of(context).size.width*(75/100),
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            new Image.asset('assets/images/logo.png',width: 100),
                            new Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              child: Container(
                                child: Text('Gene App',style: TextStyle(fontSize: 22.0,color: Colors.white,fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
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
                      //       onPressed: (){},
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
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
          },
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height > 700 ? MediaQuery.of(context).size.height: 1000,
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                      Color.fromRGBO(55, 145, 130, 1),
                      Color.fromRGBO(55, 145, 130, 1),
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 1.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 75.0),
                    child: new Image(
                        width: 310.0,
                        height: 250.0,
                        fit: BoxFit.fill,
                        image: new AssetImage('assets/images/logo.png')),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: _buildMenuBar(context),
                  ),
                  Expanded(
                    flex: 2,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (i) {
                        if (i == 0) {
                          setState(() {
                            right = Colors.white;
                            left = Colors.black;
                          });
                        }
                        else if (i == 1) {
                          setState(() {
                            right = Colors.black;
                            left = Colors.white;
                          });
                        }
                      },
                      children: <Widget>[
                        new ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: _buildStudentSignin(context),
                        ),
                        new ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: _buildTeam(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    myFocusNodePassword.dispose();
    myFocusNodeEmail.dispose();
    myFocusNodeName.dispose();
    _pageController?.dispose();
    super.dispose();
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

  _getLibs() async {
    print("in lib:");
    TeamMain.dropDownLib.clear();
    var url = 'http://gene-team.com/public/api/librarys';
    var response = await http.get(url);
    var data = json.decode(response.body) as List;
    for(int i = 0; i < data.length; i++)
      TeamMain.dropDownLib[data[i]['name']] = data[i]['id'];
    print('librarys: ${TeamMain.dropDownLib}');
  }
//for teams
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
//
  @override
  void initState() {
    // p.init();
    super.initState();
    initDynamicLinks();
    _getLibs();
    _studentPageView = PageController(initialPage: 0);
    SecuredApp.secureScreen();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
  }

  void showInSnackBar() {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text("اسم المستخدم مستعمل",style: TextStyle(fontSize: 16)),
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

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 230.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: Container(
                width: 100,
                child: FlatButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: _onStudentButtonPress,
                  child: Text(
                    "طالب",
                    style: TextStyle(
                        color: left,
                        fontSize: 16.0,),
                  ),
                ),
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: Container(
                width: 100,
                child: FlatButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: _onTeamButtonPress,
                  child: Text(
                    "فريق",
                    style: TextStyle(
                        color: right,
                        fontSize: 16.0,),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentSignup(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
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
                  height: 410.0,
                  child: Form(
                    key: _studentSignupKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            validator: (value){
                              if(value.isEmpty)
                                return"الرجاء ادخال اسم صحيح";
                              if(value.length < 5)
                                return"الاسم يجب ان يكون اكثر من 5 محارف";
                              return null;
                            },
                            controller: signupNameController,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            style: TextStyle(

                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.user,
                                color: Colors.black,
                              ),
                              hintText: "اسم الطالب",
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
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            validator: (value){
                              if(value.isEmpty)
                                return"الرجاء ادخال كلمة مرور";
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            controller: signupPasswordController,
                            obscureText: true,
                            textCapitalization: TextCapitalization.words,
                            style: TextStyle(

                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.lock,
                                color: Colors.black,
                              ),
                              hintText: "كلمة المرور",
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
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            validator: (value){
                              if(value.isEmpty)
                                return"الرجاء ادخال تأكيد كلمة المرور";
                              if(value != signupPasswordController.text)
                                return"كلمة المرور غير متماثلة";
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            controller: signupConfirmPasswordController,
                            obscureText: true,
                            textCapitalization: TextCapitalization.words,
                            style: TextStyle(

                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.lock,
                                color: Colors.black,
                              ),
                              hintText: "تأكيد كلمة المرور",
                              hintStyle: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        FlatButton(
                          onPressed: (){
                            setState(() {
                              _studentPageView.animateToPage(0,
                                  duration: Duration(milliseconds: 700), curve: Curves.decelerate);
                            });
                          },
                          child: Text("لديك حساب سابق!؟"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 385.0),
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
                        "تسجيل دخول",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,),
                      ),
                    ),
                    onPressed: () async {
                      if(_studentSignupKey.currentState.validate()){
                          var url = 'http://gene-team.com/public/api/students';
                          var response = await http.post(url, body: {'userName': signupNameController.text});
                          print('Response status: ${response.statusCode}');
                          print('Response body: ${response.body}');
                          if(response.statusCode == 200)
                            showInSnackBar();
                          else
                            showInSnackBar();
                      }
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudentSignin(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
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
                  height: 170.0,
                  child: Form(
                    key: _studentKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            controller: _studentNameCont,
                            focusNode: myFocusNodeName,
                            validator: (value){
                              if(value.isEmpty)
                                return"الرجاء ادخال اسم صحيح";
                              else if(value.length < 6)
                                return"يجب ان يحوي الاسم على الاقل 6 محارف";
                              else if(value.contains('0') || value.contains('1') || value.contains('2') || value.contains('3') || value.contains('4') || value.contains('5') || value.contains('6') || value.contains('7') || value.contains('8') || value.contains('9') || value.contains('!') || value.contains('@') || value.contains('#') || value.contains('%') || value.contains('^') || value.contains('&') || value.contains('*') || value.contains('(') || value.contains(')') || value.contains('_') || value.contains('+') || value.contains('=') || value.contains('-') || value.contains('.') || value.contains(',') || value.contains('<') || value.contains('>') || value.contains('?') || value.contains('`') || value.contains('~') || value.contains('{') || value.contains('}') || value.contains('|') || value.contains(';') || value.contains(':'))
                                return "الرجاء ادخال اسم صحيح";
                              else if (value.contains('ض') || value.contains('ص') || value.contains('ث') || value.contains('ق') || value.contains('ف') || value.contains('غ') || value.contains('ع') || value.contains('ه') || value.contains('خ') || value.contains('ح') || value.contains('ج') || value.contains('د') || value.contains('ط') || value.contains('ك') || value.contains('م') || value.contains('ن') || value.contains('ت') || value.contains('ا') || value.contains('ل') || value.contains('ب') || value.contains('ي') || value.contains('س') || value.contains('ش') || value.contains('ئ') || value.contains('ء') || value.contains('ؤ') || value.contains('لا') || value.contains('ى') || value.contains('ة') || value.contains('و') || value.contains('ز') || value.contains('ظ'))
                                return "الرجاء ادخال الاسم باللغة الانكليزية";
                              // else if(value.contains('A') || value.contains('a') || value.contains('B') || value.contains('b') || value.contains('C') || value.contains('c') || value.contains('D') || value.contains('d') || value.contains('E') || value.contains('e') || value.contains('F') || value.contains('f') || value.contains('G') || value.contains('g') || value.contains('H') || value.contains('h') || value.contains('I') || value.contains('i') || value.contains('J') || value.contains('j') || value.contains('K') || value.contains('k') || value.contains('L') || value.contains('l') || value.contains('M') || value.contains('m') || value.contains('N') || value.contains('n') || value.contains('O') || value.contains('o') || value.contains('P') || value.contains('p') || value.contains('Q') || value.contains('q') || value.contains('R') || value.contains('r') || value.contains('S') || value.contains('s') || value.contains('T') || value.contains('t') || value.contains('U') || value.contains('u') || value.contains('V') || value.contains('v') || value.contains('W') || value.contains('w') || value.contains('X') || value.contains('x') || value.contains('Y') || value.contains('y') || value.contains('Z') || value.contains('z'))
                              //   return "الرجاء ادخال اسم باللغة العربية";
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
                                FontAwesomeIcons.user,
                                color: Colors.black,
                              ),
                              hintText: "اسم الطالب",
                              hintStyle: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        //for making signup and signin for student
                        // FlatButton(
                        //   onPressed: (){
                        //     setState(() {
                        //       _studentPageView.animateToPage(1,
                        //           duration: Duration(milliseconds: 700), curve: Curves.decelerate);
                        //     });
                        //   },
                        //   child: Text("ليس لديك حساب!؟"),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 150.0),
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
                        "تسجيل دخول",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,),
                      ),
                    ),
                    onPressed: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Dialog(
                              backgroundColor: Colors.transparent,
                              child: Container(
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 180,
                                      left: 90,
                                      child: Text("الرجاء الانتظار",style: TextStyle(color: Colors.white,fontSize: 36),),
                                    ),
                                    Positioned(
                                      child: JumpingDotsProgressIndicator(
                                        fontSize: 250.0,
                                        milliseconds: 200,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                        new Future.delayed(new Duration(seconds: 3), () async {
                          if(_studentKey.currentState.validate()) {
                              var studenturl = 'http://gene-team.com/public/api/students';
                              print('wtf bro!!?');
                              var studentres = await http.post(studenturl,body: {'userName': _studentNameCont.text});
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              // print(studentres.body);
                              // print(studentres.statusCode);
                              if(studentres.statusCode == 201){
                                var data = json.decode(studentres.body);
                                print(data['id']);
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setString('studentID', data['id'].toString());
                                prefs.setString('studentName', data['userName']);
                                print(prefs.getString('studentID'));
                                Navigator.pop(context);
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => StudentAddCode()));
                              }
                              else {
                                Navigator.pop(context);
                                showInSnackBar();
                              }
                          }
                          else
                            Navigator.pop(context);
                        });
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
  //for making signup and signin for student
  Widget _buildStudent(BuildContext context){
    return PageView(
      controller: _studentPageView,

      children: [
        _buildStudentSignin(context),
        _buildStudentSignup(context)
      ],
    );
  }

  Widget _buildTeam(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
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
                  height: 230.0,
                  child: Form(
                    key: _teamSigninKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            validator: (value){
                              if(value.isEmpty)
                                return"الرجاء ادخال اسم صحيح";
                              return null;
                            },
                            focusNode: myFocusNodeName,
                            controller: signinTeamNameController,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            style: TextStyle(

                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.user,
                                color: Colors.black,
                              ),
                              hintText: "يوسرنيم",
                              hintStyle: TextStyle(
                                  fontSize: 16.0),
                            ),
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
                            validator: (value){
                              if(value.isEmpty)
                                return"الرجاء ادخال كلمة مرور";
                              return null;
                            },
                            focusNode: myFocusNodePassword,
                            controller: signinTeamPassController,
                            obscureText: _obscureTextSignup,
                            style: TextStyle(

                                fontSize: 16.0,
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.lock,
                                color: Colors.black,
                              ),
                              hintText: "باسورد",
                              hintStyle: TextStyle(
                                  fontSize: 16.0),
                              suffixIcon: GestureDetector(
                                onTap: _toggleSignup,
                                child: Icon(
                                  _obscureTextSignup
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  size: 15.0,
                                  color: Colors.black,
                                ),
                              ),
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
                margin: EdgeInsets.only(top: 210.0),
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
                        "تسجيل دخول",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,),
                      ),
                    ),
                    onPressed: () async {
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
                        if(_teamSigninKey.currentState.validate()) {
                          var adminurl = 'http://gene-team.com/public/api/admins/login';
                          print('wtf');
                          var adminres = await http.post(adminurl,body: {'userName': signinTeamNameController.text, 'password': signinTeamPassController.text});
                          print('wtf2');
                          var adminData = json.decode(adminres.body);
                          print(adminres.body);
                          print(adminres.statusCode);
                          if(adminres.body != '{"error":"Unauthorized"}'){
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString('adminUser', adminData['user']['userName']);
                            print('wtf 3${adminData['user']['userName']}');
                            prefs.setBool('asAdmin',true);
                            Navigator.pop(context);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => AdminMain()));
                          }
                          else{
                            print('pls');
                            var url = 'http://gene-team.com/public/api/team/login';
                            var response = await http.post(url,body: {'userName': signinTeamNameController.text, 'password': signinTeamPassController.text});
                            var data = json.decode(response.body) as Map<dynamic, dynamic>;
                            print('team status code: ${response.statusCode}');
                            print('team body: ${response.body}');
                            // print('team user: ${data['user']}');
                            var _teamUser = data['user'];
                            var _teamToken = data['access_token'];
                            print("token $_teamToken");
                            // print('team token: $_teamToken');
                            // print('team type: ${_teamUser['type']}');
                            var _teamType = _teamUser['type'];
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString('teamToken', _teamToken);
                            prefs.setString('teamUser', _teamUser['userName']);
                            prefs.setString('teamName', _teamUser['name']);
                            prefs.setString('teamType', _teamType.toString());
                            if(response.statusCode == 200) {
                              _getLibs();
                              _getUnis();_getTeamCourses();
                              prefs.setBool('asTeam',true);
                              prefs.setBool('logedIn', true);
                              Navigator.pop(context);
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          TeamMain()));
                            }
                            else {
                              Navigator.pop(context);
                              showInSnackBar();
                            }
                          }
                        }
                        else
                          Navigator.pop(context);
                      });
                    }
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLibrary(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
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
                  height: 220.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextFormField(
                          focusNode: myFocusNodeName,
                          controller: _libUserCont,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(

                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.user,
                              color: Colors.black,
                            ),
                            hintText: "يوسرنيم",
                            hintStyle: TextStyle(
                                 fontSize: 16.0),
                          ),
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
                        child: TextField(
                          focusNode: myFocusNodePassword,
                          controller: _libPassCont,
                          obscureText: _obscureTextSignup,
                          style: TextStyle(

                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.lock,
                              color: Colors.black,
                            ),
                            hintText: "باسورد",
                            hintStyle: TextStyle(
                                 fontSize: 16.0),
                            suffixIcon: GestureDetector(
                              onTap: _toggleSignup,
                              child: Icon(
                                _obscureTextSignup
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
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
              Container(
                margin: EdgeInsets.only(top: 190.0),
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
                    onPressed: (){
                      // showDialog(
                      //   context: context,
                      //   barrierDismissible: false,
                      //   builder: (BuildContext context) {
                      //     return Dialog(
                      //       backgroundColor: Colors.transparent,
                      //       child: new Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           new CircularProgressIndicator(),
                      //         ],
                      //       ),
                      //     );
                      //   },
                      // );
                      // new Future.delayed(new Duration(seconds: 5), () async {
                      //       var url = 'http://gene-team.com/public/api/library/login';
                      //       var response = await http.post(url,body: {'userName': _libUserCont.text, 'password': _libPassCont.text});
                      //       var data = json.decode(response.body) as Map<dynamic, dynamic>;
                      //       print('lib status code: ${response.statusCode}');
                      //       print('lib body: ${response.body}');
                      //       print('lib user: ${data['user']}');
                      //       if(response.statusCode == 200) {
                      //         var _libUser = data['user'];
                      //         SharedPreferences prefs = await SharedPreferences.getInstance();
                      //         prefs.setBool('asLib',true);
                      //         // print('team token: $_teamToken');
                      //         // print('team type: ${_teamUser['type']}');
                      //         var _libType = _libUser['type'];
                      //         prefs.setString('libUser', _libUser['userName']);
                      //         prefs.setInt('libID', _libUser['id']);
                      //         prefs.setString('libType', _libType.toString());
                      //
                      //         Navigator.pop(context);
                      //         Navigator.pushReplacement(context,
                      //             MaterialPageRoute(
                      //                 builder: (BuildContext context) =>
                      //                     LibraryMain()));
                      //       }
                      //       else {
                      //         Navigator.pop(context);
                      //         showInSnackBar();
                      //       }
                      // });
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LibraryMain()));
                    },
                    splashColor: Theme.Colors.loginGradientEnd,
                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        "تسجيل دخول",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,),
                      ),
                    ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onStudentButtonPress() {
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onTeamButtonPress() {
    _pageController?.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onLibraryButtonPress() {
    _pageController?.animateToPage(2,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }


  String _linkMessage;
  bool _isCreatingLink = false;

  void initDynamicLinks() async{
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          final Uri deepLink = dynamicLink?.link;

          if (deepLink != null) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SplashScreen()));
          }
        }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deeplink = data?.link;

    if(deeplink != null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SplashScreen()));
    }
  }
  Future<void> createDynamicLink(bool short) async{
    setState(() {
      _isCreatingLink = true;
    });
    print("test");
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://GeneApp.page.link',
        link: Uri.parse('https://GeneApp.page.link/hello'),
        androidParameters: AndroidParameters(packageName: 'com.example.teams',minimumVersion: 0),
        dynamicLinkParametersOptions: DynamicLinkParametersOptions(
            shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
            title: "test ahmad",
            description: "2ery b ahmad"
        )
    );
    print("2");
    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url = shortLink.shortUrl;
    } else {
      url = await parameters.buildUrl();
    }

    setState(() {
      _linkMessage = url.toString();
      _isCreatingLink = false;
    });
    print(url);
  }

}
