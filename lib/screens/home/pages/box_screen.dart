import 'package:flutter/material.dart';
import 'package:lmm_logistics/screens/home/home_screen.dart';
import 'package:lmm_logistics/models/colli.dart';
import 'package:lmm_logistics/data/rest_ds.dart';
import 'package:lmm_logistics/utils/globals.dart' as globals;

class BoxScreen extends StatefulWidget {

  @override
  _BoxScreen createState() {
    return new _BoxScreen();
  }
}

class _BoxScreen extends State<BoxScreen> {

  RestDatasource api = new RestDatasource();

  static final TextEditingController _seccoController = TextEditingController();
  static final TextEditingController _muraleController = TextEditingController();
  static final TextEditingController _geloController = TextEditingController();
  static final TextEditingController _avanzi_seccoController = TextEditingController();
  static final TextEditingController _avanzi_muraleController = TextEditingController();
  static final TextEditingController _avanzi_geloController = TextEditingController();
  static final TextEditingController _pedaneController = TextEditingController();
  static final TextEditingController _noteController = TextEditingController();


  int totale = 0;
  int totale_a = 0;
  Colli colli;

  @override
  void initState()  {
    super.initState();
    getColli();

  }

  void setColli() async {
    await api.setColli(globals.id_daily_job,
        int.parse(_seccoController.text),
        int.parse(_muraleController.text),
        int.parse(_geloController.text),
        int.parse(_avanzi_seccoController.text),
        int.parse(_avanzi_muraleController.text),
        int.parse(_avanzi_geloController.text),
        int.parse(_pedaneController.text),
        _noteController.text).whenComplete(calculus);
  }

  void getColli() async {
    Colli cl = await api.getColli(globals.id_daily_job).whenComplete(calculus);
    if (cl != null) {
      colli = cl;
      setState(() {
        _seccoController.text=colli.secco.toString();
        _muraleController.text=colli.murale.toString();
        _geloController.text=colli.gelo.toString();
        _avanzi_seccoController.text=colli.a_secco.toString();
        _avanzi_muraleController.text=colli.a_murale.toString();
        _avanzi_geloController.text=colli.a_gelo.toString();
        _pedaneController.text=colli.pedane.toString();
        _noteController.text=colli.note.toString();

        totale_a = int.parse(_avanzi_seccoController.text)  +
            int.parse(_avanzi_muraleController.text) +
            int.parse(_avanzi_geloController.text);

        totale =  int.parse(_pedaneController.text) + int.parse(_seccoController.text) +
            int.parse(_muraleController.text) +
            int.parse(_geloController.text) - totale_a;

      });
    }else{
      setState(() {
        _seccoController.text = '0';
        _muraleController.text = '0';
        _geloController.text = '0';
        _avanzi_seccoController.text = '0';
        _avanzi_muraleController.text = '0';
        _avanzi_geloController.text = '0';
        _pedaneController.text = '0';
        _noteController.text = '';
        totale = 0;
        totale_a = 0;
      });
    }
  }

  void calculus(){
    setState(() {
      if (_seccoController.text=='')_seccoController.text='0';
      if (_muraleController.text=='')_muraleController.text='0';
      if (_geloController.text=='')_geloController.text='0';
      if (_avanzi_seccoController.text=='')_avanzi_seccoController.text='0';
      if (_avanzi_muraleController.text=='')_avanzi_muraleController.text='0';
      if (_avanzi_geloController.text=='')_avanzi_geloController.text='0';
      if (_pedaneController.text=='')_pedaneController.text='0';
      if (_noteController.text=='')_noteController.text=' ';

      totale_a = int.parse(_avanzi_seccoController.text)  +
          int.parse(_avanzi_muraleController.text) +
          int.parse(_avanzi_geloController.text);

      totale =  int.parse(_seccoController.text) + int.parse(_pedaneController.text) +
          int.parse(_muraleController.text) +
          int.parse(_geloController.text) - totale_a;


      _seccoController.text = int.parse(_seccoController.text).toString();
      _avanzi_seccoController.text = int.parse(_avanzi_seccoController.text).toString();
      _muraleController.text = int.parse(_muraleController.text).toString() ;
      _avanzi_muraleController.text = int.parse(_avanzi_muraleController.text).toString();
      _geloController.text = int.parse(_geloController.text).toString();
      _avanzi_geloController.text = int.parse(_avanzi_geloController.text).toString();
      _pedaneController.text = int.parse(_pedaneController.text).toString();

    });



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
                            controller: _avanzi_seccoController,
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
                            controller: _avanzi_muraleController,
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
                            controller: _avanzi_geloController,
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
                            decoration:
                            InputDecoration(labelText: 'Pedane'),
                            keyboardType: TextInputType.number,
                            style:
                            TextStyle(color: Colors.blue, fontSize: 20.0)),
                      ),
                    ),/*
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
                        child: Text('Tot. ' + totale.toString(),style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0),),

                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Tot. ' + totale_a.toString(),style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0))
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
            ), // column
            Row(children: <Widget>[
              Container(
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
        ), // ListView
      ),
    );
  }
}
