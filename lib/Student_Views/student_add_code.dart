import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:teams/Login_Utils/style/theme.dart' as Theme;
import 'package:teams/Student_Views/student_selection.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teams/main.dart';


class StudentAddCode extends StatefulWidget {

  static List<Map<int, int>> codeIdType = new List<Map<int, int>>();

  @override
  _StudentAddCodeState createState() => _StudentAddCodeState();
}

class _StudentAddCodeState extends State<StudentAddCode> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  TextEditingController _codeController = new TextEditingController();

  var _codeID, _codeType;

  void showInSnackBar() {
    FocusScope.of(context).requestFocus(new FocusNode());
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

  @override
  void initState(){
    _getUnis();
  }

  _getUnis() async {
    StudentSelection.dropDownUnis.clear();
    var url = 'http://gene-team.com/public/api/universitys';
    var response = await http.get(url);
    var data = json.decode(response.body) as List;
    for(int i = 0; i < data.length; i++)
      StudentSelection.dropDownUnis[data[i]['name']] = data[i]['id'];
    print(StudentSelection.dropDownUnis);

  }

  _getCodeId() async {
    print('sending ${_codeController.text}');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = 'http://gene-team.com/public/api/codes/showCode/${_codeController.text}';
    var response = await http.get(url);
    var data = json.decode(response.body) as List;
    print("code data: $data");
    print("code statusCode: ${response.statusCode}");
    if(data.isEmpty){
      print('wtf bro?!?');
      return false;
    }
    else{
      _codeID = data[0]['id'];
      _codeType = data[0]['team_id'];
      prefs.setInt('codeID', _codeID);
      prefs.setInt('codeType', _codeType);
      // StudentAddCode.codeIdType.add[_codeID=_codeType];
      // print(StudentAddCode.codeIdType);
      print('test code id: ${data[0]['id']}');
      return true;
    }
  }

  Widget _buildStudent(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
                  height: 180.0,
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            controller: _codeController,
                            validator: (value){},
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
                              hintText: "رمز التفعيل",
                              hintStyle: TextStyle(fontSize: 16.0),
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
                        "رمز التفعيل",
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
                      new Future.delayed(new Duration(seconds: 3), () async {
                        if(await _getCodeId()){
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          var url = 'http://gene-team.com/public/api/codes/assignCodeToStudent';
                          var _studentID = prefs.getString('studentID');
                          var _codeType = prefs.getInt('codeType');
                          var _codeID = prefs.getInt('codeID');
                          var _fcmToken = prefs.getString('FCM');
                          print('student: $_studentID');
                          print('code ID: $_codeID');
                          print('code Type: $_codeType');
                          var response = await http.post(url,body: {'student_id': prefs.getString('studentID'), 'code_id': _codeID.toString(), 'device_token': _fcmToken.toString()});
                          print(response.statusCode);
                          print(response.body);
                          if(response.statusCode == 201){
                            await database.transaction((txn) async {
                              // var id1 = await txn.rawDelete(
                              //     'DELETE FROM Code');
                              var id2 = await txn.rawInsert(
                                  'INSERT INTO Code (codeID, codeType) VALUES($_codeID, $_codeType)');
                            });
                            await _getUnis();
                            Navigator.pop(context);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => StudentSelection()));
                          }
                          else{
                            Navigator.pop(context);
                            showInSnackBar();
                          }
                        }
                        else{
                          Navigator.pop(context);
                          showInSnackBar();
                        }
                      });
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Gene App"),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0),topRight: Radius.circular(25.0)),
                child: Image.asset("assets/images/splash_logo.png",width: MediaQuery.of(context).size.width*(50/100)),
              ),
              _buildStudent(context)
            ],
          ),
        ),
      ),
    );
  }
}
