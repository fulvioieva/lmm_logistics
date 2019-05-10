import 'package:flutter/material.dart';

class AddUserScreen extends StatefulWidget {
  @override
  _AddUserScreen createState() {
    return new _AddUserScreen();
  }
}

class _AddUserScreen extends State<AddUserScreen> {
  TextEditingController _textFieldController = TextEditingController();

  String nome;
  String cognome;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inserimento Utenti'),
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
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          onSaved: (val) => nome = val,
                          decoration: InputDecoration(labelText: 'Nome'),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          onSaved: (val) => cognome = val,
                          decoration:
                              InputDecoration(labelText: 'Cognome'),
                        ),
                      ),
                    ),
                  ],
                ), // row
              ],
            ), // column
          ],
        ), // ListView
      ),
    );
  }
}
