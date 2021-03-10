import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teams/Login_Utils/style/theme.dart' as Theme;
import 'package:http/http.dart' as http;

class SendNotification extends StatefulWidget {
  @override
  _SendNotificationState createState() => _SendNotificationState();
}

class _SendNotificationState extends State<SendNotification> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _genCodeKey = GlobalKey<FormState>();

  TextEditingController _codeCont = new TextEditingController();
  TextEditingController _titleCont = new TextEditingController();
  TextEditingController _bodyCont = new TextEditingController();


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

  _sendNotification() async{
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
      var url = 'http://gene-team.com/public/api/sendNot';
      var response = await http.post(url,body: {'code': _codeCont.text, 'title': _titleCont.text, 'body': _bodyCont.text});
      print('notification status code: ${response.statusCode}');
      print('notification body: ${response.body}');
      if(response.statusCode == 200)
        showInSnackBar(true);
      else
        showInSnackBar(false);
      Navigator.pop(context);
    });
  }


  Widget _buildForm(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Container(
      height: 400,
      padding: EdgeInsets.only(top: 23.0),
      child: ListView(
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
                  height: 300.0,
                  child: Form(
                    key: _genCodeKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextFormField(
                            controller: _codeCont,
                            validator: (value){
                              if(value.isEmpty)
                                return "الرجاء ادخال كود";
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
                                Icons.code,
                                color: Colors.black,
                              ),
                              hintText: "ادخل الكود",
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
                            controller: _titleCont,
                            validator: (value){
                              if(value.isEmpty)
                                return "الرجاء ادخال عنوان";
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
                                Icons.title,
                                color: Colors.black,
                              ),
                              hintText: "ادخل عنوان الاشعار",
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
                            controller: _bodyCont,
                            validator: (value){
                              if(value.isEmpty)
                                return "الرجاء ادخال محتوى";
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
                                Icons.text_fields,
                                color: Colors.black,
                              ),
                              hintText: "ادخل محتوى الاشعار",
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
                        "ارسال اشعار",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,),
                      ),
                    ),
                    onPressed: () async {
                      _sendNotification();
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('ارسل اشعار'),
      ),
      body: Center(
        child: ListView(
          children: [
            new ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0),topRight: Radius.circular(25.0)),
              child: Image.asset("assets/images/splash_logo.png",width: MediaQuery.of(context).size.width*(35/100)),
            ),
            _buildForm(context)
          ],
        ),
      ),
    );
  }
}
