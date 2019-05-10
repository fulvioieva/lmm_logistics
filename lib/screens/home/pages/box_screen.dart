import 'package:flutter/material.dart';

class BoxScreen extends StatefulWidget {
  @override
  _BoxScreen createState() {
    return new _BoxScreen();
  }
}

class _BoxScreen extends State<BoxScreen> {
  TextEditingController _textFieldController = TextEditingController();

  String secco;
  String murale;
  String gelo;
  String totale;

  Widget _boxText() {
    new Flexible(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          onSaved: (val) {
            secco = val;
          },
          decoration: InputDecoration(labelText: 'secco'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inserimento colli'),
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
                          onSaved: (val) => secco = val,
                          decoration: InputDecoration(labelText: 'secco'),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          onSaved: (val) => murale = val,
                          decoration:
                              InputDecoration(labelText: 'avanzi secco'),
                        ),
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
                          onSaved: (val) => secco = val,
                          decoration: InputDecoration(labelText: 'murale'),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          onSaved: (val) => murale = val,
                          decoration:
                              InputDecoration(labelText: 'avanzi murale'),
                        ),
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
                          onSaved: (val) => secco = val,
                          decoration: InputDecoration(labelText: 'gelo'),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          onSaved: (val) => murale = val,
                          decoration: InputDecoration(labelText: 'avanzi gelo'),
                        ),
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
                          onSaved: (val) => secco = val,
                          decoration:
                              InputDecoration(labelText: 'Totale colli'),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          onSaved: (val) => murale = val,
                          decoration:
                              InputDecoration(labelText: 'Totale avanzi'),
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
