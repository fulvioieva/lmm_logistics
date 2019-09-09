import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lmm_logistics/main.dart';
import 'package:lmm_logistics/screens/home/pages/changePasswordPage.dart';
import 'package:lmm_logistics/screens/login/loginPage.dart';
import 'package:lmm_logistics/screens/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './pages/time_screen.dart';
import './pages/adduser_screen.dart';
import './pages/resume_screen.dart';
import './pages/box_screen.dart';
import './insertdate.dart';
import 'package:lmm_logistics/utils/globals.dart' as globals;
import 'package:lmm_logistics/data/database_helper.dart';
import 'package:lmm_logistics/auth.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  String data;
  var db = new DatabaseHelper();
  AuthStateProvider authStateProvider = new AuthStateProvider();

  TabController tabController;

  @override
  void initState() {
    tabController = new TabController(
      vsync: this,
      initialIndex: 0,
      length: 4,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //var now = new DateTime.now();
    //var formatter = new DateFormat('EEE dd-MM-yyyy');
    //String formatted = formatter.format(now);

    if (globals.dataLavori == null) {
      var now = new DateTime.now();
      now.month < 10
          ? now.day < 10
              ? data = "0${now.year}-0${now.month}-${now.day}"
              : data = "${now.year}-0${now.month}-${now.day}"
          : now.day < 10
              ? data = "0${now.year}-${now.month}-${now.day}"
              : data = "${now.year}-${now.month}-${now.day}";
      var formatter = new DateFormat('MM');
      String mese = formatter.format(now);
      formatter = new DateFormat('yyyy');
      String anno = formatter.format(now);
      formatter = new DateFormat('dd');
      String giorno = formatter.format(now); //'2019-04-23';
      //data = anno + '-' + mese + '-' + giorno;
      globals.dataLavori = anno + '/' + mese + '/' + giorno;
    } else {
      var x = globals.dataLavori.split('/');
      int.parse(x[0]) < 10
          ? int.parse(x[1]) < 10
              ? data = "0${x[1]}-0${x[0]}-${x[2]}"
              : data = "${x[1]}-0${x[0]}-${x[2]}"
          : int.parse(x[1]) < 10
              ? data = "0${x[1]}-${x[0]}-${x[2]}"
              : data = "${x[1]}-${x[0]}-${x[2]}";
      //data = x[1] + '-' + x[0] + '-' + x[2]; //'2019-04-23';
    }
    return MaterialApp(
      theme: new ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.green,
        //Changing this will change the color of the TabBar
        accentColor: Colors.greenAccent,
      ),
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          drawer: Drawer(
            // Add a ListView to the drawer. This ensures the user can scroll
            // through the options in the Drawer if there isn't enough vertical
            // space to fit everything.
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text('Impostazioni',
                      style: TextStyle(color: Colors.white, fontSize: 30.0)),
                  decoration: BoxDecoration(
                    color: Colors.green,
                  ),
                ),
                ListTile(
                  leading: new Icon(Icons.date_range),
                  title: Text('Cambia data',
                      style: TextStyle(color: Colors.green, fontSize: 24.0)),
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => InsertDate()));
                  },
                ),
                ListTile(
                  leading: new Icon(Icons.security),
                  title: Text('Cambia password',
                      style: TextStyle(color: Colors.green, fontSize: 24.0)),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangePassword()));
                  },
                ),
                ListTile(
                  leading: new Icon(Icons.exit_to_app),
                  title: Text('Cambia utente',
                      style: TextStyle(color: Colors.green, fontSize: 24.0)),
                  onTap: () {
                    logout();
                  },
                ),
                /*ListTile(
                  title: Text('Item 2'),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),*/
              ],
            ),
          ),
          appBar: AppBar(
            bottom: TabBar(
              controller: tabController,
              tabs: [
                Tab(icon: Icon(Icons.access_time)),
                Tab(icon: Icon(Icons.transfer_within_a_station)),
                Tab(icon: Icon(Icons.border_color)),
                Tab(icon: Icon(Icons.date_range)),
              ],
            ),
            backgroundColor: (Colors.green),
            title: Text(data),
          ),
          body: TabBarView(
            controller: tabController,
            children: [
              TimeScreen(
                  title: "Risorse presenti su \nSito - " + globals.siteName),
              AddUserScreen(tabController: tabController),
              BoxScreen(tabController: tabController),
              ResumeScreen(tabController: tabController),
            ],
          ),
        ),
      ),
    );
  }

  void logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.clear();
      db.deleteUsers();
      globals.id_daily_job = 0;
      globals.userId = 0;
      globals.siteId = 0;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
    });
  }
}
