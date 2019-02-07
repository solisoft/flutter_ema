import 'package:flutter/material.dart';
import 'scratch_page.dart';
import 'landscape_page.dart';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: LandscapePage(),
  ));
}
