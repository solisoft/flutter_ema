import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:sensors/sensors.dart';

import 'socket.dart';
import 'dart:async';

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
  String date = DateTime.now().toIso8601String();

  IconData iconMenuPince1 = FontAwesomeIcons.dotCircle;
  IconData iconMenuPince2 = FontAwesomeIcons.dotCircle;

  Timer timer;

  String imagerobot = "https://picsum.photos/1200/800";

  void runTimer() {
    timer = new Timer(new Duration(seconds: 3), () {
      date = DateTime.now().toIso8601String();
      debugPrint("http://" + socket.ip + "/vueRobot.jpg?" + date);
      setState(() {
        imagerobot = "http://" + socket.ip + "/vueRobot.jpg?" + date;
      });
    });
  }

  String convertGPS(String coords) {
    if (coords != "") {
      int degree = int.parse(coords.split("Â°")[0]);
      int minutes = int.parse(coords.split("Â°")[1].split("'")[0]);
      double secondes =
          double.parse(coords.split("Â°")[1].split("'")[1].split('"')[0]);

      if (coords.indexOf("S") > 0) degree = 0 - degree;
      if (coords.indexOf("O") > 0) degree = 0 - degree;
      num decimal = degree + minutes / 60 + secondes / 3600;
      return "$decimal";
    } else {
      return "";
    }
  }

  List<String> commands = [];

  @override
  initState() {
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {});

    gyroscopeEvents.listen((GyroscopeEvent event) {});
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(socket.boolConnected.toString());

    runTimer();

    return Scaffold(
      appBar: AppBar(
        title: Text("My Controls"),
      ),
      body: StreamBuilder<bool>(
        stream: socket.isConnected,
        initialData: false,
        builder: (BuildContext c, AsyncSnapshot<bool> data) {
          if (data.data)
            return Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: <Widget>[
                    Image.network(imagerobot, gaplessPlayback: true),
                    Center(
                      child: StreamBuilder<List<String>>(
                          stream: socket.messages,
                          initialData: [],
                          builder: (BuildContext c,
                              AsyncSnapshot<List<String>> list) {
                            return Text(list.data.join("\n"));
                          }),
                    ),
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
                                    return Icon(
                                      FontAwesomeIcons.solidCircle,
                                      color: Colors.green,
                                    );
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
                                    return Icon(
                                      FontAwesomeIcons.solidCircle,
                                      color: Colors.green,
                                    );
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
                                    return Icon(
                                      FontAwesomeIcons.solidCircle,
                                      color: Colors.green,
                                    );
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
                                    return Icon(
                                      FontAwesomeIcons.solidCircle,
                                      color: Colors.green,
                                    );
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
                                socket.write(
                                    "GAUCHE " + speed.toInt().toString());
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
                                socket.write(
                                    "AVANCER " + speed.toInt().toString());
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
                                socket.write(
                                    "RECULER " + speed.toInt().toString());
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
                                socket.write(
                                    "DROITE " + speed.toInt().toString());
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
                      child: Row(children: <Widget>[
                        Expanded(child: Text("Pince")),
                        Expanded(child: Icon(iconMenuPince1)),
                        Expanded(child: Icon(iconMenuPince2)),
                      ]),
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
                                setState(() {
                                  iconMenuPince1 = FontAwesomeIcons.lockOpen;
                                });
                              },
                              child: Icon(FontAwesomeIcons.teethOpen),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTapDown: (e) {
                                print("Lever Pince");
                                socket.write("LEVER_PINCE");
                                setState(() {
                                  iconMenuPince2 =
                                      FontAwesomeIcons.arrowAltCircleUp;
                                });
                              },
                              child: Icon(FontAwesomeIcons.arrowUp),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTapDown: (e) {
                                print("Baisser Pince");
                                socket.write("BAISSER_PINCE");
                                setState(() {
                                  iconMenuPince2 =
                                      FontAwesomeIcons.arrowCircleDown;
                                });
                              },
                              child: Icon(FontAwesomeIcons.arrowDown),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTapDown: (e) {
                                print("Fermer Pince");
                                socket.write("FERMER_PINCE");
                                setState(() {
                                  iconMenuPince1 = FontAwesomeIcons.lock;
                                });
                              },
                              child: Icon(FontAwesomeIcons.teeth),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: Text("Caméra")),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              onTapDown: (e) {
                                print("CAM_GAUCHE");
                                socket.write("CAM_GAUCHE");
                              },
                              child: Icon(FontAwesomeIcons.arrowAltCircleLeft),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTapDown: (e) {
                                print("CAM_DEVANT");
                                socket.write("CAM_DEVANT");
                              },
                              child: Icon(FontAwesomeIcons.arrowAltCircleUp),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTapDown: (e) {
                                print("CAM_DROITE");
                                socket.write("CAM_DROITE");
                              },
                              child: Icon(FontAwesomeIcons.arrowAltCircleRight),
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
                    Divider(
                      height: 20,
                    ),
                    RaisedButton(
                        onPressed: () {
                          print("ETAT_BATT");
                          socket.write("ETAT_BATT");
                        },
                        child: Text("Battery")),
                    Center(
                      child: StreamBuilder<num>(
                          stream: socket.volt,
                          initialData: 0,
                          builder: (BuildContext c, AsyncSnapshot<num> data) {
                            if (data.data < 3) {
                              return Icon(FontAwesomeIcons.batteryEmpty);
                            }
                            if (data.data >= 3 && data.data < 6) {
                              return Icon(FontAwesomeIcons.batteryQuarter);
                            }
                            if (data.data >= 6 && data.data < 9) {
                              return Icon(FontAwesomeIcons.batteryHalf);
                            }
                            if (data.data >= 9) {
                              return Icon(FontAwesomeIcons.batteryFull);
                            }
                          }),
                    ),
                    RaisedButton(
                        onPressed: () {
                          print("POS_GPS");
                          socket.write("POS_GPS");
                        },
                        child: Text("POS GPS")),
                    Center(
                      child: StreamBuilder<String>(
                          stream: socket.long,
                          initialData: "",
                          builder:
                              (BuildContext c, AsyncSnapshot<String> data) {
                            return Text(convertGPS(data.data));
                          }),
                    ),
                    Center(
                      child: StreamBuilder<String>(
                          stream: socket.lat,
                          initialData: "",
                          builder:
                              (BuildContext c, AsyncSnapshot<String> data) {
                            return Text(convertGPS(data.data));
                          }),
                    ),
                    RaisedButton(
                        onPressed: () {
                          print("DIST_US");
                          socket.write("DIST_US");
                        },
                        child: Text("DIST US")),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: StreamBuilder<String>(
                              stream: socket.distg,
                              initialData: "",
                              builder:
                                  (BuildContext c, AsyncSnapshot<String> data) {
                                return Center(child: Text(data.data));
                              }),
                        ),
                        Expanded(
                          child: StreamBuilder<String>(
                              stream: socket.distc,
                              initialData: "",
                              builder:
                                  (BuildContext c, AsyncSnapshot<String> data) {
                                return Center(child: Text(data.data));
                              }),
                        ),
                        Expanded(
                          child: StreamBuilder<String>(
                              stream: socket.distd,
                              initialData: "",
                              builder:
                                  (BuildContext c, AsyncSnapshot<String> data) {
                                return Center(child: Text(data.data));
                              }),
                        )
                      ],
                    ),
                    RaisedButton(
                        onPressed: () {
                          print("BOUSSOLE");
                          socket.write("BOUSSOLE");
                        },
                        child: Text("BOUSSOLE")),
                    Center(
                      child: StreamBuilder<String>(
                          stream: socket.boussole,
                          initialData: "",
                          builder:
                              (BuildContext c, AsyncSnapshot<String> data) {
                            return Center(child: Text(data.data));
                          }),
                    ),
                    Center(
                      child: RaisedButton(
                          onPressed: () {
                            print("NBSAT_GPS");
                            socket.write("NBSAT_GPS");
                          },
                          child: Column(
                            children: <Widget>[
                              Text("NBSAT_GPS"),
                              StreamBuilder<String>(
                                  stream: socket.nbsat,
                                  initialData: "0",
                                  builder: (BuildContext c,
                                      AsyncSnapshot<String> data) {
                                    return Center(child: Text(data.data));
                                  }),
                            ],
                          )),
                    ),
                    Center(
                      child: RaisedButton(
                          onPressed: () {
                            socket.close();
                            Navigator.pop(context);
                          },
                          child: Icon(FontAwesomeIcons.signOutAlt)),
                    ),
                    Center(
                      child: RaisedButton(
                          onPressed: () {
                            setState(() {
                              imagerobot =
                                  "https://img.aws.la-croix.com/2016/03/29/1200749667/Des-ingenieurs-Nasa-posent-avec-differents-modeles-rovers-envoyes-Mars_0_1400_606.jpg";
                            });
                          },
                          child: Icon(FontAwesomeIcons.signOutAlt)),
                    )
                  ],
                ),
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
