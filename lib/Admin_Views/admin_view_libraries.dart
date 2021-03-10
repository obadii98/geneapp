import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_skeleton/flutter_skeleton.dart';
import 'admin_main.dart';

class AdminViewLibraries extends StatefulWidget {
  @override
  _AdminViewLibrariesState createState() => _AdminViewLibrariesState();
}

class _AdminViewLibrariesState extends State<AdminViewLibraries> {

  int _libCount;
  var data;

  _getLibsInfo() async {
    var url = 'http://gene-team.com/public/api/librarys';
    var response = await http.get(url);
    data = json.decode(response.body) as List;
    print(data.length);
    _libCount = data.length;
  }

  _forAnimation() {
    if(_libCount == 0 || data == ''){
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
      return ListView.builder(
        itemCount: _libCount,
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
                              child: Icon(Icons.business_center,color: Colors.blue,size: 75,),
                            )
                        ),
                        new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                new Text(data[index]['name'],style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold)),
                                new IconButton(
                                  icon: Icon(Icons.delete,color: Colors.red,),
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        builder: (_) => ListView(
                                          children: [
                                            AlertDialog(
                                              title: Text("حذف مكتبة",textAlign: TextAlign.right,),
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
                                                      var _libID = data[index]['id'];
                                                      var url = 'http://gene-team.com/public/api/librarys/${_libID}';
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
                                      _getLibsInfo();
                                    });
                                  },
                                )
                              ],
                            ),
                            new Container(
                              height: 130,
                              width: 250,
                              child: Text("شرح عن الفريق وميزاته وما يقدمه بما لا يزيد عن سطرين",style: TextStyle(fontSize: 16.0),maxLines: 3,overflow: TextOverflow.ellipsis,textAlign: TextAlign.right,),
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
    _libCount = 0;
    data = '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
          future: _getLibsInfo(),
          builder: (context,snapshot){
            return _forAnimation();
          },
        )
    );
  }
}
