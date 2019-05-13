import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:lmm_logistics/models/workers.dart';
import 'listUsers.dart';
import 'package:lmm_logistics/data/rest_ds.dart';

class TimeScreen extends StatelessWidget {
  final String title;
  TimeScreen({Key key, this.title}) : super(key: key);
  RestDatasource api = new RestDatasource();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),backgroundColor: (Colors.green),
      ),
      body: FutureBuilder<List<Workers>>(
        future: api.fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? ListUsers(workers: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }


}