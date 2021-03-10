import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teams/Team_Views/blocked_users.dart';
import 'package:teams/Team_Views/statistics.dart';
import 'package:teams/Utils/styles.dart';

class TeamViewStatistic extends StatefulWidget {
  @override
  _TeamViewStatisticState createState() => _TeamViewStatisticState();
}



class _TeamViewStatisticState extends State<TeamViewStatistic> {

  var _numOfCodes, _numOfOrders;

  _getStatisic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _teamToken = prefs.getString('teamToken');
    var _teamType = prefs.getString('teamType');

    // get num of codes
    var codeurl = 'http://gene-team.com/public/api/codes/numberOfTeamCodes';
    var coderesponse = await http.post(codeurl,body: {'team': _teamType});
    var codedata = json.decode(coderesponse.body);
    _numOfCodes = codedata;

    //get num of orders
    var orderurl = 'http://gene-team.com/public/api/orders/numberOfTeamOredders';
    var orderresponse = await http.post(orderurl,body: {'team':_teamType});
    var orderdata = json.decode(orderresponse.body);
    _numOfOrders = orderdata;

  }


  @override
  void initState() {
    _numOfOrders = 0;
    _numOfCodes = 0;_getStatisic();
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Container(
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height*(70/100),
          width: MediaQuery.of(context).size.width*(90/100),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)
            ),
            child: FutureBuilder(
              future: _getStatisic(),
              builder: (builder,snapshot){
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    new Column(
                      children: [
                        new ClipRRect(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0),topRight: Radius.circular(25.0)),
                          child: Image.asset("assets/images/splash_logo.png",width: MediaQuery.of(context).size.width*(50/100)),
                        ),
                        new Column(
                          children: [
                            new Text("عدد الكودات",style: TextStyle(fontSize: 22.0)),
                            new Container(
                                child: Center(
                                  child: Text(_numOfCodes.toString(),style: TextStyle(fontSize: 18.0),),
                                )
                            ),
                          ],
                        ),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width/2.2,
                          decoration: BoxDecoration(
                              border: Border.all(width: 1.0,color: Styles.primaryColor),
                              borderRadius: BorderRadius.circular(25.0)
                          ),
                          child: FlatButton(
                            onPressed: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => BlockedUsers()));
                            },
                            shape:  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0)
                            ),
                            child: Text("الطلاب المحظورين",style: TextStyle(fontSize: 18.0),textAlign: TextAlign.center,),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width/2.4,
                          decoration: BoxDecoration(
                              border: Border.all(width: 1.0,color: Styles.primaryColor),
                              color: Styles.primaryColor,
                              borderRadius: BorderRadius.circular(25.0)
                          ),
                          child: FlatButton(
                            onPressed: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Statistics()));
                            },
                            shape:  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0)
                            ),
                            child: Text("الطلبات",style: TextStyle(fontSize: 18.0,color: Colors.white),textAlign: TextAlign.center,),
                          ),
                        ),
                      ],
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
