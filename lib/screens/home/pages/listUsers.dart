import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lmm_logistics/models/workers.dart';
import 'package:lmm_logistics/screens/home/pages/detail_page.dart';

class ListUsers extends StatefulWidget {
  final List<Workers> workers;

  ListUsers({Key key, this.workers}) : super(key: key);
  final String title = "Sito - ";

  @override
  _ListUsers createState() => _ListUsers();
}

class _ListUsers extends State<ListUsers> {
  void title() {
    print('ciao');
  }

  @override
  Widget build(BuildContext context) {
    ListTile makeListTile(Workers workers) => ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(width: 1.0, color: Colors.white24))),
            child: Icon(Icons.autorenew, color: Colors.white),
          ),
          title: Text(
            workers.first_name,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

          subtitle: Row(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Padding(
                    padding: EdgeInsets.only(left: 0.0),
                    child: Text(workers.last_name,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold))),
              ),
              Expanded(
                  flex: 1,
                  child: Icon(Icons.directions_walk,
                      color: workers.date_start == null
                          ? Colors.red
                          : Colors.green,
                      size: 30.0)),
              Expanded(
                  flex: 1,
                  child: Icon(Icons.directions,
                      color:
                          workers.date_end == null ? Colors.red : Colors.green,
                      size: 30.0)),
            ],
          ),
          trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
          onTap: () async {
            Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailPage(workers: workers)))
                .whenComplete(title);
          },
        );

    Card makeCard(Workers workers) => Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
            child: makeListTile(workers),
          ),
        );

    final makeBody = Container(
        // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
        child: widget.workers.length > 0
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: widget.workers.length,
                itemBuilder: (BuildContext context, int index) {
                  return makeCard(widget.workers[index]);
                },
              )
            : Center(
                child: Text('Nessun utente nella tua squadra',
                    style:
                        new TextStyle(fontSize: 22.0, color: Colors.white))));

    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      body: makeBody,
    );
  }
}
