import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lmm_logistics/data/rest_ds.dart';
import 'package:lmm_logistics/flutter_picker/flutter_picker.dart';
import 'package:lmm_logistics/screens/home/home_screen.dart';
import 'package:lmm_logistics/screens/home/pages/data/PickerData.dart';

RestDatasource rest = new RestDatasource();

class CustomDialog extends StatefulWidget {
  final State state;
  final List<int> listIdWorker;
  final int typeDialog;
  CustomDialog({this.listIdWorker, this.state, this.typeDialog});
  @override
  _CustomDialogState createState() =>
      _CustomDialogState(this.listIdWorker, this.state, this.typeDialog);
}

class _CustomDialogState extends State<CustomDialog> {
  String _oraInizio, _oraFine;
  RestDatasource api = new RestDatasource();
  List<int> listIdWorker;
  State state;
  int typeDialog;
  String _valorePausa;
  List<String> _timepause = ['15', '30', '45', '60', '120'];
  _CustomDialogState(this.listIdWorker, this.state, this.typeDialog);
  @override
  void initState() {
    _oraFine = "00:00";
    _oraInizio = "00:00";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (typeDialog) {
      case 0:
        return AlertDialog(
          contentPadding: EdgeInsets.all(20),
          title: Text(
            "Seleziona gli orari",
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: MaterialButton(
                    onPressed: () {
                      showPickerEconomia(context, "inizio", true);
                    },
                    color: Colors.green,
                    textColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 14, right: 14, top: 4, bottom: 4),
                      child: Text(
                        "Orario inizio \n $_oraInizio",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: MaterialButton(
                    onPressed: () {
                      showPickerEconomia(context, "fine", false);
                    },
                    color: Colors.green,
                    textColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 4, bottom: 4),
                      child: Text(
                        "Orario fine \n $_oraFine",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Chiudi"),
              textColor: Colors.green,
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(state.context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
            ),
          ],
        );
        break;
      case 1:
        return AlertDialog(
          contentPadding: EdgeInsets.all(20),
          title: Text(
            "Seleziona l'orario per la pausa",
            textAlign: TextAlign.center,
          ),
          content: Container(
            child: DropdownButton(
              isDense: true,
              isExpanded: true,
              hint: Text('Scegli la durata'),
              value: _valorePausa == null ? null : _valorePausa,
              onChanged: (newValue) {
                setState(() {
                  _valorePausa = newValue;
                });
              },
              items: _timepause.map((_radioValue1) {
                return DropdownMenuItem(
                  child: new Text(_radioValue1),
                  value: _radioValue1,
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Chiudi"),
              textColor: Colors.green,
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(state.context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
            ),
            FlatButton(
              child: Text("Invia pausa"),
              textColor: Colors.green,
              onPressed: () {
                api.setPauseGroup(_valorePausa, listIdWorker).then((res) => {
                  
                });
                Navigator.of(context).pop();
                Navigator.of(state.context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
            ),
          ],
        );
        break;
    }
  }

  showPickerEconomia(BuildContext context, String title, bool typePicker) {
    Picker(
            height: 100,
            adapter: PickerDataAdapter<String>(
              pickerdata: JsonDecoder().convert(PickerData),
              isArray: true,
            ),
            hideHeader: true,
            selecteds: [0, 0],
            title: Text("Ora $title economia"),
            onConfirm: (Picker picker, List value) {
              setState(() {
                if (typePicker) {
                  _oraInizio = picker.getSelectedValues()[0].toString() +
                      ':' +
                      picker.getSelectedValues()[1];
                  setOrarioInizio();
                } else {
                  _oraFine = picker.getSelectedValues()[0].toString() +
                      ':' +
                      picker.getSelectedValues()[1];
                  setOrarioFine();
                }
              });
            },
            columnPadding: EdgeInsets.all(0))
        .showDialog(context);
  }

  void setOrarioInizio() async {
    await rest.setInizioOraList(listIdWorker, _oraInizio).then((res) {
      print(res);
    });
  }

  void setOrarioFine() async {
    await rest.setFineOraList(listIdWorker, _oraFine).then((res) {
      print(res);
    });
  }
}
