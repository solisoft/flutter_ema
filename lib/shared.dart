import 'package:rxdart/rxdart.dart';
import 'dart:async';

class SharedObject {
  // Speed
  BehaviorSubject<int> _speed = BehaviorSubject<int>();
  Stream<int> get speed => _speed.stream;

  SharedObject();

  void setSpeed(int value) {
    _speed.add(value);
  }
}
