import 'package:flutter/material.dart';
import 'package:lmm_logistics/screens/home/home_screen.dart';
import 'package:lmm_logistics/utils/globals.dart' as globals;

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
        initialDate: initialDate,
        firstDate: new DateTime(1900),
        lastDate: new DateTime.now());

    if (result == null) return;

    setState(() {
      _controller.text = new DateFormat.yMd().format(result);
      globals.dataLavori = _controller.text;
    });
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
              new Row(children: <Widget>[
                new Expanded(
                    child: new TextFormField(
                  decoration: new InputDecoration(
                    icon: const Icon(Icons.calendar_today),
                    hintText: 'Inserisci il giorno di lavoro',
                    labelText: 'Data gg/mm/aaaa',
                  ),
                  controller: _controller,
                  keyboardType: TextInputType.datetime,
                )),
                new IconButton(
                  icon: new Icon(Icons.add_circle),
                  tooltip: 'Scegli una data',
                  onPressed: (() {
                    _chooseDate(context, _controller.text);
                  }),
                )
              ]),

                RaisedButton(
                  child: Text("Prosegui"),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreen()));
                  },
                  color: Colors.blue,
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
}
