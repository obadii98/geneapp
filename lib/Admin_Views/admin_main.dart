import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teams/Admin_Views/admin_add_lib.dart';
import 'package:teams/Admin_Views/admin_add_team.dart';
import 'package:teams/Admin_Views/admin_code_gene.dart';
import 'package:teams/Admin_Views/admin_view_libraries.dart';
import 'package:teams/Admin_Views/admin_view_statistic.dart';
import 'package:teams/Admin_Views/admin_view_teams.dart';
import 'package:teams/Main_Views/login.dart';
import 'package:teams/Utils/styles.dart';
import 'package:http/http.dart' as http;

class AdminMain extends StatefulWidget {

  static GlobalKey<ScaffoldState> adminScaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  _AdminMainState createState() => _AdminMainState();
}

class _AdminMainState extends State<AdminMain> {

  var _appBar;

  String _adminUser;

  bool _selectedUni = false;
  bool _selectedFac = false;

  TextEditingController _uniCont = new TextEditingController();
  TextEditingController _facCont = new TextEditingController();
  TextEditingController _yearCont = new TextEditingController();
  TextEditingController _semCont = new TextEditingController();

  int _selectedIndex = 0;

  final pageController = PageController(
    initialPage: 0,
  );


  Map<String,dynamic> _dropDownUnis = new Map<String, dynamic>();
  var _myUniSelection;

  Map<String,dynamic> _dropDownFac = new Map<String, dynamic>();
  String _myFacSelection;

  Map<String,dynamic> _dropDownYear = new Map<String, dynamic>();
  String _myYearSelection;

