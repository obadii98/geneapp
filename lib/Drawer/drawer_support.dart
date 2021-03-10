import 'package:flutter/material.dart';
import 'package:teams/Utils/styles.dart';

class DrawerSupport extends StatelessWidget {

  String _support = ':مطوري البرنامج';
  String _obada = 'عبادة بقلة: 0951490964';
  String _ahmad = 'احمد جمال الدين: 0937317684';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gene App"),
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            new Padding(
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 0.0),
              child: Text("الدعم الفني", style: TextStyle(fontSize: 22.0,color: Styles.primaryColor)),
            ),
            new Padding(
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 0.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*(60/100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(_support, style: TextStyle(fontSize: 18.0),maxLines: 20,overflow: TextOverflow.ellipsis,textAlign: TextAlign.right,),
                    Text(_obada, style: TextStyle(fontSize: 16.0),maxLines: 20,overflow: TextOverflow.ellipsis,textAlign: TextAlign.right,),
                    Text(_ahmad, style: TextStyle(fontSize: 16.0),maxLines: 20,overflow: TextOverflow.ellipsis,textAlign: TextAlign.right,),
                  ],
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
