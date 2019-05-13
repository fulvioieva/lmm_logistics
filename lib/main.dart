import 'package:flutter/material.dart';
import 'package:lmm_logistics/routes.dart';

void main() => runApp(new LoginApp());

class LoginApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'LMM Logistics',
      theme: new ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.green, //Changing this will change the color of the TabBar
        accentColor: Colors.greenAccent,
      ),

      routes: routes,
    );
  }


}