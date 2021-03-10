import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_skeleton/flutter_skeleton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teams/Utils/styles.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Statistics extends StatefulWidget {

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _searchCont = new TextEditingController();

  List stateBody = new List();
  var search;

  @override
  void initState() {
    stateBody = [];
  }

  _getStatistics() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var teamType = prefs.getString('teamType');
    // print("wtf $teamType");
    var url = 'http://gene-team.com/public/api/ts?team_type=$teamType';
    var response = await http.get(url);
    // print("wtf2 ${response.statusCode}");
    stateBody = json.decode(response.body) as List;
    // print("wtf3");
    // print("state body: ${stateBody[0]}");
    // print("wtf4");
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

  _blockUser(int codeID) async {
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
      var url = 'http://gene-team.com/public/api/block';
      var response = await http.post(url,body: {'code_id': '$codeID'});
      print("test block: ${response.statusCode}");
      print("test block: ${response.body}");
      if(response.statusCode == 201){
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
    if (stateBody == []){
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
        itemCount: stateBody.length,
        itemBuilder: (BuildContext context, int index){
          return Padding(
            padding: EdgeInsets.all(10.0),
            child: ListTile(
              leading: Container(
                // color: Colors.red,
                width: 50,
                height: 75,
                decoration: BoxDecoration(
                    border: Border.all(color: Styles.primaryColor,width: 2.0),
                    borderRadius: BorderRadius.circular(5.0)
                ),
                child: Center(
                  child: Text('${stateBody[index]['code']['code']}',textAlign: TextAlign.center,),
                ),
              ),
              title: Text(stateBody[index]['code']['student']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(stateBody[index]['lecture']),
                  Text('${stateBody[index]['library']} عدد النسخ: ${stateBody[index]['numberOfCopies']}'),
                ],
              ),
              trailing: Container(
                width: 60,
                height: 30,
                decoration: BoxDecoration(
                    color: Styles.primaryColor,
                    // border: Border.all(color: Styles.primaryColor,width: 2.0),
                    borderRadius: BorderRadius.circular(5.0)
                ),
                child: Center(
                  child: FlatButton(
                    onPressed: (){
                      _blockUser(stateBody[index]['code_id']);
                    },
                    child: Text("حظر",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
                  ),
                ),
              ),
            ),
          );
        },
      );
  }

  _search(String text) {
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
      for(int i = 0 ; i < stateBody.length ; i++){
        if(text == stateBody[i]['code']['student']){
          search = stateBody[i];
          break;
        }
        if(text == stateBody[i]['code']['code']){
          search = stateBody[i];
          break;
        }
      }
      print("test $search");
      Navigator.pop(context);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: new Container(
              width: MediaQuery.of(context).size.width * 75/100,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: ListTile(
                  leading: Container(
                    // color: Colors.red,
                    width: 50,
                    height: 75,
                    decoration: BoxDecoration(
                        border: Border.all(color: Styles.primaryColor,width: 2.0),
                        borderRadius: BorderRadius.circular(5.0)
                    ),
                    child: Center(
                      child: Text('${search['code']['code']}',textAlign: TextAlign.center,),
                    ),
                  ),
                  title: Text(search['code']['student']),
                  trailing: Container(
                    width: 60,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Styles.primaryColor,
                        // border: Border.all(color: Styles.primaryColor,width: 2.0),
                        borderRadius: BorderRadius.circular(5.0)
                    ),
                    child: Center(
                      child: FlatButton(
                        onPressed: (){
                          _blockUser(search['code_id']);
                        },
                        child: Text("حظر",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ),
                ),
              )
            ),
          );
        },
      );
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // var teamType = prefs.getString('teamType');
      // var url = 'http://gene-team.com/public/api/tsSearh?team_type$teamType&searchFor$text';
      // var response = await http.get(url);
      // print("test search: ${response.statusCode}");
      // print("test search: ${response.body}");
      // if(response.statusCode == 200){
      //   setState(() {
      //     stateBody = json.decode(response.body) as List;
      //   });
      //   Navigator.pop(context);
      // }
      // else{
      //   Navigator.pop(context);
      //   showInSnackBar(false);
      // }
      // print("test state $stateBody");
    });
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
        title: Container(
          padding: EdgeInsets.only(right: 15.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.0)
          ),
          child: TextFormField(
            controller: _searchCont,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
                icon: IconButton(icon: Icon(Icons.search),onPressed: (){_search(_searchCont.text);},),
                hintText: 'بحث عن اسم او رمز',
                fillColor: Colors.white,
                focusColor: Colors.white,
                border: InputBorder.none
            ),
          ),
        )
      ),
      body: FutureBuilder(
        future: _getStatistics(),
        builder: (buildContext, snapShot) {
          return _forAnimation();
        },
      ),
    );
  }
}
