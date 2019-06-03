import 'dart:async';
import 'dart:convert';
import 'package:lmm_logistics/utils/network_util.dart';
import 'package:lmm_logistics/models/user.dart';
import 'package:lmm_logistics/utils/globals.dart' as globals;
import 'package:lmm_logistics/models/workers.dart';
import 'package:lmm_logistics/models/pause.dart';
import 'package:lmm_logistics/models/colli.dart';
import 'package:lmm_logistics/models/economia.dart';
import 'package:lmm_logistics/models/working_user.dart';
import 'package:intl/intl.dart';

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
      if (res["error_msg"] != 'Invalid credentitals') {
        for (var h in res["user"]) {
          us = new User(
              username: h['username'], password: h['password'], id: h['id']);
        }
      }
      return us;
    });
  }

  Future<List<Workers>> fetchUsers() async {
    String utente = globals.userId.toString();
    int dj;
    int ids;
    var x = globals.dataLavori.split('/');
    String data = x[2] + '-' + x[0] + '-' + x[1]; //'2019-04-23';
    if (globals.logger) print("Data Lavori " + data);
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
              agenzia: int.tryParse(h['agenzia']),
              id_sito: int.tryParse(h['id_sito']),
              date_start: h['date_start'],
              date_end: h['date_end']);
          dj = int.tryParse(h['id_daily_job']);
          ids = int.tryParse(h['id_sito']);
          c.add(work);
        }
      }
      globals.id_daily_job = dj == null ? 0 : dj;
      globals.siteId = ids == null ? 0 : ids;
      return c;
    });
  }

  Future<Colli> getColli(int id_daily_job) async {
    Colli colli = null;
    var body = json.encode(
        {"method": "getColli", "id_daily_job": id_daily_job.toString()});
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
              pedane: int.tryParse(h['pedane']),
              note: h['note']);
        }
      }
      return colli;
    });
  }

  Future<bool> setColli(int daily_job, int secco, int murale, int gelo,
      int a_secco, int a_murale, int a_gelo, int pedane, String note) async {
    var body = json.encode({
      "method": "setColli",
      "daily_job": daily_job,
      "secco": secco.toString(),
      "murale": murale.toString(),
      "gelo": gelo.toString(),
      "a_secco": a_secco.toString(),
      "a_murale": a_murale.toString(),
      "a_gelo": a_gelo.toString(),
      "pedane": pedane.toString(),
      "note": note
    });
    print(body);
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);

      return res["error"];
    });
  }

  Future<List<Pause>> fetchPause(int id_daily_job, int id_user) async {
    var body = json.encode({
      "method": "fetchPause",
      "id_user": id_user,
      "id_daily_job": id_daily_job
    });
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
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

  Future<bool> setPause(int id_daily_job, String break_description,
      int break_lenght, int id_user) async {
    var body = json.encode({
      "method": "setPause",
      "id": id_daily_job,
      "descrizione": break_description,
      "lunghezza": break_lenght,
      "id_user": id_user
    });
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      return res["error"];
    });
  }

  Future<bool> removePause(int id) async {
    var body = json.encode({"method": "removePause", "id": id});
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      return res["error"];
    });
  }

  Future<bool> setDataIn(int record, String data) async {

    /*
    var now = new DateTime.now();
    var formatter = new DateFormat('MM');
    String mese = formatter.format(now);
    formatter = new DateFormat('yyyy');
    String anno = formatter.format(now);
    formatter = new DateFormat('dd');
    String giorno = formatter.format(now);
    String data2 = anno + '-' + mese + '-' + giorno; //'2019-04-23';
    String data3 = data2 + data;
*/
    var x = globals.dataLavori.split('/');
    if (x[0].length==1)x[0]='0'+x[0];
    if (x[1].length==1)x[1]='0'+x[1];
    String data_fake = x[2] + '-' + x[0] + '-' + x[1] + data;
    String data3;
    if (data==' 00:00'){
      DateTime todayDate = DateTime.parse(data_fake);
      data3 = todayDate.add(new Duration(days: 1)).toString();
      if (globals.logger) print(todayDate.add(new Duration(days: 1)));
    }else {
      if (globals.logger) print(data_fake);
      data3 = data_fake; //'2019-04-23';
    }
    if (globals.logger) print("DATA ->" + data3);
    var body =
        json.encode({"method": "setDataIn", "datain": data3, "id": record});
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      return res["error"];
    });
  }

  Future<bool> setDataOut(int record, String data) async {

    var x = globals.dataLavori.split('/');
    if (x[0].length==1)x[0]='0'+x[0];
    if (x[1].length==1)x[1]='0'+x[1];
    String data_fake = x[2] + '-' + x[0] + '-' + x[1] + data;
    String data3;

    var y = data.split(':');
    if (int.parse(y[0])<12){
      DateTime todayDate = DateTime.parse(data_fake);
      data3 = todayDate.add(new Duration(days: 1)).toString();
      if (globals.logger) print(todayDate.add(new Duration(days: 1)));
    }else{
      if (globals.logger) print(data_fake);
      data3 = data_fake; //'2019-04-23';
    }


    /*
    var now = new DateTime.now();
    var formatter = new DateFormat('MM');
    String mese = formatter.format(now);
    formatter = new DateFormat('yyyy');
    String anno = formatter.format(now);
    formatter = new DateFormat('dd');
    String giorno = formatter.format(now);
    String data2 = anno + '-' + mese + '-' + giorno; //'2019-04-23';
    String data3 = data2 + data;
*/
    //var x = globals.dataLavori.split('/');
    //String data3 = x[2] + '-' + x[0] + '-' + x[1]; //'2019-04-23';

    if (globals.logger) print("DATA ->" + data3);
    var body =
        json.encode({"method": "setDataOut", "dataout": data3, "id": record});
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      return res["error"];
    });
  }

  Future<bool> removeInterinali(int id) async {
    var body = json.encode({"method": "removeInterinali", "id": id});
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      return res["error"];
    });
  }

  Future<List<Workers>> fetchInterinali(int id_daily_job) async {
    var body = json.encode(
        {"method": "fetchInterinali", "id_daily_job": id_daily_job.toString()});
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      List<Workers> c = new List<Workers>();
      if (res["error_msg"] != "No users") {
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
          c.add(work);
        }
      }
      return c;
    });
  }

  Future<bool> setInterinali(
      String first_name, String last_name, int id_daily_job) async {
    var body = json.encode({
      "method": "setInterinali",
      "id_daily_job": id_daily_job.toString(),
      "first_name": first_name,
      "last_name": last_name
    });
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      return res["error"];
    });
  }

  Future<bool> setEconomia(String data_inizio, String data_fine,
      int id_daily_job, int id_user) async {
    var x = globals.dataLavori.split('/');
    String data2 = x[2] + '-' + x[0] + '-' + x[1]; //'2019-04-23';
    //String data3 = data2 + data.toString().substring(10, data.toString().length);
    String di = data_inizio != null ? data_inizio : ' ';
    String df = data_fine != null ? data_fine : ' ';
    String data_inizio_bis = data2 + di;
    String data_fine_bis = data2 + df;
    if (data_inizio == null) data_inizio_bis = '0000-00-00 00:00';
    if (data_fine == null) data_fine_bis = '0000-00-00 00:00';
    if (globals.logger) print("INIZIO ->" + data_inizio_bis);
    if (globals.logger) print("FINE ->" + data_fine_bis);
    if (globals.logger) print("USER ->" + id_user.toString());
    if (globals.logger) print("DJOB ->" + id_daily_job.toString());
    var body = json.encode({
      "method": "setEconomia",
      "id_user": id_user.toString(),
      "id_daily_job": id_daily_job.toString(),
      "data_inizio": data_inizio_bis,
      "data_fine": data_fine_bis
    });
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      return res["error"];
    });
  }

  Future<bool> delEconomia(int id) async {
    var body = json.encode({"method": "delEconomia", "id": id});
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      return res["error"];
    });
  }

  Future<Economia> getEconomia(int id_daily_job, int id_user) async {
    Economia economia = null;
    var body = json.encode({
      "method": "getEconomia",
      "id_daily_job": id_daily_job.toString(),
      "id_user": id_user.toString()
    });
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      if (res["error_msg"] != "No ore economia") {
        for (var h in res["economia"]) {
          economia = new Economia(
              id: int.tryParse(h['id']),
              id_daily_job: int.tryParse(h['id_daily_job']),
              id_user: int.tryParse(h['id_user']),
              data_inizio: h['data_inizio'],
              data_fine: h['data_fine']);
        }
      }
      return economia;
    });
  }

  Future<List<WorkingUsers>> getUserAgenzia(int id_daily_job) async {
    List<WorkingUsers> users = new List<WorkingUsers>();
    var body = json.encode({"method": "getUserAgenzia","id_daily_job": id_daily_job.toString()});
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      if (res["error_msg"] != "No users") {
        for (var h in res["users"]) {
          WorkingUsers user = new WorkingUsers(
              id: int.tryParse(h['id']),
              first_name: h['first_name'],
              last_name: h['last_name']);
          users.add(user);
        }
      }
      return users;
    });
  }

  Future<String> getEconomiaTot(int id_daily_job) async {
    String economia = null;
    var body = json.encode(
        {"method": "getEconomiaTot", "id_daily_job": id_daily_job.toString()});
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      if (res["error_msg"] != "No economia to measure") {
        for (var h in res["timediff"]) {
          economia = h['timediff'];
        }
      }
      return economia;
    });
  }

  Future<String> getTotaleColli(int id_daily_job) async {
    String quantita = null;
    var body = json.encode(
        {"method": "getTotaleColli", "id_daily_job": id_daily_job.toString()});
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      if (res["error_msg"] != "No qty to measure") {
        for (var h in res["totale"]) {
          quantita = h['totale'];
        }
      }
      return quantita;
    });
  }

  Future<String> getTotaleColliMese(
      int id_user, String mese, String anno) async {
    String quantita = null;
    var body = json.encode({
      "method": "getTotaleColliMese",
      "id_user": id_user.toString(),
      "mese": mese,
      "anno": anno
    });
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      if (globals.logger) print("id  ->" + id_user.toString());
      if (globals.logger) print("mese ->" + mese);
      if (globals.logger) print("anno ->" + anno);
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      if (res["error_msg"] != "No qty to measure") {
        for (var h in res["totale"]) {
          quantita = h['totale'];
        }
      }
      return quantita;
    });
  }

  Future<String> getTotaleColliMesexsito(
      int id_site, String mese, String anno) async {
    String quantita = null;
    var body = json.encode({
      "method": "getTotaleColliMesexsito",
      "id_site": id_site.toString(),
      "mese": mese,
      "anno": anno
    });
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      if (globals.logger) print("id  ->" + id_site.toString());
      if (globals.logger) print("mese ->" + mese);
      if (globals.logger) print("anno ->" + anno);
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      if (res["error_msg"] != "No qty to measure") {
        for (var h in res["totale"]) {
          quantita = h['totale'];
        }
      }
      return quantita;
    });
  }

  Future<String> getTotalePersone(int id_daily_job) async {
    String quantita = null;
    var body = json.encode({
      "method": "getTotalePersone",
      "id_daily_job": id_daily_job.toString()
    });
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      if (res["error_msg"] != "No persons") {
        for (var h in res["persone"]) {
          quantita = h['persone'];
        }
      }
      return quantita;
    });
  }

  Future<String> getTotaleOre(int id_daily_job) async {
    String quantita = "0";
    var body = json.encode(
        {"method": "getTotaleOre", "id_daily_job": id_daily_job.toString()});
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      if (res["error_msg"] != "No ore") {
        for (var h in res["ore"]) {
          quantita = h['ore'];
        }
      }
      return quantita;
    });
  }

  Future<bool> setDailyJob(int id_daily_job, int id_user) async {
    var body = json.encode({
      "method": "setDailyJob",
      "id_daily_job": id_daily_job.toString(),
      "id_user": id_user.toString()
    });
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      return res["error"];
    });
  }

  Future<String> getTotaleOreMese(int id_user, String mese, String anno) async {
    String ore = '0.0';
    var body = json.encode({
      "method": "getTotaleOreMese",
      "id_user": id_user.toString(),
      "mese": mese,
      "anno": anno
    });
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      if (globals.logger) print("id  ->" + id_user.toString());
      if (globals.logger) print("mese ->" + mese);
      if (globals.logger) print("anno ->" + anno);
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      if (res["error_msg"] != "No ore") {
        for (var h in res["ore"]) {
          ore = h['ore'];
        }
      }
      return ore;
    });
  }

  Future<String> getTotaleOreMesexsito(int id_site, String mese, String anno) async {
    String ore = '0.0';
    var body = json.encode({
      "method": "getTotaleOreMesexsito",
      "id_site": id_site.toString(),
      "mese": mese,
      "anno": anno
    });
    return _netUtil.post(LOGIN_URL, body: body).then((dynamic res) {
      if (globals.logger) print("id  ->" + id_site.toString());
      if (globals.logger) print("mese ->" + mese);
      if (globals.logger) print("anno ->" + anno);
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      if (res["error_msg"] != "No ore") {
        for (var h in res["ore"]) {
          ore = h['ore'];
        }
      }
      return ore;
    });
  }


}
