import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'shared.dart';

var sharedObject = new SharedObject();

class LandscapePage extends StatefulWidget {
  @override
  _LandscapePageState createState() => _LandscapePageState();
}

class _LandscapePageState extends State<LandscapePage> {
  double _height = 0;
  double _opacity = 0.2;

  bool hLeftMove = false;
  bool hRightMove = false;
  bool vUpMove = false;
  bool vDownMove = false;

  bool mute = false;

  Timer timer;

  void runTimer() {
    if (timer != null) timer.cancel();
    timer = Timer(Duration(seconds: 2), () {
      setState(() {
        _height = 448;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    runTimer();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    debugPrint("Width = $width");
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        body: Row(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  GestureDetector(
                    onHorizontalDragStart: (e) {
                      hLeftMove = false;
                      hRightMove = false;
                    },
                    onHorizontalDragUpdate: (e) {
                      if (hLeftMove == false && hRightMove == false) {
                        hLeftMove = e.primaryDelta < 0;
                        hRightMove = e.primaryDelta > 0;
                        hLeftMove ? debugPrint("Left") : debugPrint("Right");
                      }
                    },
                    onHorizontalDragEnd: (e) {},
                    onVerticalDragStart: (e) {
                      vUpMove = false;
                      vDownMove = false;
                    },
                    onVerticalDragEnd: (e) {},
                    onVerticalDragUpdate: (e) {
                      if (vUpMove == false && vDownMove == false) {
                        vUpMove = e.primaryDelta > 0;
                        vDownMove = e.primaryDelta < 0;
                        vUpMove ? debugPrint("Down") : debugPrint("UP");
                      }
                    },
                    child: AnimatedOpacity(
                      duration: Duration(seconds: 1),
                      opacity: _opacity,
                      child: AnimatedContainer(
                        height: _height,
                        curve: Curves.easeIn,
                        duration: Duration(seconds: 1),
                        child: Image.network(
                          "https://picsum.photos/800/800",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: ListView(
                  children: <Widget>[
                    Divider(
                      height: 40,
                      color: Colors.transparent,
                    ),
                    StreamBuilder<int>(
                        stream: sharedObject.speed,
                        initialData: 50,
                        builder: (BuildContext c, AsyncSnapshot<int> data) {
                          return Text("Speed :" + data.data.toString());
                        }),
                    Text("IP"),
                    TextField(
                      onTap: () {
                        setState(() {
                          _opacity = 0.5;
                        });
                      },
                      keyboardType: TextInputType.numberWithOptions(),
                      style: TextStyle(
                          decorationColor: Colors.red, color: Colors.red),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                      ),
                    ),
                    Divider(
                      height: 80,
                      color: Colors.transparent,
                    ),
                    Text("PORT"),
                    TextField(
                      onTap: () {
                        setState(() {
                          _opacity = 1;
                        });
                      },
                      keyboardType: TextInputType.numberWithOptions(),
                    ),
                    Switch(
                      value: mute,
                      onChanged: (bool newValue) {
                        setState(() {
                          mute = newValue;
                        });
                      },
                    ),
                    mute ? subWidget(sharedObject) : Text("activate me !!"),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

Widget subWidget(SharedObject so) {
  return RaisedButton(
      onPressed: () {
        so.setSpeed(100);
      },
      child: Text("Set Speed"));
}
