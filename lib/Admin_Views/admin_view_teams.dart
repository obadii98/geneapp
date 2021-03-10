import 'package:flutter/material.dart';
import 'package:flutter_skeleton/flutter_skeleton.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'admin_main.dart';

class AdminViewTeams extends StatefulWidget {

  static Map<String, int> _libList = new Map<String, int>();
  @override
  _AdminViewTeamsState createState() => _AdminViewTeamsState();
}

class _AdminViewTeamsState extends State<AdminViewTeams> {

  int _teamCount;
  var data;
  var _selectedLib;


  _getLibsInfo() async {
    AdminViewTeams._libList.clear();
    var url = 'http://gene-team.com/public/api/librarys';
    var response = await http.get(url);
    var data = json.decode(response.body) as List;
    print("test data: $data");
    for(int i = 0 ; i < data.length ; i++){
      AdminViewTeams._libList[data[i]['name']] = data[i]['id'];
    }
    print("test lib: ${AdminViewTeams._libList}");
    // _libCount = data.length;
  }

  _assignTeamtoLib(int teamType, int libID) async{
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
      var url = 'http://gene-team.com/public/api/team_librarys';
      var response = await http.post(url,body: {'team_id': '$teamType', 'library_id': '$libID'});
      print("assign test: ${response.statusCode}");
      print("assign test: ${response.body}");
      if(response.statusCode == 201) {
        Navigator.pop(context);Navigator.pop(context);
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
        Navigator.pop(context);Navigator.pop(context);
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

  _getTeamsInfo() async {
    var url = 'http://gene-team.com/public/api/teams';
    var response = await http.get(url);
    data = json.decode(response.body) as List;
    print(data.length);
    _teamCount = data.length;
  }

  _forAnimation() {
    if(_teamCount == 0 || data == ''){
      return CardListSkeleton(
          style: SkeletonStyle(
            theme: SkeletonTheme.Light,
            isShowAvatar: true,
            isCircleAvatar: false,
            barCount: 2,
          ),
        );
    }
    else
      return FutureBuilder(
        builder: (context,snapshot){
          return ListView.builder(
            itemCount: _teamCount,
            itemBuilder: (BuildContext context, int index){
              return Container(
                  child: Column(
                    children: [
                      new FlatButton(
                        onPressed: (){
                          // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>ViewTeamLectures()));
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
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    new Text(data[index]['userName'],style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold)),
                                    new IconButton(
                                      icon: Icon(Icons.add_box,),
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
                                          await _getLibsInfo();
                                          Navigator.pop(context);
                                          showDialog(
                                              context: context,
                                              builder: (_) => ListView(
                                                children: [
                                                  AlertDialog(
                                                    title: Text("ربط مع مكتبة",textAlign: TextAlign.right,),
                                                    content: Container(
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                                                            child: Center(
                                                              child: DropdownButton<String>(
                                                                disabledHint: Text("اختر مكتبة"),
                                                                hint: Text("اختر مكتبة"),
                                                                value: _selectedLib,
                                                                underline: Container(width: 0.0,height: 0.0),
                                                                onChanged:(AdminViewTeams._libList.length > 0) ? (String newValue) async {
                                                                  setState(() {
                                                                    _selectedLib  = newValue;
                                                                  });
                                                                  print('test: ${AdminViewTeams._libList[_selectedLib]}');
                                                                }:null,
                                                                items: AdminViewTeams._libList.map((description,  value) {
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
                                                        ],
                                                      ),
                                                    ),
                                                    actions: [
                                                      FlatButton(
                                                        child: Text("عودة"),
                                                        onPressed: (){
                                                          Navigator.pop(context);
                                                        },
                                                      ),
                                                      FlatButton(
                                                        child: Text("تأكيد"),
                                                        onPressed: () async {
                                                          _assignTeamtoLib(data[index]['type'],AdminViewTeams._libList[_selectedLib]);
                                                        },
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              barrierDismissible: false
                                          );
                                        });
                                      },
                                    ),
                                    new IconButton(
                                      icon: Icon(Icons.delete,color: Colors.red,),
                                      onPressed: () async {
                                        showDialog(
                                            context: context,
                                            builder: (_) => ListView(
                                              children: [
                                                AlertDialog(
                                                  title: Text("حذف فريق",textAlign: TextAlign.right,),
                                                  actions: [
                                                    FlatButton(
                                                      child: Text("عودة"),
                                                      onPressed: (){
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    FlatButton(
                                                      child: Text("تأكيد"),
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
                                                          var _teamID = data[index]['id'];
                                                          var url = 'http://gene-team.com/public/api/teams/${_teamID}';
                                                          var response = await http.delete(url);
                                                          if(response.statusCode == 204) {
                                                            Navigator.pop(context);Navigator.pop(context);
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
                                                            Navigator.pop(context);Navigator.pop(context);
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
                                                          print(response.statusCode);
                                                          print(response.body);
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            barrierDismissible: false
                                        );
                                        setState(() {
                                          _getTeamsInfo();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                new Text(data[index]['name'],style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold)),
                                new Container(
                                  height: 130,
                                  width: 250,
                                  child: Text("شرح عن الفريق وميزاته وما يقدمه بما لا يزيد عن سطرين",style: TextStyle(fontSize: 14.0),maxLines: 3,overflow: TextOverflow.ellipsis,textAlign: TextAlign.right,),
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
        },
      );
  }


  @override
  void initState() {
    _teamCount = 0;
    data = '';
    _getLibsInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: _getTeamsInfo(),
        builder: (context,snapshot){
          return _forAnimation();
        },
      )
    );
  }
}