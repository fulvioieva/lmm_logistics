import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:lmm_logistics/models/workers.dart';
import 'package:lmm_logistics/models/pause.dart';
import 'package:lmm_logistics/models/economia.dart';
import 'package:lmm_logistics/data/rest_ds.dart';
import 'package:lmm_logistics/screens/home/pages/data/PickerData.dart';
import 'package:flutter/scheduler.dart';
import 'package:lmm_logistics/screens/home/home_screen.dart';
import 'package:lmm_logistics/flutter_picker/flutter_picker.dart';
import 'package:flash/flash.dart';

enum ConfirmAction { CANCEL, ACCEPT }

RestDatasource api = new RestDatasource();
bool editable = false;
String _dataEntrata, _dataUscita, _dataEntrataEconomia, _dataUscitaEconomia;
List<Pause> _pause = [];
Economia _economia;
String descrizione = 'Generica';
bool loaded;

class DetailPage extends StatefulWidget {
  final Workers workers;

  DetailPage({Key key, this.workers}) : super(key: key);

  @override
  _DetailPage createState() => _DetailPage(this.workers);
}

DateTime convertDateFromString(String strDate) {
  if (strDate == null) return DateTime.now();
  DateTime todayDate = DateTime.parse(strDate);
  return todayDate;
}

