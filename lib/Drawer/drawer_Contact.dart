import 'package:flutter/material.dart';
import 'package:teams/Utils/styles.dart';
import 'package:url_launcher/url_launcher.dart';


class DrawerContact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Styles.primaryColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new Text('Gene App', style: TextStyle(fontSize: 36,color: Colors.white,fontFamily: 'Markazi_Text',fontWeight: FontWeight.bold),),
                new Text('اصدار 1.0.0',style: TextStyle(fontSize: 24,color: Colors.white,fontFamily: 'Markazi_Text'),),
                new Image.asset('assets/images/logo.png'),
                new Text('جميع الحقوق محفوظة © لصالح فريق جين',style: TextStyle(fontSize: 24,color: Colors.white,fontFamily: 'Markazi_Text'),textAlign: TextAlign.center,),
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new FlatButton(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      new Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                      new Image.asset('assets/images/facebook.png',height: 22,width: 22,color: Styles.primaryColor,)
                    ],
                  ),
                  onPressed: () async{
                    const url = 'https://www.facebook.com/Gene-App-105831114683610/';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
                new FlatButton(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      new Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                      new Image.asset('assets/images/instagram.png',height: 27,width: 27,color: Styles.primaryColor,)
                    ],
                  ),
                  onPressed: () async{
                    const url = 'https://instagram.com/gene_app2020?igshid=1din35rkox2ux';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
                new FlatButton(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      new Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                      new Image.asset('assets/images/telegram.png',height: 22,width: 22,color: Styles.primaryColor,)
                    ],
                  ),
                  onPressed: () async{
                    const url = 'https://t.me/Gene_App_Bot';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
