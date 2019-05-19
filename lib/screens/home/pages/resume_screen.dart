import 'package:flutter/material.dart';
import 'package:lmm_logistics/data/rest_ds.dart';
import 'package:lmm_logistics/utils/globals.dart' as globals;
import 'package:lmm_logistics/screens/home/home_screen.dart';
import 'package:flutter/scheduler.dart';

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
  int media =0;
  int media_mensile=0;
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
    tot_ore_economia = await api.getEconomiaTot(globals.id_daily_job).whenComplete(refresh);
    var x = await api.getTotaleOre(globals.id_daily_job).whenComplete(refresh);
    var y = x.split(':');
    tot_ore_lavorate = int.parse(y[0]).toString() + ',' + int.parse(y[1]).toString();

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



                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 0.0),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Tot. colli lavorati = ' + tot_colli_lavorati.toString()
                            ,style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: fontsize)),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Tot. ore economia = ' + tot_ore_economia.toString()
                            ,style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: fontsize)),
                      ),
                    ),
                  ],
                ), // row
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 0.0),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Tot. ore lavorate = ' + tot_ore_lavorate.toString()
                            ,style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: fontsize)),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Tot. persone = ' + totale_pers.toString()
                            ,style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: fontsize)),
                      ),
                    ),
                  ],
                ), // row

                SizedBox(height: 0.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 0.0),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('Media colli/ore = '+media.toString()+" %"
                            ,style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: fontsize)),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text('Tot. colli mese = '+media_mensile.toString()+" %"
                            ,style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: fontsize)),
                      ),
                    ),
                  ],
                ), // row
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
