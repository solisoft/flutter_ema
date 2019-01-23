import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'dart:io';

class RobotSocket {
  Socket socket;

  String port = '';
  String ip = '';

  // Raw message
  BehaviorSubject<String> _receiveMsg = BehaviorSubject<String>();
  Stream<String> get data => _receiveMsg.stream;

  // Capteurs
  BehaviorSubject<bool> _avg = BehaviorSubject<bool>();
  Stream<bool> get avg => _avg.stream;
  BehaviorSubject<bool> _avd = BehaviorSubject<bool>();
  Stream<bool> get avd => _avd.stream;
  BehaviorSubject<bool> _arg = BehaviorSubject<bool>();
  Stream<bool> get arg => _arg.stream;
  BehaviorSubject<bool> _ard = BehaviorSubject<bool>();
  Stream<bool> get ard => _ard.stream;

  // Connexion
  BehaviorSubject<bool> _connected = BehaviorSubject<bool>();
  Stream<bool> get isConnected => _connected.stream;

  RobotSocket();

  void close() {
    socket.close();
  }

  void connect(host, port) {
    _avg.add(false);
    _avd.add(false);
    _arg.add(false);
    _ard.add(false);

    Socket.connect(host, port).then((Socket sock) {
      socket = sock;
      socket.listen(dataHandler,
          onError: errorHandler, onDone: doneHandler, cancelOnError: false);
      _receiveMsg.add("Connected");
      _connected.add(true);
    }).catchError((AsyncError e) {
      print("Unable to connect: $e");
    });
  }

  void write(command) {
    socket.write(command + "\n");
  }

  void dataHandler(data) {
    String message = new String.fromCharCodes(data).trim();
    _receiveMsg.add(message);
    if (message.contains("DETECT")) {
      _avg.add(false);
      _avd.add(false);
      _arg.add(false);
      _ard.add(false);
      message.split(" ").forEach((command) {
        if (command == "AVG") _avg.add(true);
        if (command == "AVD") _avd.add(true);
        if (command == "ARG") _arg.add(true);
        if (command == "ARD") _ard.add(true);
      });
    }
  }

  void errorHandler(error, StackTrace trace) {}

  void doneHandler() {
    socket.destroy();
    _connected.add(false);
    _avg.add(false);
    _avd.add(false);
    _arg.add(false);
    _ard.add(false);
    _receiveMsg.add("");
  }
}
