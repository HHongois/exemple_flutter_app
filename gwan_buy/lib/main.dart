import 'package:flutter/material.dart';
import 'package:gwan_buy/widget/home_controller.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
      ),
      home: HomeController(title: 'Gwan buy'),
    );
  }
}