  _getAdminInfo() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _adminUser = prefs.getString('adminUser');
    print(_adminUser);
  }

  _getUnis() async {
    _dropDownUnis.clear();
    var url = 'http://gene-team.com/public/api/universitys';
    var response = await http.get(url);
    var data = json.decode(response.body) as List;
    for(int i = 0; i < data.length; i++)
      _dropDownUnis[data[i]['name']] = data[i]['id'];
    print(_dropDownUnis);

  }

  _getFacs() async {
    _dropDownFac.clear();
    var url = 'http://gene-team.com/public/api/universitys/facilites/${_dropDownUnis[_myUniSelection].toString()}';
    var response = await http.get(url);
    var data = json.decode(response.body) as List;
    for(int i = 0; i < data.length; i++)
      _dropDownFac[data[i]['name']] = data[i]['id'];
    print(_dropDownFac);
  }

  _getYears() async {
    _dropDownYear.clear();
    print(_dropDownFac[_myFacSelection].toString());
    var url = 'http://gene-team.com/public/api/facilitys/years/${_dropDownFac[_myFacSelection].toString()}';
    var response = await http.get(url);
    var data = json.decode(response.body) as List;
    for(int i = 0; i < data.length; i++)
      _dropDownYear[data[i]['name']] = data[i]['id'];
    print(_dropDownYear);
  }

  @override
  void initState() {
    _adminUser = '';
    _getUnis();
    _appBar = AppBar(
      title: Text("Gene App"),
      centerTitle: true,
      leading: IconButton(
        onPressed: (){},
        icon: Icon(Icons.add),
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: AdminMain.adminScaffoldKey,
      appBar: _appBar,
      endDrawer: Container(
        width: MediaQuery.of(context).size.width*(75/100),
        height: MediaQuery.of(context).size.height,
        child: Drawer(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                new Column(
                  children: [
                    new Container(
                      width: MediaQuery.of(context).size.width*(75/100),
                      height: MediaQuery.of(context).size.height*(15/100),
                      color: Styles.primaryColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          new FutureBuilder(
                            builder: (context, snapshot){
                              return Row(
                                children: [
                                  new Padding(
                                    padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                    child: Text(_adminUser,style: TextStyle(fontSize: 18.0,color: Colors.white,fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              );
                            },
                            future: _getAdminInfo(),
                          ),
                          new Image.asset('assets/images/logo.png',width: 100),
                        ],
                      ),
                    ),
                    new Container(
                        child: FlatButton(
                          onPressed: (){
                            _uniCont.clear();
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text("اضافة جامعة",textAlign: TextAlign.right,),
                                  content: TextFormField(
                                    controller: _uniCont,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black),
                                    decoration: InputDecoration(
                                      hintText: "جامعة دمشق، جامعة تشرين، . . .",
                                      hintStyle: TextStyle(fontSize: 16.0),
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
                                      child: Text("اضافة"),
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
                                          var url = 'http://gene-team.com/public/api/universitys';
                                          var response = await http.post(url, body: {'name': _uniCont.text});
                                          if(response.statusCode == 201) {
                                            setState(() {
                                              _getUnis();
                                            });
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
                                ),
                                barrierDismissible: false
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              new Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                child: Text("اضافة جامعة",style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold)),
                              ),
                              new Icon(Icons.account_balance,),
                            ],
                          ),
                        )
                    ),
                    new Container(
                        child: FlatButton(
                          onPressed: (){
                            _facCont.clear();
                            showDialog(
                                context: context,
                                builder: (_) => ListView(
                                  children: [
                                    AlertDialog(
                                      title: Text("اضافة كلية",textAlign: TextAlign.right,),
                                      content: Container(
                                        height: 110,
                                        child: Column(
                                          children: [
                                            new Container(
                                                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                                                width: 280,
                                                child: Center(
                                                  child: StatefulBuilder(
                                                    builder: (context, setState){
                                                      return StatefulBuilder(
                                                        builder: (context, setState){
                                                          return DropdownButton<String>(
                                                            disabledHint: Text('اختر جامعة'),
                                                            hint: Text('اختر جامعة'),
                                                            value: _myUniSelection,
                                                            underline: Container(width: 0.0,height: 0.0),
                                                            onChanged: (_dropDownUnis.length > 0 ) ? (String newValue) async {
                                                              setState(() {
                                                                _myUniSelection = newValue;
                                                              });
                                                            }:null,
                                                            items: _dropDownUnis.map((description,  value) {
                                                              return MapEntry(
                                                                  value,
                                                                  DropdownMenuItem<String>(
                                                                    value: description.toString(),
                                                                    child: Center(child: Text(description.toString())),
                                                                  ));
                                                            }).values.toList(),
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                )
                                            ),
                                            new TextFormField(
                                              controller: _facCont,
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.black),
                                              decoration: InputDecoration(
                                                hintText: "كلية الطب، كلية الصيدلة، . . .",
                                                hintStyle: TextStyle(fontSize: 16.0),
                                              ),
                                            )
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
                                          child: Text("اضافة"),
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
                                              var uniUrl = 'http://gene-team.com/public/api/universitys/showByName/${_myUniSelection}';
                                              var uniResponse = await http.get(uniUrl);
                                              var uni = json.decode(uniResponse.body);
                                              print(uni['id']);

                                              var url = 'http://gene-team.com/public/api/facilitys';
                                              var response = await http.post(url, body: {'name': _facCont.text, 'university_id': uni['id'].toString()});
                                              if(response.statusCode == 201) {
                                                setState(() {
                                                  _getFacs();
                                                });
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
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              new Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                child: Text("اضافة كلية",style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold)),
                              ),
                              new Icon(Icons.account_balance,),
                            ],
                          ),
                        )
                    ),
                    new Container(
                        child: FlatButton(
                          onPressed: (){
                            _yearCont.clear();
                            showDialog(
                                context: context,
                                builder: (_) => ListView(
                                  children: [
                                    AlertDialog(
                                      title: Text("اضافة سنة",textAlign: TextAlign.right,),
                                      content: Container(
                                        height: 180,
                                        child: Column(
                                          children: [
                                            new Container(
                                                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                                                width: 280,
                                                child: Center(
                                                  child: StatefulBuilder(
                                                    builder: (context, setState){
                                                      return DropdownButton<String>(
                                                        disabledHint: Text('اختر جامعة'),
                                                        hint: Text('اختر جامعة'),
                                                        value: _myUniSelection,
                                                        underline: Container(width: 0.0,height: 0.0),
                                                        onChanged: (_dropDownUnis.length > 0) ? (String newValue){
                                                          setState(() {
                                                            _myUniSelection = newValue;print(_myUniSelection);
                                                            _selectedUni = true;print(_selectedUni);
                                                            _getFacs();
                                                          });
                                                        }:null,
                                                        items: _dropDownUnis.map((description,  value) {
                                                          return MapEntry(
                                                              value,
                                                              DropdownMenuItem<String>(
                                                                value: description.toString(),
                                                                child: Center(child: Text(description.toString())),
                                                              ));
                                                        }).values.toList(),
                                                      );
                                                    },
                                                  ),
                                                )
                                            ),
                                            new Container(
                                                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                                                width: 280,
                                                child: Center(
                                                  child: StatefulBuilder(
                                                    builder: (context, setState){
                                                      return DropdownButton<String>(
                                                        disabledHint: Text("اختر كلية"),
                                                        hint: Text("اختر كلية"),
                                                        value: _myFacSelection,
                                                        underline: Container(width: 0.0,height: 0.0),
                                                        //
                                                        onChanged: (_selectedUni && _dropDownFac.length > 0) ?
                                                            (String newValue){
                                                          setState(() {
                                                            _myFacSelection = newValue;print(_myFacSelection);
                                                            _selectedFac = true;
                                                          });
                                                        }: null,
                                                        items: _dropDownFac.map((description,  value) {
                                                          return MapEntry(
                                                              value,
                                                              DropdownMenuItem<String>(
                                                                value: description.toString(),
                                                                child: Center(child: Text(description.toString())),
                                                              ));
                                                        }).values.toList(),
                                                      );
                                                    },
                                                  ),
                                                )
                                            ),
                                            new TextFormField(
                                              controller: _yearCont,
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.black),
                                              decoration: InputDecoration(
                                                hintText: "مثال: 2020, ...",
                                                hintStyle: TextStyle(fontSize: 16.0),
                                              ),
                                            )
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
                                          child: Text("اضافة"),
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

                                              var url = 'http://gene-team.com/public/api/years';
                                              print(_dropDownFac[_myFacSelection]);
                                              var response = await http.post(url, body: {'name': _yearCont.text, "facility_id": _dropDownFac[_myFacSelection].toString()});
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
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              new Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                child: Text("اضافة سنة",style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold)),
                              ),
                              new Icon(Icons.calendar_today,),
                            ],
                          ),
                        )
                    ),
                    new Container(
                        child: FlatButton(
                          onPressed: (){
                            _semCont.clear();
                            showDialog(
                                context: context,
                                builder: (_) => ListView(
                                  children: [
                                    AlertDialog(
                                      title: Text("اضافة فصل",textAlign: TextAlign.right,),
                                      content: Container(
                                        height: 225,
                                        child: Column(
                                          children: [
                                            new Container(
                                                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                                                width: 280,
                                                child: Center(
                                                  child: StatefulBuilder(
                                                    builder: (context, setState){
                                                      return DropdownButton<String>(
                                                        disabledHint: Text('اختر جامعة'),
                                                        value: _myUniSelection,
                                                        underline: Container(width: 0.0,height: 0.0),
                                                        onChanged: (_dropDownUnis.length > 0) ? (String newValue) async {
                                                          setState(() {
                                                            _myUniSelection  = newValue;
                                                            _selectedUni = true;
                                                            _getFacs();
                                                          });
                                                        }:null,
                                                        items: _dropDownUnis.map((description,  value) {
                                                          return MapEntry(
                                                              value,
                                                              DropdownMenuItem<String>(
                                                                value: description.toString(),
                                                                child: Center(child: Text(description.toString())),
                                                              ));
                                                        }).values.toList(),
                                                      );
                                                    },
                                                  ),
                                                )
                                            ),
                                            new Container(
                                                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                                                width: 280,
                                                child: Center(
                                                  child: StatefulBuilder(
                                                    builder: (context, setState){
                                                      return DropdownButton<String>(
                                                        disabledHint: Text("اختر كلية"),
                                                        value: _myFacSelection,
                                                        underline: Container(width: 0.0,height: 0.0),
                                                        onChanged: (_selectedUni && _dropDownFac.length > 0) ? (String newValue) {
                                                          setState(() {
                                                            _myFacSelection  = newValue;
                                                            _selectedFac = true;
                                                            _getYears();
                                                          });
                                                        } : null,
                                                        items: _dropDownFac.map((description,  value) {
                                                          return MapEntry(
                                                              value,
                                                              DropdownMenuItem<String>(
                                                                value: description.toString(),
                                                                child: Center(child: Text(description.toString())),
                                                              ));
                                                        }).values.toList(),
                                                      );
                                                    },
                                                  ),
                                                )
                                            ),
                                            new Container(
                                                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                                                width: 280,
                                                child: Center(
                                                  child: StatefulBuilder(
                                                    builder: (context, setState){
                                                      return DropdownButton<String>(
                                                        disabledHint: Text("اختر سنة"),
                                                        value: _myYearSelection,
                                                        underline: Container(width: 0.0,height: 0.0),
                                                        onChanged: (_selectedFac && _dropDownYear.length > 0) ? (value) => setState(() => _myYearSelection = value) : null,
                                                        items: _dropDownYear.map((description,  value) {
                                                          return MapEntry(
                                                              value,
                                                              DropdownMenuItem<String>(
                                                                value: description.toString(),
                                                                child: Center(child: Text(description.toString())),
                                                              ));
                                                        }).values.toList(),
                                                      );
                                                    },
                                                  ),
                                                )
                                            ),
                                            new TextFormField(
                                              controller: _semCont,
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.black),
                                              decoration: InputDecoration(
                                                hintText: "فصل اول، فصل ثاني",
                                                hintStyle: TextStyle(fontSize: 16.0),
                                              ),
                                            )
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
                                          child: Text("اضافة"),
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

                                              var url = 'http://gene-team.com/public/api/semesters';
                                              print('year id ${_dropDownYear[_myYearSelection]}');
                                              print('name ${_semCont.text}');
                                              var response = await http.post(url, body: {'name': _semCont.text, "year_id": _dropDownYear[_myYearSelection].toString()});
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
                                              print('status code ${response.statusCode}');
                                              print('body ${response.body}');
                                            });
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                barrierDismissible: false
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              new Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                child: Text("اضافة فصل",style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold)),
                              ),
                              new Icon(Icons.calendar_today,),
                            ],
                          ),
                        )
                    ),
                  ],
                ),
                new Column(
                  children: [
                    new Divider(
                      height: 1.0,
                      color: Colors.black,
                      thickness: 1.0,
                    ),
                    new Container(
                        child: FlatButton(
                          onPressed: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setBool('asStudent',false);
                            prefs.setBool('asAdmin',false);
                            prefs.setBool('asTeam',false);
                            prefs.setBool('asLib',false);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              new Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                child: Text("تسجيل خروج",style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold)),
                              ),
                              new Icon(Icons.close),
                            ],
                          ),
                        )
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: _onPageChanged,
        children: [
          AdminCodeGene(),
          AdminViewTeams(),
          AdminViewLibraries(),
          AdminViewStatistic()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('الرئيسية'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.people),
              title: Text('الفرق')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.work),
              title: Text('المكاتب')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              title: Text('احصائيات')
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
      ),
    );
  }

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
      switch(index){
        case 0:
          _appBar = AppBar(
            title: Text("Gene App"),
            centerTitle: true,
          );
          break;
        case 1:
          _appBar = AppBar(
            title: Text("Gene App"),
            centerTitle: true,
            leading: IconButton(
              onPressed: (){},
              icon: Icon(Icons.add),
              color: Colors.white,
            ),
          );
          break;
        case 2:
          _appBar = AppBar(
            title: Text("Gene App"),
            centerTitle: true,
            leading: IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AdminAddLib()));
              },
              icon: Icon(Icons.add),
              color: Colors.white,
            ),
          );
          break;
        case 3:
          _appBar = AppBar(
            title: Text("Gene App"),
            centerTitle: true,
          );
          break;
      }
      pageController.animateToPage(_selectedIndex, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    });
  }

  void _onPageChanged(int index){
    setState(() {
      _selectedIndex = index;
      switch(index){
        case 0:
          _appBar = AppBar(
            title: Text("Gene App"),
            centerTitle: true,
          );
          break;
        case 1:
          _appBar = AppBar(
            title: Text("Gene App"),
            centerTitle: true,
            leading: IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AdminAddTeam()));
              },
              icon: Icon(Icons.add),
              color: Colors.white,
            ),
          );
          break;
        case 2:
          _appBar = AppBar(
            title: Text("Gene App"),
            centerTitle: true,
            leading: IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AdminAddLib()));
              },
              icon: Icon(Icons.add),
              color: Colors.white,
            ),
          );
          break;
        case 3:
          _appBar = AppBar(
            title: Text("Gene App"),
            centerTitle: true,
          );
          break;
      }
    });
  }
}
