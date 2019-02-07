import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sensors/sensors.dart';

class ScratchPage extends StatefulWidget {
  @override
  _ScratchPageState createState() => _ScratchPageState();
}

class _ScratchPageState extends State<ScratchPage> {
  Timer timer;
  String date = DateTime.now().toIso8601String();
  String imgrobot = "https://picsum.photos/600/1200";
  String oldimgrobot = "https://picsum.photos/600/1200";

  void printMessage() {
    debugPrint("Callback Clicked");
  }

  void runTimer() {
    if (timer != null) timer.cancel();
    timer = new Timer(new Duration(seconds: 3), () {
      debugPrint("Timer ...");
      setState(() {
        oldimgrobot = "https://picsum.photos/600/1200?" + date;
        date = DateTime.now().toIso8601String();
        imgrobot = "https://picsum.photos/600/1200?" + date;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    accelerometerEvents.listen((AccelerometerEvent event) {
      debugPrint(event.toString());
    });

    //runTimer();
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Hello World"),
        ),
        body: Stack(
          children: <Widget>[
            Row(
              children: <Widget>[Expanded(child: imageRobot(imgrobot))],
            ),
            ListView(
              children: <Widget>[
                controlMotors(),
                controlCamera(),
                floatButton("Click Me !!!", printMessage),
                TextField(
                  keyboardType: TextInputType.number,
                ),
              ],
            )
          ],
        ));
  }
}

Widget controlMotors() {
  return Column(
    children: <Widget>[
      Divider(
        height: 50,
      ),
      Text("Moteur"),
      Row(
        children: <Widget>[
          Expanded(child: RaisedButton(onPressed: () {}, child: Text("Left"))),
          Expanded(child: RaisedButton(onPressed: () {}, child: Text("Top"))),
          Expanded(
              child: RaisedButton(onPressed: () {}, child: Text("Bottom"))),
          Expanded(child: RaisedButton(onPressed: () {}, child: Text("Right"))),
        ],
      ),
    ],
  );
}

Widget controlCamera() {
  return Column(
    children: <Widget>[
      Divider(
        height: 50,
      ),
      Text("Caméra"),
      Row(
        children: <Widget>[
          Expanded(child: RaisedButton(onPressed: () {}, child: Text("Left"))),
          Expanded(
              child: RaisedButton(onPressed: () {}, child: Text("Center"))),
          Expanded(child: RaisedButton(onPressed: () {}, child: Text("Right"))),
        ],
      ),
    ],
  );
}

Widget imageRobot(String url) {
  return Image.network(
    url,
    gaplessPlayback: true,
    fit: BoxFit.fill,
  );
}

Widget floatButton(String title, Function callback) {
  return Padding(
    padding: EdgeInsets.all(20),
    child: RaisedButton(
      child: Text("$title"),
      onPressed: () {
        callback();
      },
    ),
  );
}
