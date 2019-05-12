import 'dart:async';
import 'dart:convert';
import 'package:lmm_logistics/utils/network_util.dart';
import 'package:lmm_logistics/models/user.dart';
import 'package:lmm_logistics/utils/globals.dart' as globals;
import 'package:lmm_logistics/models/workers.dart';
import 'package:lmm_logistics/models/pause.dart';
import 'package:lmm_logistics/models/colli.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final LOGIN_URL = globals.loginUrl;

  Future<User> login(String username, String password) async {
    var body =
        json.encode({"method": "login", "user": username, "pass": password});
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      User us;
      if(res["error_msg"]!='Invalid credentitals') {
        for (var h in res["user"]) {
          us = new User(
              username: h['username'],
              password: h['password'],
              id: h['id']);
        }
      }
      return us;
    });
  }


  Future<List<Workers>> fetchUsers() async {
    String utente = globals.userId.toString();
    var x = globals.dataLavori.split('/');
    String data = x[2] + '-' + x[0] + '-' + x[1];//'2019-04-23';
    if (globals.logger)  print("Data Lavori " + data);
    var body =
    json.encode({"method": "getUtenti", "data": data, "utente": utente});
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      List<Workers> c = new List<Workers>();
      if (res["error_msg"] != "No user") {
        for (var h in res["users"]) {
          Workers work = new Workers(
              id: int.tryParse(h['id']),
              first_name: h['first_name'],
              last_name: h['last_name'],
              id_daily_job: int.tryParse(h['id_daily_job']),
              work_id: int.tryParse(h['work_id']),
              id_sito: int.tryParse(h['id_sito']),
              date_start: h['date_start'],
              date_end: h['date_end']);
              globals.id_daily_job = int.tryParse(h['id_daily_job']);
          c.add(work);
        }
      }

      return c;
    });
  }

  Future<Colli> getColli(int id_daily_job) async {
    Colli colli = null;
    var body =
        json.encode({"method": "getColli", "id_daily_job": id_daily_job});
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      if (res["error_msg"] != "No colli") {
        for (var h in res["colli"]) {
      colli = new Colli(
              id: int.tryParse(h['id']),
              secco: int.tryParse(h['secco']),
              murale: int.tryParse(h['murale']),
              gelo: int.tryParse(h['gelo']),
              a_secco: int.tryParse(h['a_secco']),
              a_murale: int.tryParse(h['a_murale']),
              a_gelo: int.tryParse(h['a_gelo']),
              note: h['note']
      );

        }
      }
      return colli;
    });
  }

  Future<bool> setColli(int daily_job, int secco, int murale, int gelo, int a_secco, int a_murale, int a_gelo, String note) async {
    var body = json.encode(
        {"method": "setColli", "daily_job": daily_job, "secco":  secco.toString(), "murale": murale.toString(), "gelo": gelo.toString(), "a_secco": a_secco.toString(), "a_murale": a_murale.toString(), "a_gelo": a_gelo.toString(), "note": note});
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      return res["error"];
    });
  }

  Future<List<Pause>> fetchPause(int id_daily_job, int id_user ) async {
    var body =
    json.encode({"method": "fetchPause", "id_user": id_user, "id_daily_job": id_daily_job});
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      if (globals.logger)  print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      List<Pause> c = new List<Pause>();
      if (res["error_msg"] != "No Breaks") {
        for (var h in res["users"]) {
          Pause pause = new Pause(
              id: int.tryParse(h['id']),
              durata: int.tryParse(h['break_lenght']),
              descrizione: h['break_description'],
          );
          c.add(pause);
        }
      }
      return c;
    });
  }

  Future<bool> setPause(int id_daily_job, String break_description, int break_lenght, int id_user) async {
    var body = json.encode(
        {"method": "setPause", "id": id_daily_job, "descrizione": break_description, "lunghezza": break_lenght, "id_user": id_user});
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      if (globals.logger)  print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      return res["error"];
    });
  }

  Future<bool> removePause(int id) async {
    var body = json.encode(
        {"method": "removePause", "id": id});
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      return res["error"];
    });
  }

  Future<bool> setDataIn(int record, DateTime data) async {
    var x = globals.dataLavori.split('/');
    String data2 = x[2] + '-' + x[0] + '-' + x[1];//'2019-04-23';
    String data3 = data2 + data.toString().substring(10,data.toString().length);

    var body = json.encode(
        {"method": "setDataIn", "datain": data3, "id": record});
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      if (globals.logger)  print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      return res["error"];
    });
  }

  Future<bool> setDataOut(int record, DateTime data) async {
    var x = globals.dataLavori.split('/');
    String data2 = x[2] + '-' + x[0] + '-' + x[1];//'2019-04-23';
    String data3 = data2 + data.toString().substring(10,data.toString().length);
    var body = json.encode(
        {"method": "setDataOut", "dataout": data3, "id": record});
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      return res["error"];
    });
  }
}
