import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:lmm_logistics/screens/home/home_screen.dart';
import 'package:lmm_logistics/utils/globals.dart' as globals;
import 'package:lmm_logistics/models/site.dart';
import 'package:flutter/scheduler.dart';
import 'package:lmm_logistics/data/rest_ds.dart';
import 'package:intl/intl.dart';
import 'dart:async';

enum ConfirmAction { ANNULLA, PROCEDI }

class InsertDate extends StatefulWidget {
  InsertDate({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _InsertDate createState() => new _InsertDate();
}

class _InsertDate extends State<InsertDate> {
  final TextEditingController _controller = new TextEditingController();
  final f = new DateFormat('dd/MM/yyyy');
  RestDatasource api = new RestDatasource();
  String datadefault;
  Site selectedSite;
  List<Site> _wkSite = [];

  void initState() {
    super.initState();
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {});
    }

    var now = new DateTime.now();
    var formatter = new DateFormat('MM');
    String mese = formatter.format(now);
    formatter = new DateFormat('yyyy');
    String anno = formatter.format(now);
    formatter = new DateFormat('dd');
    String giorno = formatter.format(now);
    datadefault = anno + '-' + mese + '-' + giorno;
  }

  void fetchSite() async {
    _wkSite = await api
        .getSitiEvol(globals.userId, datadefault)
        .whenComplete(refresh);
  }

  void refresh() {
    if (this.mounted) {
      setState(() {});
    }
  }

  DateTime convertToDate(String input) {
    try {
      var d = new DateFormat.yMd().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  Future _chooseDate(BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now);

    var result = await showDatePicker(
        context: context,
        locale: const Locale("it", "IT"),
        initialDate: initialDate,
        firstDate: new DateTime(1900),
        lastDate: new DateTime.now());

    if (result == null) return;

    if (this.mounted) {
      setState(() {
        _controller.text = f.format(result);
        globals.dataLavori = new DateFormat.yMd().format(result);
        var x = globals.dataLavori.split('/');
        if (x[0].length == 1) x[0] = '0' + x[0];
        if (x[1].length == 1) x[1] = '0' + x[1];
        datadefault = x[2] + '-' + x[0] + '-' + x[1];
      });
      fetchSite();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Text('Inserimento giorno lavorativo'),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Column(children: <Widget>[
              SizedBox(height: 50.0),
              new Image.asset(
                'assets/intro.jpg',
                fit: BoxFit.contain,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  decoration: new BoxDecoration(
                      border: new Border.all(color: Colors.lightGreen)),
                  child: MaterialButton(
                    onPressed: () {
                      _chooseDate(context, _controller.text);
                    },
                    child: TextField(
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.calendar_today),
                        suffixIcon: Icon(Icons.add_circle),
                        hintText: 'Inserisci il giorno di lavoro',
                        labelText: 'Data gg/mm/aaaa',
                      ),
                      //initialValue: datadefault,
                      controller: _controller,
                      enabled: false,
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                ),
              ),
              /*new Row(children: <Widget>[
                SizedBox(height: 50.0),
                new Expanded(
                    child: new TextFormField(
                  decoration: new InputDecoration(
                    icon: const Icon(Icons.calendar_today),
                    hintText: 'Inserisci il giorno di lavoro',
                    labelText: 'Data gg/mm/aaaa',
                  ),
                  //initialValue: datadefault,
                  controller: _controller,
                  enabled: false,
                  keyboardType: TextInputType.datetime,
                )),
                SizedBox(height: 50.0),
                new IconButton(
                  icon: new Icon(Icons.add_circle),
                  tooltip: 'Scegli una data',
                  onPressed: (() {
                    _chooseDate(context, _controller.text);
                  }),
                )
              ]),*/
              if (globals.multiSito)
                dropper(),
              SizedBox(height: 50.0),
              RaisedButton(
                child: Text("Prosegui"),
                onPressed: () {
                  if (selectedSite == null) {
                    _asyncConfirmDialog(context);
                  } else {
                    globals.siteId =
                        selectedSite.id == null ? 0 : selectedSite.id;
                    globals.siteName = selectedSite.getDescription();
                    if (globals.logger)
                      print("Sito scelto " + selectedSite.id.toString());
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  }
                },
                color: Colors.green,
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              ),
            ]),
          ],
        ), // ListView
      ),
    );
  }

  Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ATTENZIONE'),
          content: const Text(
              'Seleziona il sito presso quale devi operare !\nSe non è presente alcun sito significa che la tua squadra non è ancora caricata per il giorno selezionato'),
          actions: <Widget>[
            FlatButton(
              child: const Text('ANNULLA'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.ANNULLA);
              },
            ),
            FlatButton(
              child: const Text('PROCEDI'),
              onPressed: () {
                globals.siteId = 0;
                globals.siteName = 'SCONOSCIUTO';
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));

                //Navigator.of(context).pop(ConfirmAction.PROCEDI);
              },
            )
          ],
        );
      },
    );
  }

  Widget dropper() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: new BoxDecoration(
              border: new Border.all(color: Colors.lightGreen)),
          child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                    flex: 2,
                    child: Icon(
                      Icons.store_mall_directory,
                      size: 30,
                      color: Colors.grey,
                    )),
                Expanded(
                  flex: 11,
                  child: DropdownButtonHideUnderline(
                    child: new DropdownButton<Site>(
                      hint: new Text("Seleziona sito"),
                      value: selectedSite,
                      isDense: true,
                      onChanged: (Site newValue) {
                        setState(() {
                          selectedSite = newValue;
                        });
                        //print(selectedWorker.id);
                      },
                      items: _wkSite.map((Site map) {
                        return new DropdownMenuItem<Site>(
                          value: map,
                          child: new Text((map.getDescription()),
                              style: new TextStyle(color: Colors.black)),
                        );
                      }).toList(),
                    ),
                  ),
                ), // end drop
              ])),
    );
  }
}
