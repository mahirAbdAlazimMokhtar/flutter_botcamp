import 'package:flutter/material.dart';

class BMIRESULT extends StatelessWidget {
   final int result;
   final bool isMale;
   final int age;
  BMIRESULT({required this.result,required this.isMale, required this.age});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI RESULT'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Gender : ${isMale ? 'Male' : 'Female'}',
              style:const  TextStyle(fontWeight: FontWeight.bold,fontSize:25),
            ),
            Text(
              'Result : ${result}',
              style:const TextStyle(fontWeight: FontWeight.bold,fontSize:25),
            ),
            Text(
              'Age : ${age}',
              style:const TextStyle(fontWeight: FontWeight.bold,fontSize:25),
            ),
          ],
        ),
      ),
    );
  }
}
