import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:teams/Admin_Views/admin_main.dart';
import 'package:teams/Login_Utils/utils/bubble_indication_painter.dart';
import 'package:teams/Login_Utils/style/theme.dart' as Theme;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';



class AdminCodeGene extends StatefulWidget {
  @override
  _AdminCodeGeneState createState() => _AdminCodeGeneState();
}

class _AdminCodeGeneState extends State<AdminCodeGene> {

  final _genCodeKey = GlobalKey<FormState>();

  TextEditingController _numOfCodeCont = new TextEditingController();
  TextEditingController _teamTypeCont = new TextEditingController();


  List _codesGene = new List();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            new ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0),topRight: Radius.circular(25.0)),
              child: Image.asset("assets/images/splash_logo.png",width: MediaQuery.of(context).size.width*(50/100)),
            ),
            _buildStudent(context)
          ],
        ),
      ),
    );
  }


  Widget _buildStudent(BuildContext context) {
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
                    key: _genCodeKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            controller: _teamTypeCont,
                            validator: (value){
                              if(value.isEmpty)
                                return "ادخل التيم تايب";
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
                              hintText: "التيم تايب",
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
                            controller: _numOfCodeCont,
                            validator: (value){
                              if(value.isEmpty)
                                return "ادخل عدد اكواد لتتولد";
                              if(int.parse(value) > 500 || int.parse(value) < 1)
                                return "عدد الاكواد بين 1 و 500";
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
                                Icons.confirmation_number,
                                color: Colors.black,
                              ),
                              hintText: "عدد الاكواد",
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
                        "توليد",
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
                          var url = 'http://gene-team.com/public/api/codes';
                          var response;
                          try{
                            print("hell1");
                            response = await http.post(url, body: {'teamType': _teamTypeCont.text, 'numberOfCodes': _numOfCodeCont.text});
                            print("body: ${response.body}");
                            print("body: ${response.statusCode}");
                          }catch(exception){
                            Navigator.pop(context);
                            AdminMain.adminScaffoldKey.currentState?.removeCurrentSnackBar();
                            AdminMain.adminScaffoldKey.currentState.showSnackBar(new SnackBar(
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
                            print('body: ${response.body}');
                            var data = json.decode(response.body) as List;
                            _codesGene.clear();
                            for (int i = 0 ; i < data.length ; i++){
                              _codesGene.add(data[i]);
                            }
                            print("Codes generated: $_codesGene");
                            Navigator.pop(context);
                            Clipboard.setData(new ClipboardData(text: '$_codesGene'));
                            showDialog(
                                context: context,
                                builder: (_) => new StatefulBuilder(
                                  builder: (context,setstate){
                                    return AlertDialog(
                                      title: new Center(
                                        child: Text('الاكواد المولدة'),
                                      ),
                                      content: Container(
                                        height: 120,
                                        width: 100,
                                        child: new ListView.builder(
                                          itemBuilder: (builder, index){
                                            return Center(
                                              child: SelectableText('${_codesGene[index]}'),
                                            );
                                          },
                                          itemCount: _codesGene.length,
                                        ),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('عودة'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                ));
                            AdminMain.adminScaffoldKey.currentState?.removeCurrentSnackBar();
                            AdminMain.adminScaffoldKey.currentState.showSnackBar(new SnackBar(
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
                            AdminMain.adminScaffoldKey.currentState?.removeCurrentSnackBar();
                            AdminMain.adminScaffoldKey.currentState.showSnackBar(new SnackBar(
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
    );
  }

}
