import 'dart:async';
import 'dart:convert';
import 'package:lmm_logistics/utils/network_util.dart';
import 'package:lmm_logistics/models/user.dart';
import 'package:lmm_logistics/utils/globals.dart' as globals;
import 'package:lmm_logistics/models/workers.dart';
import 'package:lmm_logistics/models/pause.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final LOGIN_URL = globals.loginUrl;

  Future<User> login(String username, String password) async {
    var body =
        json.encode({"method": "login", "user": username, "pass": password});
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      User us;
      for (var h in res["user"]) {
        us = new User(
            username: h['username'],
            password: h['password'],
            id: int.tryParse(h['id']));
      }
      return us;
    });
  }

  Future<List<Workers>> fetchUsers() async {
    String utente = globals.userId.toString();
    String data = '2019-04-23';
    var body =
        json.encode({"method": "getUtenti", "data": data, "utente": utente});
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      List<Workers> c = new List<Workers>();
      if (res["error_msg"] != "No user") {
        for (var h in res["users"]) {
          Workers work = new Workers(
              id: int.tryParse(h['id']),
              first_name: h['first_name'],
              last_name: h['last_name'],
              work_day: int.tryParse(h['work_day']),
              id_sito: int.tryParse(h['id_sito']),
              date_start: h['date_start'],
              date_end: h['date_end']);

          c.add(work);
        }
      }
      return c;
    });
  }

  Future<List<Pause>> fetchPause(int id_daily_job, int id_user ) async {
    var body =
    json.encode({"method": "fetchPause", "id_user": id_user, "id_daily_job": id_daily_job});
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      print("JSON ->" + res.toString());
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
        {"method": "setPause", "id_daily_job": id_daily_job, "break_description": break_description, "break_description": break_description, "break_lenght": break_lenght, "id_user": id_user});
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      return res["error"];
    });
  }

  Future<bool> removePause(int id) async {
    var body = json.encode(
        {"method": "removePause", "id": id});
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      return res["error"];
    });
  }

  Future<bool> setDataIn(int record, DateTime data) async {
    var body = json.encode(
        {"method": "setDataIn", "datain": data.toString(), "id": record});
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      return res["error"];
    });
  }

  Future<bool> setDataOut(int record, DateTime data) async {
    var body = json.encode(
        {"method": "setDataOut", "dataout": data.toString(), "id": record});
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      return res["error"];
    });
  }
}
