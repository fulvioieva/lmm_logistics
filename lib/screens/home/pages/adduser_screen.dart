import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:lmm_logistics/models/working_user.dart';
import 'package:flutter/scheduler.dart';
import 'package:lmm_logistics/data/rest_ds.dart';
import 'package:lmm_logistics/utils/globals.dart' as globals;
import 'package:lmm_logistics/screens/home/home_screen.dart';
import 'package:dropdownfield/dropdownfield.dart';

WorkingUsers selectedWorker;
List<WorkingUsers> _wkusers = [];

class AddUserScreen extends StatefulWidget {
  TabController tabController;
  AddUserScreen({Key key, this.tabController}) : super(key: key);

  @override
  _AddUserScreen createState() {
    return _AddUserScreen(tabController);
  }
}

class _AddUserScreen extends State<AddUserScreen> {
  TabController tabController;
  _AddUserScreen(this.tabController);

  RestDatasource api = RestDatasource();

  void initState() {
    super.initState();
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {});
    }
    fetchUsers();
  }

  void fetchUsers() async {
    _wkusers =
        await api.getUserAgenzia(globals.id_daily_job).whenComplete(refresh);
  }

  void refresh() {
    if (this.mounted) {
      setState(() {});
    }
  }

  void adduser(int idUser) {
    if (globals.id_daily_job > 0 || idUser == null) {
      api.setDailyJob(globals.id_daily_job, idUser);
      showFlash(
          context: context,
          duration: Duration(seconds: 1),
          builder: (context, controller) {
            return Flash(
              controller: controller,
              style: FlashStyle.floating,
              boxShadows: kElevationToShadow[4],
              backgroundColor: Colors.black87,
              child: FlashBar(
                message: Text("Utente ${selectedWorker.first_name} aggiunto", style: TextStyle(color: Colors.white),),
              ),
            );
          }).whenComplete(() {
        tabController.animateTo(0,
            duration: Duration(seconds: 1), curve: Curves.ease);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestione utenti'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height / 1.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CustomDropDownField(),
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
                        if (selectedWorker != null) adduser(selectedWorker.id);
                      },
                      child: Text("Aggiungi Risorsa"),
                      color: Colors.green,
                      textColor: Colors.white,
                    ),
                  )
                  /*RawMaterialButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.green,
                      size: 35.0,
                    ),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: Colors.white,
                    padding: const EdgeInsets.all(15.0),
                  ),
                  /*
                Container(
                  margin: EdgeInsets.all(20.0),
                  child: RaisedButton(
                    child: Text("Aggiungi utente"),
                    onPressed: () {
                      if (selectedWorker!=null )adduser(selectedWorker.id);
                    },
                    color: Colors.green,
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    splashColor: Colors.grey,
                  ),
                ),
                */
                  RawMaterialButton(
                    onPressed: () {
                      if (selectedWorker != null) adduser(selectedWorker.id);
                    },
                    child: Icon(
                      Icons.add_circle_outline,
                      color: Colors.green,
                      size: 35.0,
                    ),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: Colors.white,
                    padding: const EdgeInsets.all(15.0),
                  ),
                  /*
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
                ),*/*/
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dropDownWithHints() {
    return Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(border: Border.all(color: Colors.lightGreen)),
        child: Row(children: <Widget>[
          Icon(Icons.people),
          SizedBox(width: 40.0),
          DropdownButtonHideUnderline(
            child: DropdownButton<WorkingUsers>(
              hint: Text("Seleziona risorsa"),
              value: selectedWorker,
              isDense: true,
              onChanged: (WorkingUsers value) {
                setState(() {
                  selectedWorker = value;
                });
                //print(selectedWorker.id);
              },
              items: _wkusers.map((WorkingUsers map) {
                return DropdownMenuItem<WorkingUsers>(
                  value: map,
                  child: Text((map.getDescription()),
                      style: TextStyle(color: Colors.black)),
                );
              }).toList(),
            ),
          ), // end drop
        ]));
  }
}

class CustomDropDownField extends StatefulWidget {
  @override
  _CustomDropDownFieldState createState() => _CustomDropDownFieldState();
}

class _CustomDropDownFieldState extends State<CustomDropDownField> {
  @override
  Widget build(BuildContext context) {
    List<String> testList = new List();

    _wkusers.forEach((WorkingUsers workuser) {
      testList.add(workuser.first_name + " " + workuser.last_name);
    });

    testList.sort();

    String name;

    void selectUser(String user) {
      for (WorkingUsers workuser in _wkusers) {
        if ((workuser.first_name + " " + workuser.last_name).compareTo(user) ==
            0) {
          print("${(workuser.first_name + " " + workuser.last_name)} : $user");
          setState(() {
            selectedWorker = workuser;
          });
          break;
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.only(left: 35, right: 15, top: 50),
      child: Container(
        child: DropDownField(
          icon: Icon(Icons.person_add),
          itemsVisibleInDropdown: 5,
          hintText: "Seleziona risorsa",
          setter: (dynamic value) {
            setState(() {
              selectUser(value);
              name = value;
              FocusScope.of(context).requestFocus(FocusNode());
            });
          },
          value: name,
          onValueChanged: (dynamic value) {
            setState(() {
              selectUser(value);
              name = value;
              FocusScope.of(context).requestFocus(FocusNode());
            });
          },
          items: testList,
        ),
      ),
    );
  }
}
