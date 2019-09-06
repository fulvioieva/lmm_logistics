import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lmm_logistics/screens/home/home_screen.dart';
import 'package:lmm_logistics/models/colli.dart';
import 'package:lmm_logistics/data/rest_ds.dart';
import 'package:lmm_logistics/utils/globals.dart' as globals;

class BoxScreen extends StatefulWidget {
  TabController tabController;
  BoxScreen({Key key, this.tabController}) : super(key: key);
  @override
  _BoxScreen createState() {
    return new _BoxScreen(this.tabController);
  }
}

class _BoxScreen extends State<BoxScreen> {
  TabController tabController;
  _BoxScreen(this.tabController);
  RestDatasource api = new RestDatasource();

  static final TextEditingController _seccoController = TextEditingController();
  static final TextEditingController _muraleController =
      TextEditingController();
  static final TextEditingController _geloController = TextEditingController();
  static final TextEditingController _avanziSeccoController =
      TextEditingController();
  static final TextEditingController _avanziMuraleController =
      TextEditingController();
  static final TextEditingController _avanziGeloController =
      TextEditingController();
  static final TextEditingController _pedaneController =
      TextEditingController();
  static final TextEditingController _noteController = TextEditingController();

  int totale = 0;
  int totale_a = 0;
  Colli colli;

  @override
  void initState() {
    super.initState();
    getColli();
  }

  void setColli() async {
    await api
        .setColli(
            globals.id_daily_job,
            int.parse(_seccoController.text),
            int.parse(_muraleController.text),
            int.parse(_geloController.text),
            int.parse(_avanziSeccoController.text),
            int.parse(_avanziMuraleController.text),
            int.parse(_avanziGeloController.text),
            int.parse(_pedaneController.text),
            _noteController.text.replaceAll("'", " ").replaceAll('"', " "))
        .whenComplete(calculus);
  }

  void getColli() async {
    Colli cl = await api.getColli(globals.id_daily_job).whenComplete(calculus);
    if (cl != null) {
      colli = cl;
      if (this.mounted) {
        setState(() {
          _seccoController.text = colli.secco.toString();
          _muraleController.text = colli.murale.toString();
          _geloController.text = colli.gelo.toString();
          _avanziSeccoController.text = colli.a_secco.toString();
          _avanziMuraleController.text = colli.a_murale.toString();
          _avanziGeloController.text = colli.a_gelo.toString();
          _pedaneController.text = colli.pedane.toString();
          _noteController.text = colli.note.toString();

          totale_a = int.parse(_avanziSeccoController.text) +
              int.parse(_avanziMuraleController.text) +
              int.parse(_avanziGeloController.text);

          totale = int.parse(_pedaneController.text) +
              int.parse(_seccoController.text) +
              int.parse(_muraleController.text) +
              int.parse(_geloController.text) -
              totale_a;
        });
      }
    } else {
      if (this.mounted) {
        setState(() {
          _seccoController.text = '';
          _muraleController.text = '';
          _geloController.text = '';
          _avanziSeccoController.text = '';
          _avanziMuraleController.text = '';
          _avanziGeloController.text = '';
          _pedaneController.text = '';
          _noteController.text = '';
          totale = 0;
          totale_a = 0;
        });
      }
    }
  }

