import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_skeleton/flutter_skeleton.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:teams/Utils/styles.dart';

class BlockedUsers extends StatefulWidget {
  @override
  _BlockedUsersState createState() => _BlockedUsersState();
}

class _BlockedUsersState extends State<BlockedUsers> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var blockedList;

  _getList() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var teamType = prefs.getString('teamType');
    var url = 'http://gene-team.com/public/api/block?type=$teamType';
    var response = await http.get(url);
    blockedList = json.decode(response.body);
    print("status code: ${response.statusCode}");
    print("body: $blockedList");
  }


  void showInSnackBar(bool done) {
    if(done == false){
      FocusScope.of(context).requestFocus(new FocusNode());
      _scaffoldKey.currentState?.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
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
    else {
      FocusScope.of(context).requestFocus(new FocusNode());
      _scaffoldKey.currentState?.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("تمت العملية بنجاح",style: TextStyle(fontSize: 16)),
            Padding(
              padding: EdgeInsets.fromLTRB(10.0,0.0,0.0,0.0),
              child: Icon(Icons.check_circle,color: Colors.grey,),
            )
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ));
    }

  }

  _unblock(int codeID) async{
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
      var url = 'http://gene-team.com/public/api/block?code_id=$codeID';
      print(url);
      var response = await http.delete(url);
      print('unblock test: ${response.statusCode}');
      print('unblock test: ${response.body}');
      if(response.statusCode == 200){
        Navigator.pop(context);
        showInSnackBar(true);
      }
      else{
        Navigator.pop(context);
        showInSnackBar(false);
      }

    });


  }

  _forAnimation() {
    if (blockedList == 'init'){
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
        itemCount: blockedList.length,
        itemBuilder: (BuildContext context, int index){
          return Padding(
            padding: EdgeInsets.all(10.0),
            child: ListTile(
              leading: Container(
                child: CircleAvatar(
                  radius: 25.0,
                  child: Icon(Icons.person),
                ),
              ),
              title: Text('${blockedList[index]['code']['Student']}'),
              trailing: Container(
                width: 85,
                height: 30,
                decoration: BoxDecoration(
                    color: Styles.primaryColor,
                    // border: Border.all(color: Styles.primaryColor,width: 2.0),
                    borderRadius: BorderRadius.circular(5.0)
                ),
                child: Center(
                    child: FlatButton(
                      onPressed: (){
                        _unblock(blockedList[index]['code']['id']);
                      },
                      child: Text("إزالة الحظر",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
                    )
                ),
              ),
            ),
          );
        },
      );
  }

  @override
  void initState() {
    // TODO: implement initState
    blockedList = 'init';
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
        title: Text("الطلاب المحظورين",style: TextStyle(fontSize: 26.0),),
      ),
      body: FutureBuilder(
        builder: (buildContext, snapshot) {
          return _forAnimation();
        },
        future: _getList(),
      ),
    );
  }
}
