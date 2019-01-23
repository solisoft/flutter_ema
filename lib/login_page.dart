import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'control_page.dart';

import 'socket.dart';

var socket = new RobotSocket();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String ip = "";
  int port = 0;

  void _goToControlPage() {
    socket.connect(ip, port);
    _goToControlPageNoConnect();
  }

  void _goToControlPageNoConnect() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ControlPage(socket: socket)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Robot TCP Login'),
        ),
        body: StreamBuilder<bool>(
            stream: socket.isConnected,
            initialData: false,
            builder: (BuildContext c, AsyncSnapshot<bool> data) {
              if (!data.data)
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text("IP"),
                            TextField(onChanged: (text) {
                              ip = text;
                            }),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text("Port"),
                            TextField(onChanged: (text) {
                              port = int.parse(text);
                            }),
                          ],
                        ),
                      ),
                      RaisedButton(
                          child: Icon(FontAwesomeIcons.signInAlt),
                          onPressed: _goToControlPage)
                    ],
                  ),
                );
              else
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(child: Text("Already Connected")),
                    Center(
                      child: RaisedButton(
                          child: Icon(FontAwesomeIcons.signInAlt),
                          onPressed: _goToControlPageNoConnect),
                    )
                  ],
                );
            }));
  }
}