  void calculus() {
    if (this.mounted) {
      setState(() {
        if (_seccoController.text == '') _seccoController.text = '0';
        if (_muraleController.text == '') _muraleController.text = '0';
        if (_geloController.text == '') _geloController.text = '0';
        if (_avanziSeccoController.text == '')
          _avanziSeccoController.text = '0';
        if (_avanziMuraleController.text == '')
          _avanziMuraleController.text = '0';
        if (_avanziGeloController.text == '') _avanziGeloController.text = '0';
        if (_pedaneController.text == '') _pedaneController.text = '0';
        if (_noteController.text == '') _noteController.text = ' ';

        totale_a = int.parse(_avanziSeccoController.text) +
            int.parse(_avanziMuraleController.text) +
            int.parse(_avanziGeloController.text);

        totale = int.parse(_seccoController.text) +
            int.parse(_pedaneController.text) +
            int.parse(_muraleController.text) +
            int.parse(_geloController.text) -
            totale_a;

        _seccoController.text = int.parse(_seccoController.text).toString();
        _avanziSeccoController.text =
            int.parse(_avanziSeccoController.text).toString();
        _muraleController.text = int.parse(_muraleController.text).toString();
        _avanziMuraleController.text =
            int.parse(_avanziMuraleController.text).toString();
        _geloController.text = int.parse(_geloController.text).toString();
        _avanziGeloController.text =
            int.parse(_avanziGeloController.text).toString();
        _pedaneController.text = int.parse(_pedaneController.text).toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inserimento colli'),
        backgroundColor: (Colors.green),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(height: 0.0),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: TextFormField(
                            controller: _seccoController,
                            onEditingComplete: calculus,
                            decoration: InputDecoration(labelText: 'secco'),
                            keyboardType: TextInputType.number,
                            style:
                                TextStyle(color: Colors.blue, fontSize: 20.0)),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: TextFormField(
                            controller: _avanziSeccoController,
                            onEditingComplete: calculus,
                            decoration:
                                InputDecoration(labelText: 'avanzi secco'),
                            keyboardType: TextInputType.number,
                            style:
                                TextStyle(color: Colors.blue, fontSize: 20.0)),
                      ),
                    ),
                  ],
                ), // row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(height: 0.0),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: TextFormField(
                            controller: _muraleController,
                            onEditingComplete: calculus,
                            decoration: InputDecoration(labelText: 'murale'),
                            keyboardType: TextInputType.number,
                            style:
                                TextStyle(color: Colors.blue, fontSize: 20.0)),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: TextFormField(
                            controller: _avanziMuraleController,
                            onEditingComplete: calculus,
                            decoration:
                                InputDecoration(labelText: 'avanzi murale'),
                            keyboardType: TextInputType.number,
                            style:
                                TextStyle(color: Colors.blue, fontSize: 20.0)),
                      ),
                    ),
                  ],
                ), // row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(height: 0.0),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: TextFormField(
                            controller: _geloController,
                            onEditingComplete: calculus,
                            decoration: InputDecoration(labelText: 'gelo'),
                            keyboardType: TextInputType.number,
                            style:
                                TextStyle(color: Colors.blue, fontSize: 20.0)),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: TextFormField(
                            controller: _avanziGeloController,
                            onEditingComplete: calculus,
                            decoration:
                                InputDecoration(labelText: 'avanzi gelo'),
                            keyboardType: TextInputType.number,
                            style:
                                TextStyle(color: Colors.blue, fontSize: 20.0)),
                      ),
                    ),
                  ],
                ), // row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(height: 0.0),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: TextFormField(
                            controller: _pedaneController,
                            onEditingComplete: calculus,
                            decoration: InputDecoration(labelText: 'Pedane'),
                            keyboardType: TextInputType.number,
                            style:
                                TextStyle(color: Colors.blue, fontSize: 20.0)),
                      ),
                    ), /*
                    Flexible(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Tot. ' + totale_a.toString(),style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0))
                      ),
                    ),*/
                  ],
                ), // row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(height: 0.0),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Tot. ' + totale.toString(),
                          style: DefaultTextStyle.of(context)
                              .style
                              .apply(fontSizeFactor: 2.0),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Tot. ' + totale_a.toString(),
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .apply(fontSizeFactor: 2.0))),
                    ),
                  ],
                ), // row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(height: 0.0),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                            controller: _noteController,
                            onEditingComplete: calculus,
                            decoration: InputDecoration(labelText: 'note'),
                            style:
                                TextStyle(color: Colors.blue, fontSize: 20.0)),
                      ),
                    ),
                  ],
                ), // row
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
                              duration: Duration(seconds: 1),
                              curve: Curves.ease);
                        }),
                    child: Text("Lista Risorse"),
                    color: Colors.green,
                    textColor: Colors.white,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: MaterialButton(
                    onPressed: () {
                      calculus();
                      setColli();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 7, right: 7),
                      child: Text("Invia dati"),
                    ),
                    color: Colors.green,
                    textColor: Colors.white,
                  ),
                ),

                /*Container(
                  margin: EdgeInsets.all(20.0),
                  child: RaisedButton(
                    child: Text("Invia Dati"),
                    onPressed: () {
                      calculus();
                      setColli();
                    },
                    color: Colors.green,
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    splashColor: Colors.grey,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20.0),
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
                ),*/
              ],
            ),
          ],
        ),
      ),
    );
  }
}
