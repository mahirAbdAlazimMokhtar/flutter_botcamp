import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'layout/home_layout.dart';

void main() {
  runApp(const BmiScreen());
}

class BmiScreen extends StatefulWidget {
  const BmiScreen({Key? key}) : super(key: key);

  @override
  _BmiScreenState createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}
