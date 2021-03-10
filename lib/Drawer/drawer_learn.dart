import 'package:flutter/material.dart';
import 'package:teams/Student_Views/student_view_team.dart';
import 'package:teams/Utils/styles.dart';

class DrawerLearn extends StatefulWidget {
  @override
  _DrawerLearnState createState() => _DrawerLearnState();
}

class _DrawerLearnState extends State<DrawerLearn> {

  final _pageViewController = new PageController(
    initialPage: 0,
  );
  Color _left = Styles.primaryColor;
  Color _mid = Colors.grey[300];
  Color _mid2 = Colors.grey[300];
  Color _right = Colors.grey[300];

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    return PageView(
      onPageChanged: (page){
        if(page == 0){
          setState(() {
            _left = Styles.primaryColor;
            _mid = Colors.grey[300];
            _mid2 = Colors.grey[300];
            _right = Colors.grey[300];
          });
        }
        else if(page == 1){
          setState(() {
            _left = Colors.grey[300];
            _mid = Styles.primaryColor;
            _mid2 = Colors.grey[300];
            _right = Colors.grey[300];
          });
        }
        else if(page == 2){
          setState(() {
            _left = Colors.grey[300];
            _mid = Colors.grey[300];
            _mid2 = Styles.primaryColor;
            _right = Colors.grey[300];
          });
        }
        else {
          setState(() {
            _left = Colors.grey[300];
            _mid = Colors.grey[300];
            _mid2 = Colors.grey[300];
            _right = Styles.primaryColor;
          });
        }
      },
      controller: _pageViewController,
      children: [
        new SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Positioned(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/designs/4.png'),
                            fit: BoxFit.fill
                        )
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: -5,
                  child: FlatButton(
                    child: Text(
                      "skip",
                      style: TextStyle(fontSize: 26.0),
                    ),
                    onPressed: () {
                      _pageViewController.animateToPage(3,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                  ),
                ),
                Positioned(
                  bottom: 35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _left,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _mid,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _mid2,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _right,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    bottom: 15,
                    right: -5,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: FlatButton(
                        child: Icon(
                          Icons.arrow_forward,
                          size: 32.0,
                        ),
                        onPressed: () {
                          _pageViewController.animateToPage(1,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease);
                        },
                      ),
                    )),
              ],
            ),
          ),
        ),
        new SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Positioned(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/designs/5.png'),
                            fit: BoxFit.fill
                        )
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: -5,
                  child: FlatButton(
                    child: Text(
                      "skip",
                      style: TextStyle(fontSize: 26.0),
                    ),
                    onPressed: () {
                      _pageViewController.animateToPage(3,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                  ),
                ),
                Positioned(
                  bottom: 35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _left,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _mid,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _mid2,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _right,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    bottom: 15,
                    right: -5,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: FlatButton(
                        child: Icon(
                          Icons.arrow_forward,
                          size: 32.0,
                        ),
                        onPressed: () {
                          _pageViewController.animateToPage(2,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease);
                        },
                      ),
                    )),
              ],
            ),
          ),
        ),
        new SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Positioned(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/designs/6.png'),
                            fit: BoxFit.fill
                        )
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: -5,
                  child: FlatButton(
                    child: Text(
                      "skip",
                      style: TextStyle(fontSize: 26.0),
                    ),
                    onPressed: () {
                      _pageViewController.animateToPage(3,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                  ),
                ),
                Positioned(
                  bottom: 35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _left,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _mid,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _mid2,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _right,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    bottom: 15,
                    right: -5,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: FlatButton(
                        child: Icon(
                          Icons.arrow_forward,
                          size: 32.0,
                        ),
                        onPressed: () {
                          _pageViewController.animateToPage(3,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease);
                        },
                      ),
                    )),
              ],
            ),
          ),
        ),
        new SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Positioned(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/designs/7.png'),
                            fit: BoxFit.fill
                        )
                    ),
                  ),
                ),
                Positioned(
                  bottom: 35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _left,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _mid,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _mid2,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _right,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: -5,
                  child: FlatButton(
                    child: Text(
                      "done",
                      style: TextStyle(fontSize: 24.0),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

