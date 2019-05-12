import 'package:flutter/material.dart';
import 'package:lmm_logistics/screens/home/home_screen.dart';
import 'package:lmm_logistics/screens/home/insertdate.dart';
import 'package:lmm_logistics/screens/login/login_screen.dart';

final routes = {
  '/login':         (BuildContext context) => new LoginScreen(),
  '/home':         (BuildContext context) => new HomeScreen(),
  '/insertdate':         (BuildContext context) => new InsertDate(),
  '/' :          (BuildContext context) => new LoginScreen(),
};