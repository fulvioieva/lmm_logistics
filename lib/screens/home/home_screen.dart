import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './pages/time_screen.dart';
import './pages/adduser_screen.dart';
import './pages/box_screen.dart';
import './insertdate.dart';
import 'package:lmm_logistics/utils/globals.dart' as globals;

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //var now = new DateTime.now();
    //var formatter = new DateFormat('EEE dd-MM-yyyy');
    //String formatted = formatter.format(now);
    var x = globals.dataLavori.split('/');
    String data = x[1] + '-' + x[0] + '-' + x[2]; //'2019-04-23';

    return MaterialApp(
      theme: new ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.green, //Changing this will change the color of the TabBar
        accentColor: Colors.greenAccent,
      ),

      home: DefaultTabController(
        length: 3,
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
                  child: Text('Configurazione',
                      style: TextStyle(color: Colors.black, fontSize: 30.0)),
                  decoration: BoxDecoration(
                    color: Colors.green ,
                  ),
                ),
                ListTile(
                  leading: new Icon(Icons.date_range),
                  title: Text('Cambia data',
                      style: TextStyle(color: Colors.green, fontSize: 30.0)),
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => InsertDate()));
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
              tabs: [
                Tab(icon: Icon(Icons.access_time)),
                Tab(icon: Icon(Icons.transfer_within_a_station)),
                Tab(icon: Icon(Icons.border_color)),
              ],
            ),
            backgroundColor: (Colors.green),
            title: Text(data),
          ),
          body: TabBarView(
            children: [
              TimeScreen(title: "Risorse presenti"),
              AddUserScreen(),
              BoxScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
