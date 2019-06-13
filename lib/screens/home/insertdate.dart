import 'package:flutter/material.dart';
import 'package:lmm_logistics/screens/home/home_screen.dart';
import 'package:lmm_logistics/utils/globals.dart' as globals;
import 'package:lmm_logistics/models/site.dart';
import 'package:flutter/scheduler.dart';
import 'package:lmm_logistics/data/rest_ds.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class InsertDate extends StatefulWidget {
  InsertDate({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _InsertDate createState() => new _InsertDate();
}

class _InsertDate extends State<InsertDate> {
  final TextEditingController _controller = new TextEditingController();
  final f = new DateFormat('dd/MM/yyyy');
  Site selectedSite;
  List<Site> _wkSite = [];
  RestDatasource api = new RestDatasource();
  String datadefault;

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
    _wkSite =
        await api.getSiti(globals.userId, datadefault).whenComplete(refresh);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inserimento giorno lavorativo'),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Column(children: <Widget>[
              SizedBox(height: 50.0),
              new Image.asset(
                'assets/intro.jpg',
                width: 600.0,
                height: 240.0,
                fit: BoxFit.contain,
              ),
              new Row(children: <Widget>[
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
              ]),
              SizedBox(height: 20.0),
              if (globals.multiSito) Dropper(),
              SizedBox(height: 50.0),
              RaisedButton(
                child: Text("Prosegui"),
                onPressed: () {
                  if (selectedSite != null) print("Sito " + selectedSite.id.toString());
                      Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
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

  Widget Dropper() {
    return Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(5.0),
        decoration:
            new BoxDecoration(border: new Border.all(color: Colors.lightGreen)),
        child: Row(children: <Widget>[
          new Icon(Icons.home),
          SizedBox(width: 40.0),
          DropdownButtonHideUnderline(
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
          ), // end drop
        ]));
  }
}
