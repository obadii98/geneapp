import 'dart:io';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_skeleton/flutter_skeleton.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teams/Student_Views/pdf.dart';
import 'package:teams/Utils/styles.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class TeamViewLec extends StatefulWidget {

  int courseID;
  TeamViewLec(int id){
    courseID = id;
  }


  @override
  _TeamViewLecState createState() => _TeamViewLecState();
}

class _TeamViewLecState extends State<TeamViewLec> {


  static GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  Map<String,dynamic> _lecturesPDF = new Map<String, dynamic>();
  var lecData;
  Widget img;


  @override
  void initState() {
    lecData = "init";
    img = Container();
  }

  _getFirstImage() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var teamType = prefs.getString('teamType');
    switch(int.parse(teamType)) {
      case 1:
        print("wtf img1");
        img = Image.asset("assets/images/first_page/dna.png",height: 160,width: 100,fit: BoxFit.fitHeight,);
        break;
      case 2:
        img = Image.asset("assets/images/first_page/online.png",height: 160,width: 100,fit: BoxFit.fitHeight);
        break;
      case 3:
        img = Image.asset("assets/images/first_page/xray.png",height: 160,width: 100,fit: BoxFit.fitHeight);
        break;
      case 4:
        img = Image.asset("assets/images/first_page/abc-team.png",height: 160,width: 100,fit: BoxFit.fitHeight);
        break;
      case 5:
        img = Image.asset("assets/images/first_page/for-all.png",height: 160,width: 100,fit: BoxFit.fitHeight);
        break;
      case 6:
        img = Image.asset("assets/images/first_page/for-all.png",height: 160,width: 100,fit: BoxFit.fitHeight);
        break;
      case 7:
        img = Image.asset("assets/images/first_page/dna.png",height: 160,width: 100,fit: BoxFit.fitHeight);
        break;
      case 8:
        img = Image.asset("assets/images/first_page/dna.png",height: 160,width: 100,fit: BoxFit.fitHeight);
        break;
      default:
        img = Image.asset("assets/images/first_page/dna.png",height: 160,width: 100,fit: BoxFit.fitHeight);
        break;
    }
  }

  _getCourseLecs() async {
    var url = 'http://gene-team.com/public/api/courses/lectures/${widget.courseID}';
    var response = await http.get(url);
    lecData = json.decode(response.body) as List;
    print('lec body: ${response.statusCode}');
    print('lec body: ${response.body}');
    // for(int i = 0 ; i < data.length ; i++){
    //   _lecturesPDF[data[i]['id']] = data[i]['lecture'];
    // }
    // for(int i = 0 ; i < data.length ; i++){
    //   _lecturesNames[data[i]['id']] = data[i]['name'];
    // }

  }

  _forAnimation(){
    if(lecData == "init")
      return CardListSkeleton(
        style: SkeletonStyle(
          theme: SkeletonTheme.Light,
          isShowAvatar: true,
          isCircleAvatar: false,
          barCount: 2,
        ),
      );
    else if(lecData.length == 0)
      return Center(
        child: Text("لا يوجد اي محاضرات مضافة",style: TextStyle(fontSize: 30),),
      );
    else
      return ListView.builder(
        itemCount: lecData.length,
        itemBuilder: (context,index){
          return Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  new Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: (){
                          createDynamicLink(false, lecData[index]['id'], lecData[index]['name']);
                        },
                        icon: Icon(Icons.share),
                      ),
                      FlatButton(
                        onPressed: (){
                          setState(() {
                            showDialog(
                                context: context,
                                builder: (_) => new AlertDialog(
                                  title: new Center(
                                    child: Text(lecData[index]['lecture'].toString()),
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('عودة'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('حذف'),
                                      onPressed: () async{
                                        print("lec id: ${lecData[index]['id']}");
                                        var url = 'http://gene-team.com/public/api/lectures/${lecData[index]['id']}';
                                        var response = await http.delete(url);
                                        print('delete statuscode: ${response.statusCode}');
                                        print('delete body: ${response.body}');
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('عرض'),
                                      onPressed: () async{
                                        final filename = lecData[index]['name'];
                                        String dir = (await getApplicationDocumentsDirectory()).path;
                                        if (await File('$dir/$filename').exists()) {
                                          Navigator.pop(context);
                                          Navigator.push(context, MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  pdfView('$dir/$filename')));
                                        }
                                        else{
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
                                            var lecurl = lecData[index]['id'];
                                            var url = 'http://gene-team.com/public/api/lectures/downloadThePDF/$lecurl/0';
                                            /// requesting http to get url
                                            var request = await HttpClient().getUrl(Uri.parse(url));
                                            /// closing request and getting response
                                            var response = await request.close();
                                            /// getting response data in bytes
                                            var bytes = await consolidateHttpClientResponseBytes(response);
                                            /// generating a local system file with name as 'filename' and path as '$dir/$filename'
                                            File file = new File('$dir/$filename');
                                            /// writing bytes data of response in the file.
                                            await file.writeAsBytes(bytes);
                                            Navigator.pop(context);Navigator.pop(context);
                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => pdfView('$dir/$filename')));
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ));
                          });
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            new Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Container(
                                  height: 160,
                                  width: 100,
                                  child: FutureBuilder(
                                    future: _getFirstImage(),
                                    builder: (context, snapshot){
                                      return img;
                                    },
                                  )
                                )
                            ),
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                new Padding(
                                  padding: EdgeInsets.fromLTRB(0.0, 35.0, 0.0, 0.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width/3,
                                    height: 150,
                                    child: Text(lecData[index]['name'],style: TextStyle(fontSize: 20.0),textAlign: TextAlign.right,),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  new Divider(
                    height: 1,
                    color: Colors.black,
                  )
                ],
              )
          );
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text("Gene App"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
          child: FutureBuilder(
            future: _getCourseLecs(),
            builder: (context,snapshot){
              return _forAnimation();
            },
          )
      ),
    );
  }


  String _linkMessage;
  bool _isCreatingLink = false;


  Future<void> createDynamicLink(bool short, int lecID, String lecName) async{
    setState(() {
      _isCreatingLink = true;
    });
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://geneapp.page.link',
        navigationInfoParameters: NavigationInfoParameters(forcedRedirectEnabled: true),
        link: Uri.parse('https://www.geneapp.com/lecture?lecID=$lecID&lecName=$lecName'),
        androidParameters: AndroidParameters(packageName: 'com.example.teams',minimumVersion: 0),
        dynamicLinkParametersOptions: DynamicLinkParametersOptions(
            shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short
        ),
        iosParameters: IosParameters(
          bundleId: 'com.google.FirebaseCppDynamicLinksTestApp.dev',
          minimumVersion: '0',
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
            title: "$lecName",
            description: "محاضرة جديدة"
        )
    );
    print("https://geneapp.page.link/lecture?lecID=$lecID&lecName=$lecName");
    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url = shortLink.shortUrl;
    } else {
      url = await parameters.buildUrl();
    }

    setState(() {
      _linkMessage = url.toString();
      _isCreatingLink = false;
    });
    print(url);
    Clipboard.setData(new ClipboardData(text: '$url'));
    FocusScope.of(context).requestFocus(new FocusNode());
    scaffoldKey.currentState?.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text("تم تسخ رابط المحاضرة",style: TextStyle(fontSize: 16)),
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
