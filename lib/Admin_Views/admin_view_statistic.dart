import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminViewStatistic extends StatefulWidget {
  @override
  _AdminViewStatisticState createState() => _AdminViewStatisticState();
}

class _AdminViewStatisticState extends State<AdminViewStatistic> {

  var _numOfCodes, _numOfOrders;

  _getStates() async{
    var urlCode = 'http://gene-team.com/public/api/codes/numberOfAllCodes';
    var responseCode = await http.get(urlCode);
    _numOfCodes = json.decode(responseCode.body);


    var urlOrder = 'http://gene-team.com/public/api/orders/';
    var responseOrder = await http.get(urlOrder);
    var data = json.decode(responseOrder.body);
    _numOfOrders = data.length;
  }

  @override
  void initState() {
    _numOfCodes = _numOfOrders = 0;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height*(70/100),
          width: MediaQuery.of(context).size.width*(90/100),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)
            ),
            child: Column(
              children: [
                new ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0),topRight: Radius.circular(25.0)),
                  child: Image.asset("assets/images/splash_logo.png",width: MediaQuery.of(context).size.width*(50/100)),
                ),
                new Text("عدد الكودات",style: TextStyle(fontSize: 22.0)),
                new FutureBuilder(
                  builder: (context, snapshot){
                    return Container(
                        child: Center(
                          child: Text(_numOfCodes.toString(),style: TextStyle(fontSize: 18.0),),
                        )
                    );
                  },
                  future: _getStates(),
                ),
                new Text("عدد الطلبات",style: TextStyle(fontSize: 22.0)),
                new FutureBuilder(
                  builder: (context, snapshot){
                    return Container(
                        child: Center(
                          child: Text(_numOfOrders.toString(),style: TextStyle(fontSize: 18.0),),
                        )
                    );
                  },
                  future: _getStates(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
