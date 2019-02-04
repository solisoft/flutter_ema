import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  String imagerobot = "https://picsum.photos/600/300";
  String oldimagerobot = "https://picsum.photos/600/300";

  void runTimer() {
    Timer timer = new Timer(new Duration(seconds: 3), () {
      setState(() {
        oldimagerobot = "https://picsum.photos/600/300?" + date;
        date = DateTime.now().toIso8601String();
        imagerobot = "https://picsum.photos/600/300?" + date;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
              /*decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: new NetworkImage(imagerobot), fit: BoxFit.cover),
              ),*/
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: <Widget>[
                    new FadeInImage(
                      placeholder: NetworkImage(oldimagerobot),
                      image: NetworkImage(imagerobot),
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
                            return Text(data.data);
                          }),
                    ),
                    Center(
                      child: StreamBuilder<String>(
                          stream: socket.lat,
                          initialData: "",
                          builder:
                              (BuildContext c, AsyncSnapshot<String> data) {
                            return Text(data.data);
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
