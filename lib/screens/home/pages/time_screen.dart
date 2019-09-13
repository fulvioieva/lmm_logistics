import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:lmm_logistics/models/workers.dart';
import 'package:lmm_logistics/utils/customDialog.dart';
import 'detail_page.dart';
import 'package:lmm_logistics/data/rest_ds.dart';

bool checkOptions;
List<int> selectedIdWorkers;

class TimeScreen extends StatefulWidget {
  final String title;
  TimeScreen({Key key, this.title}) : super(key: key);

  @override
  _TimeScreenState createState() => _TimeScreenState(this.title);
}

class _TimeScreenState extends State<TimeScreen> {
  final String title;
  _TimeScreenState(this.title);
  RestDatasource api = new RestDatasource();

  @override
  void initState() {
    checkOptions = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(title),
        backgroundColor: (Colors.green),
        actions: <Widget>[
          Padding(padding: const EdgeInsets.all(4.0), child: selectButton())
        ],
      ),
      body: FutureBuilder<List<Workers>>(
        future: api.fetchUsersEvol(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? ListEmployes(workers: snapshot.data, state: this,)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget selectButton() {
    if (!checkOptions) {
      return IconButton(
        onPressed: () {
          setState(() {
            checkOptions = !checkOptions;
          });
        },
        icon: Icon(Icons.access_time),
      );
    } else {
      if (selectedIdWorkers.length < 1) {
        return IconButton(
          onPressed: () {
            setState(() {
              checkOptions = !checkOptions;
            });
          },
          icon: Icon(Icons.close),
        );
      } else {
        return MaterialButton(
          onPressed: () {
            setState(() {
              showDialog(
                  context: context,
                  builder: (_) {
                    print(selectedIdWorkers.join(","));
                    return CustomDialog(
                      listIdWorker: selectedIdWorkers,
                      state: this,
                    );
                  });
            });
          },
          color: Colors.green,
          elevation: 10,
          child: Text(
            "Aggiungi orario",
            style: TextStyle(color: Colors.white),
          ),
        );
      }
    }
  }
}

class ListEmployes extends StatefulWidget {
  final List<Workers> workers;
  final State state;

  const ListEmployes({Key key, this.workers, this.state}) : super(key: key);
  @override
  _ListEmployesState createState() => _ListEmployesState(this.workers, this.state);
}

class _ListEmployesState extends State<ListEmployes> {
  final List<Workers> workers;
  final State state;

  _ListEmployesState(this.workers, this.state);

  List<bool> listSelected;

  @override
  void initState() {
    listSelected = new List(workers.length);
    selectedIdWorkers = new List();
    for (int i = 0; i < listSelected.length; i++) {
      listSelected[i] = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(58, 66, 86, 1.0),
      ),
      child: workers.length > 0
          ? ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: workers.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 2.5, bottom: 2.5),
                  child: Card(
                    elevation: 10,
                    color: Color.fromRGBO(64, 75, 96, 0.9),
                    child: buildTile(workers[index], index),
                  ),
                );
              },
            )
          : Center(
              child: Text(
                'Nessun utente nella tua squadra',
                style: new TextStyle(fontSize: 22.0, color: Colors.white),
              ),
            ),
    );
  }

  ListTile buildTile(Workers workers, int index) {
    return ListTile(
        leading: checkOptions == true
            ? CircularCheckBox(
                activeColor: Colors.green,
                inactiveColor: Colors.white,
                materialTapTargetSize: MaterialTapTargetSize.padded,
                value: listSelected[index],
                onChanged: (value) {
                  setState(() {
                    if (value) {
                      state.setState(() {
                        selectedIdWorkers.add(workers.workId);
                        listSelected[index] = value;
                      });
                    } else {
                      state.setState(() {
                        listSelected[index] = value;
                        selectedIdWorkers.remove(workers.workId);
                      });
                    }
                  });
                },
              )
            : Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.person,
                  color:
                      workers.agenzia == 1 ? Colors.white : Colors.lightGreen,
                  size: 40,
                ),
              ),
        trailing: Icon(
          Icons.navigate_next,
          size: 35,
          color: Colors.white,
        ),
        contentPadding: EdgeInsets.all(8),
        title: Text(
          "${workers.firstName} ${workers.lastName}",
          style: TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.directions_walk,
                      color:
                          workers.dateStart == null ? Colors.red : Colors.green,
                    ),
                    Text(
                      workers.dateStart == null
                          ? ""
                          : workers.dateStart.substring(10, 16),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.directions,
                      color:
                          workers.dateEnd == null ? Colors.red : Colors.green,
                    ),
                    Text(
                      workers.dateEnd == null
                          ? ""
                          : workers.dateEnd.substring(10, 16),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: () async {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPage(workers: workers),
              ));
        });
  }
}
