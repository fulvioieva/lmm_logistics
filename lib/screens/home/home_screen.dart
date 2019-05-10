import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './pages/time_screen.dart';
import './pages/adduser_screen.dart';
import './pages/box_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var now = new DateTime.now();
    var formatter = new DateFormat('EEE dd-MM-yyyy');
    String formatted = formatter.format(now);

    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.access_time)),
                Tab(icon: Icon(Icons.transfer_within_a_station)),
                Tab(icon: Icon(Icons.border_color)),
              ],
            ),
            title: Text(formatted),
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
