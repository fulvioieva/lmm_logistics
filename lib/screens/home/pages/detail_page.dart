import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
//import 'package:lmm_logistics/datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:lmm_logistics/models/workers.dart';
import 'package:lmm_logistics/models/pause.dart';
import 'package:lmm_logistics/data/rest_ds.dart';
import 'package:lmm_logistics/screens/home/pages/data/PickerData.dart';
import 'package:flutter/scheduler.dart';
import 'package:lmm_logistics/screens/home/home_screen.dart';
import 'package:lmm_logistics/flutter_picker/flutter_picker.dart';
import 'package:lmm_logistics/utils/globals.dart' as globals;

class DetailPage extends StatefulWidget {
  final Workers workers;

  DetailPage({Key key, this.workers}) : super(key: key);

  @override
  _DetailPage createState() => _DetailPage();
}

DateTime convertDateFromString(String strDate) {
  if (strDate == null) return DateTime.now();
  DateTime todayDate = DateTime.parse(strDate);
  return todayDate;
}

class _DetailPage extends State<DetailPage> {

  // Show some different formats.
  /*
  final formats = {
    InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
    InputType.date: DateFormat('yyyy-MM-dd'),
    InputType.time: DateFormat("HH:mm"),
  };
  */
  RestDatasource api = new RestDatasource();

  // Changeable in demo
  //InputType inputType = InputType.time;
  bool editable = false;
  String date_entrata='';
  String date_uscita='';
  List<Pause> _pause = [];

  String descrizione = 'Generica';
  int _radioValue1 = 15;

  void initState() {
    super.initState();
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        fetchPause();
      });
    }
  }

  showPickerArrayIn(BuildContext context) {
    Picker(
        adapter: PickerDataAdapter<String>(
          pickerdata: JsonDecoder().convert(PickerData),
          isArray: true,
        ),
        hideHeader: true,
        selecteds: [0, 0],
        title: Text("Ora inizio lavori"),
        onConfirm: (Picker picker, List value) {
          //print(value.toString());
          //print(picker.getSelectedValues());
          setState(() {
            date_entrata = ' ' + picker.getSelectedValues()[0].toString() +':'+ picker.getSelectedValues()[1] ;
            api.setDataIn(widget.workers.work_id, date_entrata);
          });

        }
    ).showDialog(context);
  }  showPickerArrayOut(BuildContext context) {
    Picker(
        adapter: PickerDataAdapter<String>(
          pickerdata: JsonDecoder().convert(PickerData),
          isArray: true,
        ),
        hideHeader: true,
        selecteds: [0, 0],
        title: Text("Ora fine lavori"),

        onConfirm: (Picker picker, List value) {
          //print(value.toString());
          //print(picker.getSelectedValues());
          setState(() {
            date_uscita = ' ' + picker.getSelectedValues()[0].toString() +':'+ picker.getSelectedValues()[1] ;
            api.setDataOut(widget.workers.work_id, date_uscita);
          });
        }
    ).showDialog(context);
  }


  void refresh(){
    setState(() {});
  }

  void _deletePause(int id) async {
    api.removePause(id);
    _pause = await api.fetchPause(widget.workers.id_daily_job, widget.workers.id).whenComplete(refresh);
  }

  void fetchPause() async {
    _pause = await api.fetchPause(widget.workers.id_daily_job, widget.workers.id).whenComplete(refresh);
  }

  void _addPause(String description, int durata) async {
    api.setPause(widget.workers.id_daily_job, description, durata, widget.workers.id);
    _pause = await api.fetchPause(widget.workers.id_daily_job, widget.workers.id).whenComplete(refresh);
  }

  Future<String> _asyncInputDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Inserimento pause'),
          content: Column(children: <Widget>[
            Text(
              'Durata:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(_radioValue1.toString()),
                DropdownButton<String>(
                  items: <String>['15', '30', '45'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String value) {
                    setState(() {
                      _radioValue1 = int.parse(value);
                    });
                  },
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: 'Inserisci motivo', hintText: 'es. Pranzo'),
                  onChanged: (value) {
                    descrizione = value;
                  },
                ))
              ],
            ),
            Divider(height: 1.0, color: Colors.grey),
            Padding(
              padding: EdgeInsets.all(4.0),
            ),
          ]),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                _addPause(descrizione, _radioValue1);
                Navigator.of(context).pop(descrizione);
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(descrizione);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(widget.workers.last_name +' '+ widget.workers.first_name)),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[SizedBox(height: 10.0),
              RaisedButton(
                child: Text('Data inizio lavori'),
                onPressed: () {
                  showPickerArrayIn(context);
                },
              ),widget.workers.date_start != null ? Text(widget.workers.date_start.substring(10,16)) : Container(),
              SizedBox(height: 10.0),
              RaisedButton(
                child: Text('Data fine lavori'),
                onPressed: () {
                  showPickerArrayOut(context);
                },
              ),widget.workers.date_end != null ? Text(widget.workers.date_end.substring(10,16)) : Container(),
              /*
              DateTimePickerFormField(
                inputType: inputType,
                format: formats[inputType],
                editable: editable,
                initialValue: convertDateFromString(widget.workers.date_start),
                decoration: InputDecoration(
                    labelText: 'Ora entrata', hasFloatingPlaceholder: false),
                onChanged: (dt) => setState(() {
                      date_entrata = dt;
                      api.setDataIn(widget.workers.work_id, date_entrata);
                    }),
              ),*/
              //Text('ora inizio turno'),
              /*
              DateTimePickerFormField(
                inputType: inputType,
                format: formats[inputType],
                editable: editable,
                initialValue: convertDateFromString(widget.workers.date_end),
                decoration: InputDecoration(
                    labelText: 'Ora entrata', hasFloatingPlaceholder: false),
                onChanged: (dt) => setState(() {
                      date_uscita = dt;
                      api.setDataOut(widget.workers.work_id, date_uscita);
                    }),
              ),*/
              //Text('ora fine turno'),
              SizedBox(height: 50.0),
              Row(children: <Widget>[
                Container(
                  margin: EdgeInsets.all(20.0),

                  child: RaisedButton(
                    child: Text("Inserisci Pausa"),
                    onPressed: () {
                      _asyncInputDialog(context);
                    },
                    color: Colors.green,
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    splashColor: Colors.grey,

                  ),

                ),
                Expanded(
                  child: RaisedButton(
                    child: Text("Conferma"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    },
                    color: Colors.green,
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    splashColor: Colors.grey,

                  ),
                ),
              ]),


              Column(
                children: _pause
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
                                          new Icon(Icons.hourglass_empty,
                                              size: 30.0),
                                          new Text(element.descrizione),
                                        ],
                                      ),
                                      onPressed: null,
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Text(
                                            element.durata.toString() + ' min.',
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
                                        _deletePause(element.id);
                                      },
                                    ),
                                  ])),
                        ))
                    .toList(),
              )
            ],
          ),
        ),
      );
}
