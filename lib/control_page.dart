import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'socket.dart';

class ControlPage extends StatefulWidget {
  ControlPage({Key key, this.socket}) : super(key: key);

  final RobotSocket socket;

  @override
  _ControlPageState createState() => _ControlPageState(socket: socket);
}

class _ControlPageState extends State<ControlPage> {
  _ControlPageState({this.socket});

  final RobotSocket socket;
  double speed = 50.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Controls"),
      ),
      body: StreamBuilder<bool>(
        stream: socket.isConnected,
        initialData: false,
        builder: (BuildContext c, AsyncSnapshot<bool> data) {
          if (data.data)
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: <Widget>[
                  Center(
                    child: RaisedButton(
                        onPressed: () {
                          socket.write("DETECT");
                        },
                        child: Text("Capteurs")),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: StreamBuilder<bool>(
                              stream: socket.avg,
                              initialData: false,
                              builder:
                                  (BuildContext c, AsyncSnapshot<bool> data) {
                                if (data.data)
                                  return Icon(FontAwesomeIcons.solidCircle);
                                else {
                                  return Icon(FontAwesomeIcons.circle);
                                }
                              })),
                      Expanded(
                          child: StreamBuilder<bool>(
                              stream: socket.avd,
                              initialData: false,
                              builder:
                                  (BuildContext c, AsyncSnapshot<bool> data) {
                                if (data.data)
                                  return Icon(FontAwesomeIcons.solidCircle);
                                else
                                  return Icon(FontAwesomeIcons.circle);
                              })),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: StreamBuilder<bool>(
                              stream: socket.arg,
                              initialData: false,
                              builder:
                                  (BuildContext c, AsyncSnapshot<bool> data) {
                                if (data.data)
                                  return Icon(FontAwesomeIcons.solidCircle);
                                else
                                  return Icon(FontAwesomeIcons.circle);
                              })),
                      Expanded(
                          child: StreamBuilder<bool>(
                              stream: socket.ard,
                              initialData: false,
                              builder:
                                  (BuildContext c, AsyncSnapshot<bool> data) {
                                if (data.data)
                                  return Icon(FontAwesomeIcons.solidCircle);
                                else
                                  return Icon(FontAwesomeIcons.circle);
                              })),
                    ],
                  ),
                  Divider(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text("Moteur")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            onTapDown: (e) {
                              print("Go Left " + speed.toInt().toString());
                              socket
                                  .write("GAUCHE " + speed.toInt().toString());
                            },
                            onTapUp: (e) {
                              print("Stop");
                              socket.write("ARRET");
                            },
                            child: Icon(FontAwesomeIcons.arrowLeft),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTapDown: (e) {
                              print("Go Up " + speed.toInt().toString());
                              socket
                                  .write("AVANCER " + speed.toInt().toString());
                            },
                            onTapUp: (e) {
                              print("Stop");
                              socket.write("ARRET");
                            },
                            child: Icon(FontAwesomeIcons.arrowUp),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTapDown: (e) {
                              print("Go Down " + speed.toInt().toString());
                              socket
                                  .write("RECULER " + speed.toInt().toString());
                            },
                            onTapUp: (e) {
                              print("Stop");
                              socket.write("ARRET");
                            },
                            child: Icon(FontAwesomeIcons.arrowDown),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTapDown: (e) {
                              print("Go Right " + speed.toInt().toString());
                              socket
                                  .write("DROITE " + speed.toInt().toString());
                            },
                            onTapUp: (e) {
                              print("Stop");
                              socket.write("ARRET");
                            },
                            child: Icon(FontAwesomeIcons.arrowRight),
                          ),
                        )
                      ],
                    ),
                  ),
                  Slider(
                    value: speed,
                    max: 100,
                    min: 0,
                    onChanged: (double e) => speedChanged(e),
                  ),
                  Divider(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text("Pince")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            onTapDown: (e) {
                              print("Ouvrir Pince");
                              socket.write("OUVRIR_PINCE");
                            },
                            child: Icon(FontAwesomeIcons.teethOpen),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTapDown: (e) {
                              print("Lever Pince");
                              socket.write("LEVER_PINCE");
                            },
                            child: Icon(FontAwesomeIcons.arrowUp),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTapDown: (e) {
                              print("Baisser Pince");
                              socket.write("BAISSER_PINCE");
                            },
                            child: Icon(FontAwesomeIcons.arrowDown),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTapDown: (e) {
                              print("Fermer Pince");
                              socket.write("FERMER_PINCE");
                            },
                            child: Icon(FontAwesomeIcons.teeth),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: RaisedButton(
                              onPressed: () {
                                print("Video Start");
                                socket.write("VIDEO_START");
                              },
                              child: Icon(FontAwesomeIcons.video))),
                      Expanded(
                          child: RaisedButton(
                              onPressed: () {
                                print("Video Stop");
                                socket.write("VIDEO_STOP");
                              },
                              child: Icon(FontAwesomeIcons.stop))),
                    ],
                  ),
                  Image.network(
                      "http://foundationzoein.org/wp-content/uploads/2018/08/80_mars_carousel_5.jpg"),
                  Divider(
                    height: 20,
                  ),
                  RaisedButton(
                      onPressed: () {},
                      child: Column(
                        children: <Widget>[
                          Icon(FontAwesomeIcons.mapMarkerAlt),
                          Text("0,0")
                        ],
                      )),
                  Center(
                    child: RaisedButton(
                        onPressed: () {
                          socket.close();
                          Navigator.pop(context);
                        },
                        child: Icon(FontAwesomeIcons.signOutAlt)),
                  ),
                ],
              ),
            );
          else
            return Text("You have been disconnected");
        },
      ),
    );
  }

  void speedChanged(e) {
    setState(() {
      speed = e;
    });
  }
}
