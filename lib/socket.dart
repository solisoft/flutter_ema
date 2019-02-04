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

  // Batterie
  BehaviorSubject<num> _volt = BehaviorSubject<num>();
  Stream<num> get volt => _volt.stream;

  // Position GPS
  BehaviorSubject<String> _long = BehaviorSubject<String>();
  Stream<String> get long => _long.stream;

  BehaviorSubject<String> _lat = BehaviorSubject<String>();
  Stream<String> get lat => _lat.stream;

  // Connexion
  BehaviorSubject<bool> _connected = BehaviorSubject<bool>();
  Stream<bool> get isConnected => _connected.stream;

  // Distance Ulta Son
  BehaviorSubject<String> _distg = BehaviorSubject<String>();
  Stream<String> get distg => _distg.stream;
  BehaviorSubject<String> _distc = BehaviorSubject<String>();
  Stream<String> get distc => _distc.stream;
  BehaviorSubject<String> _distd = BehaviorSubject<String>();
  Stream<String> get distd => _distd.stream;

  // Boussole
  BehaviorSubject<String> _boussole = BehaviorSubject<String>();
  Stream<String> get boussole => _boussole.stream;

  RobotSocket();

  void close() {
    socket.close();
  }

  void connect(host, port) {
    _volt.add(0);
    _long.add("");
    _lat.add("");
    _distg.add("");
    _distc.add("");
    _distd.add("");
    _boussole.add("");
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

    if (message.contains("ETAT_BATT")) {
      _volt.add(num.parse(message.split(" ")[1]));
    }

    if (message.contains("BOUSSOLE")) {
      _boussole.add(message.split(" ")[1]);
    }

    if (message.contains("POS_GPS")) {
      _long.add(message.split(" ")[1]);
      _lat.add(message.split(" ")[2]);
    }
    if (message.contains("DIST_US")) {
      _distg.add(message.split(" ")[1]);
      _distc.add(message.split(" ")[2]);
      _distd.add(message.split(" ")[3]);
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
