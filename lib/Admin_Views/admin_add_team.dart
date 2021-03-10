import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:teams/Login_Utils/style/theme.dart' as Theme;
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class AdminAddTeam extends StatefulWidget {
  @override
  _AdminAddTeamState createState() => _AdminAddTeamState();
}

class _AdminAddTeamState extends State<AdminAddTeam> {

  static GlobalKey<ScaffoldState> adminAddScaffoldKey = new GlobalKey<ScaffoldState>();

  final FocusNode myFocusNodePassword = FocusNode();
  bool _obscureTextSignup = true;


  final _genCodeKey = GlobalKey<FormState>();

  TextEditingController _typeCont = new TextEditingController();
  TextEditingController _nameCont = new TextEditingController();
  TextEditingController _usernameCont = new TextEditingController();
  TextEditingController _passwordCont = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: adminAddScaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Gene App"),
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Container(
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
                      height: 480.0,
                      child: Form(
                        key: _genCodeKey,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                              child: TextFormField(
                                controller: _nameCont,
                                validator: (value){
                                  if(value.isEmpty)
                                    return "ادخل اسم التيم";
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
                                  hintText: "اسم التيم",
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
                                controller: _typeCont,
                                validator: (value){
                                  if(value.isEmpty)
                                    return "ادخل تيم تايب";
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
                                  hintText: "تيم تايب",
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
                                controller: _usernameCont,
                                validator: (value){
                                  if(value.isEmpty)
                                    return "ادخل يوسرنيم";
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
                                  hintText: "يوسر نيم",
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
                                focusNode: myFocusNodePassword,
                                controller: _passwordCont,
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
                                    onTap: (){},
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
                            "انشاء تيم",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,),
                          ),
                        ),
                        onPressed: () async {
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
                              var url = 'http://gene-team.com/public/api/teams';
                              var response;
                              try{
                                response = await http.post(url, body: {'type': _typeCont.text, 'name': _nameCont.text, 'userName': _usernameCont.text, 'password': _passwordCont.text});
                              }catch(exception){
                                Navigator.pop(context);
                                adminAddScaffoldKey.currentState?.removeCurrentSnackBar();
                                adminAddScaffoldKey.currentState.showSnackBar(new SnackBar(
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

                              if(response.statusCode == 201) {
                                Navigator.pop(context);
                                adminAddScaffoldKey.currentState?.removeCurrentSnackBar();
                                adminAddScaffoldKey.currentState.showSnackBar(new SnackBar(
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
                                Navigator.pop(context);
                                adminAddScaffoldKey.currentState?.removeCurrentSnackBar();
                                adminAddScaffoldKey.currentState.showSnackBar(new SnackBar(
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
                            });
                          }
                        }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
