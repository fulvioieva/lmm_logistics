import 'package:flutter/material.dart';
import 'package:lmm_logistics/data/rest_ds.dart';
import 'package:lmm_logistics/utils/globals.dart' as globals;
import 'package:lmm_logistics/screens/home/home_screen.dart';

class ResumeScreen extends StatefulWidget {
  @override
  _ResumeScreen createState() {
    return new _ResumeScreen();
  }
}

class _ResumeScreen extends State<ResumeScreen> {

  RestDatasource api = new RestDatasource();

  void initState() {

  }
  void refresh(){

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RESOCONTO'),
        backgroundColor: (Colors.green),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(height: 0.0),
                    Text('Totale colli lavorati'),
                    Text('Totale ore economia'),
                  ],
                ), // row
                Row(children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(20.0),

                    child: RaisedButton(
                      child: Text("Conferma finale"),
                      onPressed: () {

                      },
                      color: Colors.green,
                      textColor: Colors.white,
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      splashColor: Colors.grey,

                    ),

                  ),
                  Expanded(
                    child: RaisedButton(
                      child: Text("Ritorna"),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => HomeScreen()));

                      },
                      color: Colors.green,
                      textColor: Colors.white,
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      splashColor: Colors.grey,

                    ),
                  ),
                ]),
              ],
            ), // column
          ],
        ), // ListView
      ),
    );
  }
}
