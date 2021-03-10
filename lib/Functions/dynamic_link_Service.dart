import 'dart:io';
import 'package:teams/main.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DynamicLinkService {


  _openPDF(String lecName, int lecID) async{
    final filename = lecName;
    String dir = (await getApplicationDocumentsDirectory()).path;
    if (await File('$dir/$filename').exists()){
      navigatorKey.currentState.pushNamed('/pdf', arguments: '$dir/$filename');
    }
    else{
      var lecurl = lecID;
      print('path: $lecID');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var code_id = prefs.getInt('codeID');
      // print("hello");
      var url = 'http://gene-team.com/public/api/lectures/downloadThePDF/$lecurl/${code_id}';
      print('http://gene-team.com/public/api/lectures/downloadThePDF/$lecurl/${code_id}');
      // print("hello2");
      /// requesting http to get url
      var request = await HttpClient().getUrl(Uri.parse(url));
      // print("hello3");
      /// closing request and getting response
      var response = await request.close();
      // print("hello4");
      /// getting response data in bytes
      var bytes = await consolidateHttpClientResponseBytes(response);
      // print("hello5");
      /// generating a local system file with name as 'filename' and path as '$dir/$filename'
      File file = new File('$dir/$filename');
      // print("hello6");
      /// writing bytes data of response in the file.
      await file.writeAsBytes(bytes);
      // print("hello7");
      print("fuck");
      navigatorKey.currentState.pushNamed('/pdf', arguments: '$dir/$filename');
    }
  }

  Future<void> retrieveDynamicLink(BuildContext context) async {
    try {
      final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri deepLink = data?.link;

      if (deepLink != null) {
        var lecName = deepLink.queryParameters['lecName'];
        var lecID = int.parse(deepLink.queryParameters['lecID']);
        print("initDynamicLinks 1 | lecName : $lecName lecID : $lecID");
        await _openPDF(lecName, lecID);

      }

      FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData dynamicLink) async {
        final Uri deepLink = dynamicLink?.link;
        if (deepLink != null) {
          print("deepLink service: $deepLink");
          var isLec = deepLink.pathSegments.contains('lecture');
          if(isLec){
            var lecName = deepLink.queryParameters['lecName'];
            var lecID = int.parse(deepLink.queryParameters['lecID']);
            print("initDynamicLinks 1 | lecName : $lecName lecID : $lecID");
            await _openPDF(lecName, lecID);
          }
        }
        else
          print('its null 1');
      });

    } catch (e) {
      print(e.toString());
    }
  }




  Future<Uri> createDynamicLink() async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://geneapp.page.link',
      link: Uri.parse('https://www.geneapp.com'),
      androidParameters: AndroidParameters(
        packageName: 'com.example.teams',
        minimumVersion: 1,
      ),
    );
    var dynamicUrl = await parameters.buildUrl();

    return dynamicUrl;
  }

}