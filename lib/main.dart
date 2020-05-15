import 'package:flutter/material.dart';
import 'package:calculatorapp/outlineCalculation.dart';
import 'package:flutter/services.dart';

void main() {
  //String equation = '';
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(buttonColor: Colors.red),
      home: Scaffold(
        body: Calculator(),
      ),
    );
  }
}
