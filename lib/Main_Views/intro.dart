import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teams/Main_Views/login.dart';
import 'package:teams/Utils/styles.dart';

class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  final _pageViewController = new PageController(
    initialPage: 0,
  );
  Color _left = Styles.primaryColor;
  Color _left1 = Colors.grey[300];
  Color _left2 = Colors.grey[300];
  Color _mid = Colors.grey[300];
  Color _right = Colors.grey[300];
  Color _right1 = Colors.grey[300];
  Color _right2 = Colors.grey[300];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return PageView(
      onPageChanged: (page) {
        if (page == 0) {
          setState(() {
            _left = Styles.primaryColor;
            _left1 = Colors.grey[300];
            _left2 = Colors.grey[300];
            _mid = Colors.grey[300];
            _right = Colors.grey[300];
            _right1 = Colors.grey[300];
            _right2 = Colors.grey[300];
          });
        }
        else if (page == 1) {
          setState(() {
            _left = Colors.grey[300];
            _left1 = Styles.primaryColor;
            _left2 = Colors.grey[300];
            _mid = Colors.grey[300];
            _right = Colors.grey[300];
            _right1 = Colors.grey[300];
            _right2 = Colors.grey[300];
          });
        } else if (page == 2) {
          setState(() {
            _left = Colors.grey[300];
            _left1 = Colors.grey[300];
            _left2 = Styles.primaryColor;
            _mid = Colors.grey[300];
            _right = Colors.grey[300];
            _right1 = Colors.grey[300];
            _right2 = Colors.grey[300];
          });
        } else if (page == 3) {
          setState(() {
            _left = Colors.grey[300];
            _left1 = Colors.grey[300];
            _left2 = Colors.grey[300];
            _mid = Styles.primaryColor;
            _right = Colors.grey[300];
            _right1 = Colors.grey[300];
            _right2 = Colors.grey[300];
          });
        } else if (page == 4) {
          setState(() {
            _left = Colors.grey[300];
            _left1 = Colors.grey[300];
            _left2 = Colors.grey[300];
            _mid = Colors.grey[300];
            _right = Colors.grey[300];
            _right1 = Styles.primaryColor;
            _right2 = Colors.grey[300];
          });
        } else if (page == 5) {
          setState(() {
            _left = Colors.grey[300];
            _left1 = Colors.grey[300];
            _left2 = Colors.grey[300];
            _mid = Colors.grey[300];
            _right = Colors.grey[300];
            _right1 = Colors.grey[300];
            _right2 = Styles.primaryColor;
          });
        } else if (page == 6) {
          setState(() {
            _left = Colors.grey[300];
            _left1 = Colors.grey[300];
            _left2 = Colors.grey[300];
            _mid = Colors.grey[300];
            _right = Styles.primaryColor;
            _right1 = Colors.grey[300];
            _right2 = Colors.grey[300];
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
                        image: AssetImage('assets/images/designs/1.png'),
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
                      _pageViewController.animateToPage(6,
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
                      Container(
                        width: 15,
                        height: 15,
                        decoration:
                        BoxDecoration(shape: BoxShape.circle, color: _left),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _left1,
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
                            color: _left2,
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
                            color: _right1,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _right2,
                          ),
                        ),
                      ),
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: _right),
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
                            image: AssetImage('assets/images/designs/2.png'),
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
                      _pageViewController.animateToPage(6,
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
                      Container(
                        width: 15,
                        height: 15,
                        decoration:
                        BoxDecoration(shape: BoxShape.circle, color: _left),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _left1,
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
                            color: _left2,
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
                            color: _right1,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _right2,
                          ),
                        ),
                      ),
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: _right),
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
                            image: AssetImage('assets/images/designs/3.png'),
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
                      _pageViewController.animateToPage(6,
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
                      Container(
                        width: 15,
                        height: 15,
                        decoration:
                            BoxDecoration(shape: BoxShape.circle, color: _left),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _left1,
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
                            color: _left2,
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
                            color: _right1,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _right2,
                          ),
                        ),
                      ),
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: _right),
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
                      _pageViewController.animateToPage(6,
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
                      Container(
                        width: 15,
                        height: 15,
                        decoration:
                        BoxDecoration(shape: BoxShape.circle, color: _left),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _left1,
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
                            color: _left2,
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
                            color: _right1,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _right2,
                          ),
                        ),
                      ),
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: _right),
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
                          _pageViewController.animateToPage(4,
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
                      _pageViewController.animateToPage(6,
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
                      Container(
                        width: 15,
                        height: 15,
                        decoration:
                        BoxDecoration(shape: BoxShape.circle, color: _left),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _left1,
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
                            color: _left2,
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
                            color: _right1,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _right2,
                          ),
                        ),
                      ),
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: _right),
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
                          _pageViewController.animateToPage(5,
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
                      _pageViewController.animateToPage(6,
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
                      Container(
                        width: 15,
                        height: 15,
                        decoration:
                        BoxDecoration(shape: BoxShape.circle, color: _left),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _left1,
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
                            color: _left2,
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
                            color: _right1,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _right2,
                          ),
                        ),
                      ),
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: _right),
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
                          _pageViewController.animateToPage(6,
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
                      Container(
                        width: 15,
                        height: 15,
                        decoration:
                        BoxDecoration(shape: BoxShape.circle, color: _left),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _left1,
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
                            color: _left2,
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
                            color: _right1,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _right2,
                          ),
                        ),
                      ),
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: _right),
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
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
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
