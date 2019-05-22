import 'package:flutter/material.dart';
import 'package:lmm_logistics/data/rest_ds.dart';
import 'package:lmm_logistics/utils/globals.dart' as globals;
import 'package:lmm_logistics/screens/home/home_screen.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

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
  String  media ='0';
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

void refresh(){
    setState(() {

    });
}

  void caricamento() async{

    tot_colli_lavorati = await api.getTotaleColli(globals.id_daily_job).whenComplete(refresh);
    totale_pers = await api.getTotalePersone(globals.id_daily_job).whenComplete(refresh);

    var x = await api.getTotaleOre(globals.id_daily_job).whenComplete(refresh);
    var y = x.split(':');
    tot_ore_lavorate = int.parse(y[0]).toString() + '.' + int.parse(y[1]).toString();

    x = await api.getEconomiaTot(globals.id_daily_job).whenComplete(refresh);
    y = x.split(':');
    tot_ore_economia = int.parse(y[0]).toString() + '.' + int.parse(y[1]).toString();

    double media_calcolata = double.parse(tot_colli_lavorati) / double.parse(tot_ore_lavorate);
    media = media_calcolata.toStringAsFixed(2);
    var now = new DateTime.now();
    var formatter = new DateFormat('MM');
    String mese = formatter.format(now);
    formatter = new DateFormat('yyyy');
    String anno = formatter.format(now);
    media_mensile = await api.getTotaleColliMese(globals.userId, mese, anno).whenComplete(refresh);
  }

  Widget _TotaleColliLavorati() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(5.0),
      decoration: new BoxDecoration(
          border: new Border.all(color: Colors.lightGreen)
      ),
      child: new Text('Totale colli lavorati = ' + tot_colli_lavorati.toString(),
          style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: fontsize)),
    );
  }

  Widget _TotaleOreEconomia() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(5.0),
      decoration: new BoxDecoration(
          border: new Border.all(color: Colors.lightGreen)
      ),
      child: new Text('Totale ore economia = ' + tot_ore_economia.toString(),
          style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: fontsize)),
    );
  }

  Widget _TotaleOreLavorate() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(5.0),
      decoration: new BoxDecoration(
          border: new Border.all(color: Colors.lightGreen)
      ),
      child: new Text('Totale ore lavorate = ' + tot_ore_lavorate.toString(),
          style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: fontsize)),
    );
  }

  Widget _TotalePersone() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(5.0),
      decoration: new BoxDecoration(
          border: new Border.all(color: Colors.lightGreen)
      ),
      child: new Text('Totale persone = ' + totale_pers.toString(),
          style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: fontsize)),
    );
  }

  Widget _MediaColli() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(5.0),
      decoration: new BoxDecoration(
          border: new Border.all(color: Colors.lightGreen)
      ),
      child: new Text('Media colli/ore = '+media.toString()+" %",
          style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: fontsize)),
    );
  }

  Widget _TotaleColliMese() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(5.0),
      decoration: new BoxDecoration(
          border: new Border.all(color: Colors.lightGreen)
      ),
      child: new Text('Totale colli mese = '+media_mensile.toString(),
          style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: fontsize)),
    );
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
              children: <Widget>[SizedBox(height: 50.0),
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
          ],
        ), // ListView
      ),
    );
  }
}
