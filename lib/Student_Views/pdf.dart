import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:teams/Functions/secured_app.dart';
import 'package:flutter/widgets.dart';


class pdfView extends StatefulWidget {

  static const String routeName = '/pdf';

  String path;

  pdfView(String path) {
    this.path = path;
  }

  @override
  _pdfViewState createState() => _pdfViewState();
}

class _pdfViewState extends State<pdfView> {


  void initDynamicLinks() async{
    print("in");
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          final Uri deepLink = dynamicLink?.link;
          if (deepLink != null) {
            print("deepLink pdf: $deepLink");
            var isLec = deepLink.pathSegments.contains('lecture');
            if(isLec){
              var lecName = deepLink.queryParameters['lecName'];
              var lecID = int.parse(deepLink.queryParameters['lecID']);
              print("initDynamicLinks pdf | lecName : $lecName lecID : $lecID");
            }
          }
          else
            print('its null');
        }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deeplink = data?.link;
    print("outside deeplink pdf: $deeplink");
    if(deeplink != null){
      var lecName = deeplink.queryParameters['lecName'];
      var lecID = int.parse(deeplink.queryParameters['lecID']);
      print("initDynamicLinks | lecName : $lecName lecID : $lecID");
    }
  }

  @override
  void initState() {
    SecuredApp.secureScreen();
    this.initDynamicLinks();
  }

  var fileStream;
  String title = 'waiting';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gene App"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: PDF(
      ).fromPath(widget.path),
    );
  }
}