class _DetailPage extends State<DetailPage> {
  Workers workers;
  _DetailPage(this.workers);
  void initState() {
    loaded = true;
    _dataEntrata =
        _dataEntrataEconomia = _dataUscita = _dataUscitaEconomia = "";
    super.initState();
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        awaitAPI();
      });
    }
  }

  void startedStrings() {
    widget.workers.dateStart == null
        ? _dataEntrata = ""
        : _dataEntrata = widget.workers.dateStart.substring(10, 16);
    widget.workers.dateEnd == null
        ? _dataUscita = ""
        : _dataUscita = widget.workers.dateEnd.substring(10, 16);
    _economia.dataInizio == null
        ? _dataEntrataEconomia = ""
        : _dataEntrataEconomia = _economia.dataInizio.substring(10, 16);
    _economia.dataFine == null
        ? _dataUscitaEconomia = ""
        : _dataUscitaEconomia = _economia.dataFine.substring(10, 16);
  }

  void setDataIn(int id, String entrata) async {
    api.setDataIn(id, entrata).whenComplete(refresh);
  }

  void setDataOut(int id, String uscita) async {
    api.setDataOut(id, uscita).whenComplete(refresh);
  }

  void setDataInEconomia(int idDailyJob, String entrata) async {
    api
        .setEconomia(entrata, null, idDailyJob, widget.workers.id)
        .whenComplete(refresh);
  }

  void setDataOutEconomia(int idDailyJob, String uscita) async {
    api
        .setEconomia(null, uscita, idDailyJob, widget.workers.id)
        .whenComplete(refresh);
  }

  void refresh() {
    if (this.mounted) {
      this.setState(() {});
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
            _dataEntrata = ' ' +
                picker.getSelectedValues()[0].toString() +
                ':' +
                picker.getSelectedValues()[1];
            setDataIn(widget.workers.workId, _dataEntrata);
          });
        }).showDialog(context);
  }

  showPickerArrayOut(BuildContext context) {
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
            _dataUscita = ' ' +
                picker.getSelectedValues()[0].toString() +
                ':' +
                picker.getSelectedValues()[1];
            setDataOut(widget.workers.workId, _dataUscita);
          });
        }).showDialog(context);
  }

  showPickerEconomiaIn(BuildContext context) {
    Picker(
        adapter: PickerDataAdapter<String>(
          pickerdata: JsonDecoder().convert(PickerData),
          isArray: true,
        ),
        hideHeader: true,
        selecteds: [0, 0],
        title: Text("Ora inizio economia"),
        onConfirm: (Picker picker, List value) {
          //print(value.toString());
          //print(picker.getSelectedValues());
          setState(() {
            _dataEntrataEconomia = ' ' +
                picker.getSelectedValues()[0].toString() +
                ':' +
                picker.getSelectedValues()[1];
            setDataInEconomia(widget.workers.idDailyJob, _dataEntrataEconomia);
          });
        }).showDialog(context);
  }

  showPickerEconomiaOut(BuildContext context) {
    Picker(
        adapter: PickerDataAdapter<String>(
          pickerdata: JsonDecoder().convert(PickerData),
          isArray: true,
        ),
        hideHeader: true,
        selecteds: [0, 0],
        title: Text("Ora fine economia"),
        onConfirm: (Picker picker, List value) {
          //print(value.toString());
          //print(picker.getSelectedValues());
          setState(() {
            _dataUscitaEconomia = ' ' +
                picker.getSelectedValues()[0].toString() +
                ':' +
                picker.getSelectedValues()[1];
            setDataOutEconomia(widget.workers.idDailyJob, _dataUscitaEconomia);
          });
        }).showDialog(context);
  }

  void _resetUtente(int id) async {
    api.resetUtente(id);
    if (this.mounted) {
      setState(() {
        _dataEntrata = ' ';
        _dataUscita = ' ';
      });
    }
  }

  void _resetEconomia() async {
    api.resetEconomia(widget.workers.id, widget.workers.idDailyJob);
    if (this.mounted) {
      setState(() {
        _dataEntrataEconomia = ' ';
        _dataUscitaEconomia = ' ';
      });
    }
  }

  void _deletePause(int id) async {
    api.removePause(id);
    _pause = await api
        .fetchPause(widget.workers.idDailyJob, widget.workers.id)
        .whenComplete(refresh);
  }

  Future fetchPause() async {
    _pause = await api
        .fetchPause(widget.workers.idDailyJob, widget.workers.id)
        .whenComplete(refresh);
  }

  Future fetchEconomia() async {
    _economia = await api
        .getEconomia(widget.workers.idDailyJob, widget.workers.id)
        .whenComplete(refresh);
    if (_economia == null) _economia = new Economia();
  }

  void awaitAPI() async {
    await fetchPause();
    await fetchEconomia();
    setState(() {
      startedStrings();
      loaded = false;
    });
  }

  Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancella ore'),
          content: const Text(
              'In questo modo cancellerai l\'ora di ingresso, uscita ed economia portandole al valore iniziale.'),
          actions: <Widget>[
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: const Text('PROCEDI'),
              onPressed: () {
                _resetUtente(widget.workers.workId);
                setState(() {
                  _dataEntrata = _dataUscita = "";
                });
                if (_economia?.id != null) _resetEconomia();
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            )
          ],
        );
      },
    );
  }

  Future<String> _asyncInputDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      // dialog is dismissible with a tap on the barrier
      builder: (_) {
        return MyDialog(
          workers: widget.workers,
          detailState: this,
        );
        /* 
        return Dialog(
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                _addPause(descrizione, int.parse(_valorePausa));
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
          child: Container(
            child: Column(children: <Widget>[
              Text(
                'Durata',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //Text(_radioValue1.toString()),
                  DropdownButton(
                    hint:
                        Text('Scegli la durata'), // Not necessary for Option 1
                    value: _valorePausa,
                    onChanged: (newValue) {
                      setState(() {
                        _valorePausa = newValue;
                      });
                    },
                    items: _timepause.map((_radioValue1) {
                      return DropdownMenuItem(
                        child: new Text(_radioValue1),
                        value: _radioValue1,
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10.0),
                  /*
                  RaisedButton(
                    child: Text('Orario inizio economia'),
                    onPressed: () {
                      showPickerArray(context);
                      setState(() {

                      });
                    },
                  ),*/
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
          ),
        );
        */
      },
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              setState(() {
                _dataEntrata = _dataEntrataEconomia =
                    _dataUscita = _dataUscitaEconomia = "";
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              });
            },
          ),
          title: Text(widget.workers.lastName + ' ' + widget.workers.firstName),
        ),
        body: loaded
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Column(
                      children: <Widget>[
                        RaisedButton(
                          child: Center(child: Text('Orario inizio lavori')),
                          onPressed: () {
                            showPickerArrayIn(context);
                          },
                        ),
                        Text(_dataEntrata)
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Column(
                      children: <Widget>[
                        RaisedButton(
                          child: Center(child: Text('Orario fine lavori')),
                          onPressed: _dataEntrata.isNotEmpty
                              ? () {
                                  showPickerArrayOut(context);
                                }
                              : null,
                        ),
                        Text(_dataUscita)
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Column(
                      children: <Widget>[
                        RaisedButton(
                          child: Center(child: Text('Orario inizio economia')),
                          onPressed: () {
                            showPickerEconomiaIn(context);
                          },
                        ),
                        Text(_dataEntrataEconomia)
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Column(
                      children: <Widget>[
                        RaisedButton(
                          child: Center(child: Text('Orario fine economia')),
                          onPressed: () {
                            showPickerEconomiaOut(context);
                          },
                        ),
                        Text(_dataUscitaEconomia)
                      ],
                    ),
                  ),

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
                  Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          /*new RawMaterialButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      },
                      child: new Icon(
                        Icons.arrow_back_ios,
                        color: Colors.green,
                        size: 35.0,
                      ),
                      shape: new CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.white,
                      padding: const EdgeInsets.all(15.0),
                    ),*/
                          /*
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
                ),*/
                          new RawMaterialButton(
                            onPressed: () {
                              _dataEntrata.isNotEmpty
                                  ? _asyncInputDialog(context)
                                  : showFlash(
                                      duration: Duration(seconds: 3),
                                      builder: (context, controller) {
                                        return Flash(
                                          controller: controller,
                                          style: FlashStyle.floating,
                                          boxShadows: kElevationToShadow[4],
                                          backgroundColor: Colors.black87,
                                          child: FlashBar(
                                            message: Text(
                                              "Inserire orario di inizio lavoro prima di inserire una pausa!",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        );
                                      },
                                      context: context);
                            },
                            child: new Icon(
                              Icons.hourglass_empty,
                              color: Colors.green,
                              size: 35.0,
                            ),
                            shape: new CircleBorder(),
                            elevation: 5.0,
                            fillColor: Colors.white,
                            padding: const EdgeInsets.all(15.0),
                          ),
                          new RawMaterialButton(
                            onPressed: () {
                              _dataEntrata.isNotEmpty
                                  ? _asyncConfirmDialog(context)
                                  : showFlash(
                                      duration: Duration(seconds: 3),
                                      builder: (context, controller) {
                                        return Flash(
                                          controller: controller,
                                          style: FlashStyle.floating,
                                          boxShadows: kElevationToShadow[4],
                                          backgroundColor: Colors.black87,
                                          child: FlashBar(
                                            message: Text(
                                              "Nessun dato da cancellare!",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        );
                                      },
                                      context: context);
                            },
                            child: new Icon(
                              Icons.restore_from_trash,
                              color: Colors.green,
                              size: 35.0,
                            ),
                            shape: new CircleBorder(),
                            elevation: 5.0,
                            fillColor: Colors.white,
                            padding: const EdgeInsets.all(15.0),
                          ),
                          /*
                Container(
                  margin: EdgeInsets.all(20.0),
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
                ),*/

                          /*
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
                ),*/
                        ]),
                  ),

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
                                                element.durata.toString() +
                                                    ' min.',
                                                style: new TextStyle(
                                                    fontSize: 22.0,
                                                    color: Colors.white)),
                                          ],
                                        ),
                                        new MaterialButton(
                                          height: 40.0,
                                          child: new Column(
                                            children: <Widget>[
                                              new Icon(
                                                  Icons.remove_circle_outline,
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
      );
}

class MyDialog extends StatefulWidget {
  final Workers workers;
  final State detailState;

  MyDialog({Key key, this.workers, this.detailState}) : super(key: key);
  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  String _valorePausa = '15';
  List<String> _timepause = ['15', '30', '45', '60', '120'];
  String descrizione = "Generico";

  void addPause(String description, int durata) async {
    api.setPause(
        widget.workers.idDailyJob, description, durata, widget.workers.id);
    _pause = await api
        .fetchPause(widget.workers.idDailyJob, widget.workers.id)
        .whenComplete(refresh);
  }

  void refresh() {
    widget.detailState.setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 160.0,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                'Durata pausa',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            DropdownButton(
              hint: Text('Scegli la durata'), // Not necessary for Option 1
              value: _valorePausa,
              onChanged: (newValue) {
                setState(() {
                  _valorePausa = newValue;
                });
              },
              items: _timepause.map((_radioValue1) {
                return DropdownMenuItem(
                  child: new Text(_radioValue1),
                  value: _radioValue1,
                );
              }).toList(),
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                  maxLength: 256,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: 'Inserisci motivo', hintText: 'es. Pranzo'),
                  onChanged: (value) {
                    setState(() {
                      descrizione = value;
                    });
                  },
                ))
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FlatButton(
              child: Text('Chiudi'),
              onPressed: () {
                Navigator.of(context).pop(descrizione);
              },
            ),
            FlatButton(
              child: Text('Aggiungi Pausa'),
              onPressed: () {
                addPause(descrizione, int.parse(_valorePausa));
                Navigator.of(context).pop(descrizione);
                refresh();
              },
            )
          ],
        )
      ],
    );
  }
}
