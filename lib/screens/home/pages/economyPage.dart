import 'package:flutter/material.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';

Duration _durationNormal;
Duration _durationHoliday;
Duration _durationNocturnal;
double _valueNormal;
double _valueHoliday;
double _valueNocturnal;

String _printHour(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  return "${twoDigits(duration.inHours)}";
}

String _printMinute(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  return twoDigitMinutes;
}

class EconomyPage extends StatefulWidget {
  final TabController tabController;

  const EconomyPage({Key key, this.tabController}) : super(key: key);
  @override
  _EconomyPageState createState() => _EconomyPageState(this.tabController);
}

class _EconomyPageState extends State<EconomyPage> {
  TabController tabController;
  _EconomyPageState(this.tabController);

  @override
  void initState() {
    _durationNormal = Duration(hours: 0);
    _durationHoliday = Duration(hours: 0);
    _durationNocturnal = Duration(hours: 0);
    _valueNormal = 0;
    _valueHoliday = 0;
    _valueNocturnal = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gestione economia"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height / 1.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.lightGreen),
                      ),
                      child: FlatButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return GetHourMinute(
                                  state: this,
                                  typeHour: "Normali",
                                );
                              });
                        },
                        child: Text(
                          "${_printHour(_durationNormal)}:${_printMinute(_durationNormal)}",
                          style: DefaultTextStyle.of(context)
                              .style
                              .apply(fontSizeFactor: 1.8),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Normali',
                      style: DefaultTextStyle.of(context)
                          .style
                          .apply(fontSizeFactor: 1.3),
                    ),
                  ),
                ],
              ),
              Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: const EdgeInsets.all(10.0),
                      decoration: new BoxDecoration(
                        border: new Border.all(color: Colors.lightGreen),
                      ),
                      child: FlatButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return GetHourMinute(
                                  state: this,
                                  typeHour: "Festive",
                                );
                              });
                        },
                        child: Text(
                          "${_printHour(_durationHoliday)}:${_printMinute(_durationHoliday)}",
                          style: DefaultTextStyle.of(context)
                              .style
                              .apply(fontSizeFactor: 1.8),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Festive',
                      style: DefaultTextStyle.of(context)
                          .style
                          .apply(fontSizeFactor: 1.3),
                    ),
                  ),
                ],
              ),
              Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: const EdgeInsets.all(10.0),
                      decoration: new BoxDecoration(
                        border: new Border.all(color: Colors.lightGreen),
                      ),
                      child: FlatButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return GetHourMinute(
                                  state: this,
                                  typeHour: "Notturne",
                                );
                              });
                        },
                        child: Text(
                          "${_printHour(_durationNocturnal)}:${_printMinute(_durationNocturnal)}",
                          style: DefaultTextStyle.of(context)
                              .style
                              .apply(fontSizeFactor: 1.8),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Notturne',
                      style: DefaultTextStyle.of(context)
                          .style
                          .apply(fontSizeFactor: 1.3),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(10.0),
                    child: MaterialButton(
                      onPressed: () => setState(() {
                        tabController.animateTo(0,
                            duration: Duration(seconds: 1), curve: Curves.ease);
                      }),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Text("Lista Risorse"),
                      ),
                      color: Colors.green,
                      textColor: Colors.white,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          _durationNormal = new Duration(hours: 0, minutes: 0);
                          _durationHoliday = new Duration(hours: 0, minutes: 0);
                          _durationNocturnal =
                              new Duration(hours: 0, minutes: 0);
                          _valueHoliday = 0;
                          _valueNormal = 0;
                          _valueNocturnal = 0;
                        });
                      },
                      child: Text("Pulisci tutto"),
                      color: Colors.green,
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GetHourMinute extends StatefulWidget {
  State state;
  String typeHour;
  GetHourMinute({this.state, this.typeHour});
  @override
  _GetHourMinuteState createState() =>
      _GetHourMinuteState(this.state, this.typeHour);
}

class _GetHourMinuteState extends State<GetHourMinute> {
  Duration _duration;
  String typeHour;
  State<StatefulWidget> state;

  _GetHourMinuteState(this.state, this.typeHour);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Inserisci il totale ore $typeHour"),
      content: Container(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      "Ore",
                      textAlign: TextAlign.center,
                    ),
                    Text(
                        "${_printHour(typeHour == "Normali" ? _durationNormal : typeHour == "Festive" ? _durationHoliday : _durationNocturnal)}",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 64))
                  ],
                ),
                Text(
                  ":",
                  style: TextStyle(fontSize: 64),
                ),
                Column(
                  children: <Widget>[
                    Text(
                      "Minuti",
                      textAlign: TextAlign.center,
                    ),
                    Text(
                        "${_printMinute(typeHour == "Normali" ? _durationNormal : typeHour == "Festive" ? _durationHoliday : _durationNocturnal)}",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 64))
                  ],
                ),
              ],
            ),
            /* 
            Text(
              "${_printDuration(_duration)}",
              style:TextStyle(fontSize: 64),
            ), */
            Slider(
              min: 0.0,
              max: 480.0,
              divisions: 32,
              activeColor: Colors.green,
              inactiveColor: Colors.green,
              onChanged: (double value) {
                setState(() {
                  switch (typeHour) {
                    case "Normali":
                      state.setState(() {
                        _valueNormal = value;
                        _duration = Duration(minutes: _valueNormal.toInt());
                        _durationNormal = _duration;
                      });
                      break;
                    case "Festive":
                      state.setState(() {
                        _valueHoliday = value;
                        _duration = Duration(minutes: _valueHoliday.toInt());
                        _durationHoliday = _duration;
                      });
                      break;
                    case "Notturne":
                      state.setState(() {
                        _valueNocturnal = value;
                        _duration = Duration(minutes: _valueNocturnal.toInt());
                        _durationNocturnal = _duration;
                      });
                      break;
                  }
                });
              },
              value: typeHour == "Normali"
                  ? _valueNormal
                  : typeHour == "Festive" ? _valueHoliday : _valueNocturnal,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Chiudi"),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text("Salva"),
        ),
      ],
    );
  }
}
