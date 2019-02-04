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
  var textIPController = new TextEditingController(text: "127.0.0.1");
  var textPortController = new TextEditingController(text: "8888");

  void _goToControlPage() {
    socket.connect(textIPController.text, int.parse(textPortController.text));
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
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the Drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Drawer Header'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('Item 1'),
                onTap: () {
                  // Update the state of the app
                  // ...
                },
              ),
              ListTile(
                title: Text('Item 2'),
                onTap: () {
                  // Update the state of the app
                  // ...
                },
              ),
            ],
          ),
        ),
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
                            TextField(
                              controller: textIPController,
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Text("Port"),
                            TextField(
                              controller: textPortController,
                            )
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
