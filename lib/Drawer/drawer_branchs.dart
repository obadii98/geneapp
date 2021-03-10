import 'package:flutter/material.dart';
import 'package:teams/Utils/styles.dart';

class DrawerBranches extends StatelessWidget {

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
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            new Padding(
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 0.0),
              child: Text("محافظة حمص •", style: TextStyle(fontSize: 22.0,color: Styles.primaryColor)),
            ),
            new Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 35.0, 0.0),
              child: Text("١ـ مكتبة طريف", style: TextStyle(fontSize: 18.0)),
            ),
            new Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 35.0, 0.0),
              child: Text("٢ـ مكتبة الطب", style: TextStyle(fontSize: 18.0)),
            ),
            new Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 35.0, 0.0),
              child: Text("٣ـ مكتبة سما الذهبية", style: TextStyle(fontSize: 18.0)),
            ),
            new Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 35.0, 0.0),
              child: Text("٤ـ مكتبة أسامة", style: TextStyle(fontSize: 18.0)),
            ),
            new Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 35.0, 0.0),
              child: Text("٥ـ مكتبة سما", style: TextStyle(fontSize: 18.0)),
            ),
            new Divider(
              color: Colors.black,
              height: 1,
              thickness: 0.5,
            )
          ],
        ),
      ),
    );
  }
}
