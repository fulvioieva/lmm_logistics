import 'package:flutter/material.dart';
import 'package:lmm_logistics/models/working_user.dart';
import 'package:flutter/scheduler.dart';
import 'package:lmm_logistics/data/rest_ds.dart';
import 'package:lmm_logistics/utils/globals.dart' as globals;
import 'package:lmm_logistics/screens/home/home_screen.dart';
import 'package:lmm_logistics/screens/home/pages/time_screen.dart';
import 'dart:convert';

class AddUserScreen extends StatefulWidget {
  @override
  _AddUserScreen createState() {
    return new _AddUserScreen();
  }
}

class _AddUserScreen extends State<AddUserScreen> {
  List<WorkingUsers> _wkusers = [];
  WorkingUsers selectedWorker;

  RestDatasource api = new RestDatasource();

  void initState() {
    super.initState();
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {});
    }
    fetchUsers();
  }

  void fetchUsers() async {
    _wkusers = await api.getUserAgenzia(globals.id_daily_job).whenComplete(refresh);
  }

  void refresh() {
    if (this.mounted) {
      setState(() {

      });
    }
  }

  void adduser(int id_user) {
    if(globals.id_daily_job>0 || id_user==null) {
      api.setDailyJob(globals.id_daily_job, id_user);
    }
        Navigator.push(context,
        MaterialPageRoute(builder: (context) => TimeScreen(title: "Risorse presenti"),));
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Gestione utenti'),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Dropper(),
            Column(children: <Widget>[
              Row(children: <Widget>[
                Container(
                  margin: EdgeInsets.all(20.0),
                  child: RaisedButton(
                    child: Text("Aggiungi utente"),
                    onPressed: () {
                      if (selectedWorker!=null )adduser(selectedWorker.id);
                    },
                    color: Colors.green,
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    splashColor: Colors.grey,
                  ),
                ),
                Expanded(
                  child: RaisedButton(
                    child: Text("Indietro"),
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
            ])
          ],
        ),
      ),
    );
  }

  Widget Dropper() {
    return Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(5.0),
        decoration:
            new BoxDecoration(border: new Border.all(color: Colors.lightGreen)),
        child: Row(children: <Widget>[
          new Icon(Icons.people),
          SizedBox(width: 40.0),
          DropdownButtonHideUnderline(
            child: new DropdownButton<WorkingUsers>(
              hint: new Text("Seleziona risorsa"),
              value: selectedWorker,
              isDense: true,
              onChanged: (WorkingUsers newValue) {
                setState(() {
                  selectedWorker = newValue;
                });
                //print(selectedWorker.id);
              },
              items: _wkusers.map((WorkingUsers map) {
                return new DropdownMenuItem<WorkingUsers>(
                  value: map,
                  child: new Text((map.getDescription()),
                      style: new TextStyle(color: Colors.black)),
                );
              }).toList(),
            ),
          ), // end drop

        ]));
  }
}
