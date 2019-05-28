import 'package:flutter/material.dart';
import 'package:lmm_logistics/data/rest_ds.dart';
import 'package:lmm_logistics/utils/globals.dart' as globals;
import 'package:lmm_logistics/screens/home/home_screen.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

enum ConfirmAction { CANCEL, ACCEPT }

class ResumeScreen extends StatefulWidget {
  @override
  _ResumeScreen createState() {
    return new _ResumeScreen();
  }
}

class _ResumeScreen extends State<ResumeScreen> {
  double fontsize = 1.3;

  String tot_colli_lavorati = "0";
  String tot_ore_economia = "0";
  String tot_ore_lavorate = "0";
  String totale_pers = "0";
  String media = '0';
  String media_mensile = '0';
  RestDatasource api = new RestDatasource();

  void initState() {
    super.initState();
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        caricamento();
      });
    }
  }

  void refresh() {
    if (this.mounted) {
      setState(() {
        //Your state change code goes here
      });
    }
  }

  void caricamento() async {
    var y = [];
    String xx = await api.getTotaleColli(globals.id_daily_job).whenComplete(refresh);

    tot_colli_lavorati = xx!=null?xx:'0';

    totale_pers =
        await api.getTotalePersone(globals.id_daily_job).whenComplete(refresh);

    var x = await api.getTotaleOre(globals.id_daily_job).whenComplete(refresh);
    if (x != null) {
      y = x.split('.');
    } else {
      y = "0:0".split(':');
    }
    tot_ore_lavorate =
        int.parse(y[0]).toString() + '.' + int.parse(y[1]).toString();

    x = await api.getEconomiaTot(globals.id_daily_job).whenComplete(refresh);
    if (x != null) {
      y = x.split(':');
    } else {
      y = "0:0".split(':');
    }
    tot_ore_economia =
        int.parse(y[0]).toString() + '.' + int.parse(y[1]).toString();

    double media_calcolata =
        double.parse(tot_colli_lavorati) / double.parse(tot_ore_lavorate);
    if (double.parse(tot_colli_lavorati)!=0.0 &&  double.parse(tot_ore_lavorate)!=0.0){
      media = media_calcolata.toStringAsFixed(2);
    }else{
      media = "Non disp.";
    }

    var now = new DateTime.now();
    var formatter = new DateFormat('MM');
    String mese = formatter.format(now);
    formatter = new DateFormat('yyyy');
    String anno = formatter.format(now);

    String cmese = await api
        .getTotaleColliMese(globals.userId, mese, anno)
        .whenComplete(refresh);
    if (cmese == null) {
      cmese='0';
    }

    String omese = await api.getTotaleOreMese(globals.userId, mese, anno).whenComplete(refresh);
    if (omese != null) {
      y = omese.split('.');
    } else {
      y = "0:0".split(':');
    }
    String tot_omese =
        int.parse(y[0]).toString() + '.' + int.parse(y[1]).toString();

    if (double.parse(cmese)!=0.0 &&  double.parse(tot_omese)!=0.0){
      media_mensile = (double.parse(cmese) / double.parse(tot_omese)).toStringAsFixed(2);
    }else{
      media_mensile = "Non disp.";
    }





  }

  Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chiudi attività'),
          content: const Text(
              'In questo modo confermi la conclusione dell\'attività'),
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
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            )
          ],
        );
      },
    );
  }

  Widget _TotaleColliLavorati() {
    return Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(5.0),
        decoration:
            new BoxDecoration(border: new Border.all(color: Colors.lightGreen)),
        child: Row(children: <Widget>[
          new Icon(Icons.add_shopping_cart),
          SizedBox(width: 40.0),
          new Text('Totale colli lavorati = ' + tot_colli_lavorati.toString(),
              style: DefaultTextStyle.of(context)
                  .style
                  .apply(fontSizeFactor: fontsize)),
        ]));
  }

  Widget _TotaleOreEconomia() {
    return Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(5.0),
        decoration:
            new BoxDecoration(border: new Border.all(color: Colors.lightGreen)),
        child: Row(children: <Widget>[
          new Icon(Icons.save_alt),
          SizedBox(width: 40.0),
          new Text('Totale ore economia = ' + tot_ore_economia.toString(),
              style: DefaultTextStyle.of(context)
                  .style
                  .apply(fontSizeFactor: fontsize)),
        ]));
  }

  Widget _TotaleOreLavorate() {
    return Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(5.0),
        decoration:
            new BoxDecoration(border: new Border.all(color: Colors.lightGreen)),
        child: Row(children: <Widget>[
          new Icon(Icons.access_time),
          SizedBox(width: 40.0),
          new Text('Totale ore lavorate = ' + tot_ore_lavorate.toString(),
              style: DefaultTextStyle.of(context)
                  .style
                  .apply(fontSizeFactor: fontsize)),
        ]));
  }

  Widget _TotalePersone() {
    return Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(5.0),
        decoration:
            new BoxDecoration(border: new Border.all(color: Colors.lightGreen)),
        child: Row(children: <Widget>[
          new Icon(Icons.supervisor_account),
          SizedBox(width: 40.0),
          new Text('Totale persone = ' + totale_pers.toString(),
              style: DefaultTextStyle.of(context)
                  .style
                  .apply(fontSizeFactor: fontsize)),
        ]));
  }

  Widget _MediaColli() {
    return Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(5.0),
        decoration:
            new BoxDecoration(border: new Border.all(color: Colors.lightGreen)),
        child: Row(children: <Widget>[
          new Icon(Icons.assignment),
          SizedBox(width: 40.0),
          new Text('Media colli/ore = ' + media.toString(),
              style: DefaultTextStyle.of(context)
                  .style
                  .apply(fontSizeFactor: fontsize)),
        ]));
  }

  Widget _TotaleColliMese() {
    return Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(5.0),
        decoration:
            new BoxDecoration(border: new Border.all(color: Colors.lightGreen)),
        child: Row(children: <Widget>[
          new Icon(Icons.chrome_reader_mode),
          SizedBox(width: 40.0),
          new Text('Media colli/ore mese = ' + media_mensile.toString(),
              style: DefaultTextStyle.of(context)
                  .style
                  .apply(fontSizeFactor: fontsize)),
        ]));
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
                SizedBox(height: 50.0),
                _TotaleColliLavorati(),
                _TotaleOreEconomia(),
                _TotaleOreLavorate(),
                _TotalePersone(),
                _MediaColli(),
                _TotaleColliMese(),
                Row(children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(20.0),
                    child: RaisedButton(
                      child: Text("Conferma finale"),
                      onPressed: () {
                        _asyncConfirmDialog(context);
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
              ],
            ), // column
          ],
        ), // ListView
      ),
    );
  }
}
