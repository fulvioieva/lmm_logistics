import 'package:flutter/material.dart';
import 'package:lmm_logistics/screens/home/home_screen.dart';
import 'package:lmm_logistics/screens/home/insertdate.dart';
import 'package:lmm_logistics/screens/login/loginPage.dart';

final routes = {
  '/login':        (BuildContext context) => new LoginPage(),
  '/home':         (BuildContext context) => new HomeScreen(),
  '/insertdate':   (BuildContext context) => new InsertDate(),
  '/' :            (BuildContext context) => new LoginPage(),
};