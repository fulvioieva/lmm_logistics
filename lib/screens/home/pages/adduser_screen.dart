import 'package:flutter/material.dart';
import 'package:lmm_logistics/models/workers.dart';
import 'package:flutter/scheduler.dart';
import 'package:lmm_logistics/data/rest_ds.dart';
import 'package:lmm_logistics/utils/globals.dart' as globals;
import 'package:lmm_logistics/screens/home/home_screen.dart';

class AddUserScreen extends StatefulWidget {
  @override
  _AddUserScreen createState() {
    return new _AddUserScreen();
  }
}

class _AddUserScreen extends State<AddUserScreen> {

  static final TextEditingController nome = TextEditingController();
  static final TextEditingController cognome = TextEditingController();


  List<Workers> _interinali= [];

  RestDatasource api = new RestDatasource();

  void initState() {
    super.initState();
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        fetchInterinali();
      });
    }
  }
  void refresh(){
    setState(() {});
  }

  void _deleteInterinali(int id) async {
    api.removeInterinali(id);
    _interinali = await api.fetchInterinali(globals.id_daily_job).whenComplete(refresh);
  }

  void fetchInterinali() async {
    _interinali = await api.fetchInterinali(globals.id_daily_job).whenComplete(refresh);
  }

  void _addInterinali() async {
    if(nome.text!="" && cognome.text!="" ) {
      api.setInterinali(nome.text, cognome.text, globals.id_daily_job);
      _interinali =
      await api.fetchInterinali(globals.id_daily_job).whenComplete(refresh);;
      nome.text = "";
      cognome.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inserimento Utenti'),
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
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: nome,
                          //onSaved: (val) => nome = val,
                          decoration: InputDecoration(labelText: 'Nome'),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: cognome,
                          //onSaved: (val) => cognome = val,
                          decoration:
                              InputDecoration(labelText: 'Cognome'),
                        ),
                      ),
                    ),
                  ],
                ), // row
                Row(children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(20.0),

                    child: RaisedButton(
                      child: Text("Inserisci utente"),
                      onPressed: () {
                        _addInterinali();
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
              ],
            ), // column
            Column(
              children: _interinali
                  .map((element) => Card(
                child: new Container(
                    color: Colors.grey,
                    padding: new EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 0.0),
                    //width: 200.0,
                    child: new Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          new MaterialButton(
                            height: 40.0,
                            child: new Column(
                              children: <Widget>[
                                new Icon(Icons.person,
                                    size: 30.0),
                                new Text(element.last_name),
                              ],
                            ),
                            onPressed: null,
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                  element.first_name ,
                                  style: new TextStyle(
                                      fontSize: 22.0,
                                      color: Colors.white)),
                            ],
                          ),
                          new MaterialButton(
                            height: 40.0,
                            child: new Column(
                              children: <Widget>[
                                new Icon(Icons.remove_circle_outline,
                                    size: 30.0)
                              ],
                            ),
                            onPressed: () {
                              _deleteInterinali(element.id);
                            },
                          ),
                        ])),
              ))
                  .toList(),
            )
          ],
        ), // ListView
      ),
    );
  }
}
