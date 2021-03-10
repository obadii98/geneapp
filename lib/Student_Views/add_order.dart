import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teams/Login_Utils/style/theme.dart' as Theme;
import 'package:http/http.dart' as http;
import 'package:teams/Team_Views/team_main.dart';

class AddOrder extends StatefulWidget {

  var teamType;
  var teamCode;
  var lecID;

  AddOrder(this.teamType, this.teamCode, this.lecID);

  @override
  _AddOrderState createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _libNameCont = new TextEditingController();
  TextEditingController _dateCont = new TextEditingController(text: DateTime.now().toString());
  final _formKey = GlobalKey<FormState>();



  @override
  void initState() {
    // TODO: implement initState
    print("init: ${TeamMain.dropDownLib}");
    print("init: ${TeamMain.myLibSelection}");
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
                          height: 310.0,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                                  child: Center(
                                    child: DropdownButton<String>(
                                      disabledHint: Text("اختر مكتبة"),
                                      hint: Text("اختر مكتبة"),
                                      value: TeamMain.myLibSelection,
                                      underline: Container(width: 0.0,height: 0.0),
                                      onChanged: (TeamMain.dropDownLib.length > 0) ? (String newValue) async {
                                        setState(()  {
                                          TeamMain.myLibSelection  = newValue;
                                        });
                                      }:null,
                                      items: TeamMain.dropDownLib.map((description,  value) {
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
                                Container(
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
                                "طلب طباعة",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.0,),
                              ),
                            ),
                            onPressed: () {
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
                                  var _lecID = widget.lecID;
                                  print("lib: ${TeamMain.myLibSelection}");
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
