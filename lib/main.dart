import 'dart:ffi';
import 'dart:math';

import 'package:botcamp_flutter_challenge/bmi_result_screen.dart';
import 'package:botcamp_flutter_challenge/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(BmiScreen());
}

class BmiScreen extends StatefulWidget {
  const BmiScreen({Key? key}) : super(key: key);

  @override
  _BmiScreenState createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen()
      ,
    );
  }
}
