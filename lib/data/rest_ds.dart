import 'dart:async';
import 'dart:convert';
import 'package:lmm_logistics/data/database_helper.dart';
import 'package:lmm_logistics/models/economiaV2.dart';
import 'package:lmm_logistics/utils/network_util.dart';
import 'package:lmm_logistics/models/user.dart';
import 'package:lmm_logistics/utils/globals.dart' as globals;
import 'package:lmm_logistics/models/workers.dart';
import 'package:lmm_logistics/models/pause.dart';
import 'package:lmm_logistics/models/colli.dart';
import 'package:lmm_logistics/models/economia.dart';
import 'package:lmm_logistics/models/site.dart';
import 'package:lmm_logistics/models/working_user.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final loginURL = globals.loginUrl;

  Future<User> login(String username, String password) async {
    try {
      var body =
          json.encode({"method": "login", "user": username, "pass": password});
      return _netUtil.post(loginURL, body: body).then((dynamic res) {
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
    } catch (ex) {
      return null;
    }
  }

  Future<List<Workers>> fetchUsersEvol() async {
    String utente = globals.userId.toString();
    int dj;
    var x = globals.dataLavori.split('/');
    var sito = globals.siteId;
    String data = x[2] + '-' + x[0] + '-' + x[1]; //'2019-04-23';
    if (globals.logger) print("Data Lavori " + data);
    if (globals.logger) print("utente " + utente);
    if (globals.logger) print("sito " + sito.toString());
    var body = json.encode({
      "method": "fetchUsersEvol",
      "data": data,
      "utente": utente,
      "sito": sito.toString()
    });
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      List<Workers> c = new List<Workers>();
      if (res["error_msg"] != "No user") {
        for (var h in res["users"]) {
          /*Workers work = new Workers(
              id: int.tryParse(h['id']),
              firstName: h['first_name'],
              lastName: h['last_name'],
              idDailyJob: int.tryParse(h['id_daily_job']),
              workId: int.tryParse(h['work_id']),
              agenzia: int.tryParse(h['agenzia']),
              idSito: int.tryParse(h['id_sito']),
              dateStart: h['date_start'],
              dateEnd: h['date_end']);*/
          Workers work = Workers.map(h);
          dj = int.tryParse(h['id_daily_job']);
          c.add(work);
        }
      }
      globals.idDailyJob = dj == null ? 0 : dj;
      //globals.siteId = ids == null ? 0 : ids;
      return c;
    });
  }

  Future<List<Workers>> fetchUsers() async {
    String utente = globals.userId.toString();
    int dj;
    var x = globals.dataLavori.split('/');
    var sito = globals.siteId;
    String data = x[2] + '-' + x[0] + '-' + x[1]; //'2019-04-23';
    if (globals.logger) print("Data Lavori " + data);
    if (globals.logger) print("utente " + utente);
    if (globals.logger) print("sito " + sito.toString());
    var body = json.encode({
      "method": "fetchUsers",
      "data": data,
      "utente": utente,
      "sito": sito.toString()
    });
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      List<Workers> c = new List<Workers>();
      if (res["error_msg"] != "No user") {
        for (var h in res["users"]) {
          Workers work = new Workers(
              id: int.tryParse(h['id']),
              firstName: h['first_name'],
              lastName: h['last_name'],
              idDailyJob: int.tryParse(h['id_daily_job']),
              workId: int.tryParse(h['work_id']),
              agenzia: int.tryParse(h['agenzia']),
              idSito: int.tryParse(h['id_sito']),
              dateStart: h['date_start'],
              dateEnd: h['date_end']);
          dj = int.tryParse(h['id_daily_job']);
          c.add(work);
        }
      }
      globals.idDailyJob = dj == null ? 0 : dj;
      //globals.siteId = ids == null ? 0 : ids;
      return c;
    });
  }

  Future<Colli> getColli(int idDailyJob) async {
    Colli colli;
    var body = json
        .encode({"method": "getColli", "id_daily_job": idDailyJob.toString()});
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      if (res["error_msg"] != "No colli") {
        for (var h in res["colli"]) {
          colli = new Colli(
              id: int.tryParse(h['id']),
              secco: int.tryParse(h['secco']),
              murale: int.tryParse(h['murale']),
              gelo: int.tryParse(h['gelo']),
              aSecco: int.tryParse(h['a_secco']),
              aMurale: int.tryParse(h['a_murale']),
              aGelo: int.tryParse(h['a_gelo']),
              pedane: int.tryParse(h['pedane']),
              note: h['note']);
        }
      }
      return colli;
    });
  }

  Future<bool> setColli(int dailyJob, int secco, int murale, int gelo,
      int aSecco, int aMurale, int aGelo, int pedane, String note) async {
    var body = json.encode({
      "method": "setColli",
      "daily_job": dailyJob,
      "secco": secco.toString(),
      "murale": murale.toString(),
      "gelo": gelo.toString(),
      "a_secco": aSecco.toString(),
      "a_murale": aMurale.toString(),
      "a_gelo": aGelo.toString(),
      "pedane": pedane.toString(),
      "note": note
    });
    print(body);
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);

      return res["error"];
    });
  }

  Future<List<Pause>> fetchPause(int idDailyJob, int idUser) async {
    var body = json.encode({
      "method": "fetchPause",
      "id_user": idUser,
      "id_daily_job": idDailyJob
    });
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
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

  Future<bool> setPause(int idDailyJob, String breakDescription,
      int breakLenght, int idUser) async {
    var body = json.encode({
      "method": "setPause",
      "id": idDailyJob,
      "descrizione": breakDescription,
      "lunghezza": breakLenght,
      "id_user": idUser
    });
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      return res["error"];
    });
  }

  Future<bool> removePause(int id) async {
    var body = json.encode({"method": "removePause", "id": id});
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
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
    if (x[0].length == 1) x[0] = '0' + x[0];
    if (x[1].length == 1) x[1] = '0' + x[1];
    String dataFake = x[2] + '-' + x[0] + '-' + x[1] + data;
    String data3;
    var y = data.split(':');
    if (int.parse(y[0]) < 3) {
      DateTime todayDate = DateTime.parse(dataFake);
      data3 = todayDate.add(new Duration(days: 1)).toString();
      if (globals.logger) print(todayDate.add(new Duration(days: 1)));
    } else {
      if (globals.logger) print(dataFake);
      data3 = dataFake; //'2019-04-23';
    }
    if (globals.logger) print("DATA ->" + data3);
    var body =
        json.encode({"method": "setDataIn", "datain": data3, "id": record});
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      return res["error"];
    });
  }

  Future<bool> setDataOut(int record, String data) async {
    List<Workers> lw = await getDailyJob(record);

    var x = globals.dataLavori.split('/');
    if (x[0].length == 1) x[0] = '0' + x[0];
    if (x[1].length == 1) x[1] = '0' + x[1];
    String dataFake = x[2] + '-' + x[0] + '-' + x[1] + data;
    String data3;

    var y = data.split(':');
    if (int.parse(y[0]) < 12) {
      DateTime todayDate = DateTime.parse(dataFake);
      data3 = todayDate.add(new Duration(hours: 24)).toString();
      if (globals.logger) print(todayDate.add(new Duration(days: 1)));
    } else {
      if (globals.logger) print(dataFake);
      data3 = dataFake; //'2019-04-23';
    }
    DateTime dateout = DateTime.parse(data3);
    DateTime datein = DateTime.parse(lw[0].dateStart);
    double difference = dateout.difference(datein).inHours.toDouble();
    if (globals.logger) print("DIFFERENZA " + difference.toString());

    if (difference > 23.0) {
      data3 = dateout.add(new Duration(hours: -24)).toString();
    }
    //print ("Differenza " + difference.toString());
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
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      return res["error"];
    });
  }

  Future<bool> removeInterinali(int id) async {
    var body = json.encode({"method": "removeInterinali", "id": id});
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      return res["error"];
    });
  }

  Future<List<Workers>> fetchInterinali(int idDailyJob) async {
    var body = json.encode(
        {"method": "fetchInterinali", "id_daily_job": idDailyJob.toString()});
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      List<Workers> c = new List<Workers>();
      if (res["error_msg"] != "No users") {
        for (var h in res["users"]) {
          Workers work = new Workers(
              id: int.tryParse(h['id']),
              firstName: h['first_name'],
              lastName: h['last_name'],
              idDailyJob: int.tryParse(h['id_daily_job']),
              workId: int.tryParse(h['work_id']),
              idSito: int.tryParse(h['id_sito']),
              dateStart: h['date_start'],
              dateEnd: h['date_end']);
          c.add(work);
        }
      }
      return c;
    });
  }

  Future<bool> setInterinali(
      String firstName, String lastName, int idDailyJob) async {
    var body = json.encode({
      "method": "setInterinali",
      "id_daily_job": idDailyJob.toString(),
      "first_name": firstName,
      "last_name": lastName
    });
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      return res["error"];
    });
  }

  Future<bool> setEconomia(
      String dataInizio, String dataFine, int idDailyJob, int idUser) async {
    var x = globals.dataLavori.split('/');
    String data2 = x[2] + '-' + x[0] + '-' + x[1]; //'2019-04-23';
    //String data3 = data2 + data.toString().substring(10, data.toString().length);
    String di = dataInizio != null ? dataInizio : ' ';
    String df = dataFine != null ? dataFine : ' ';
    String dataInizioBis = data2 + di;
    String dataFineBis = data2 + df;
    if (dataInizio == null) dataInizioBis = '0000-00-00 00:00';
    if (dataFine == null) dataFineBis = '0000-00-00 00:00';
    if (globals.logger) print("INIZIO ->" + dataInizioBis);
    if (globals.logger) print("FINE ->" + dataFineBis);
    if (globals.logger) print("USER ->" + idUser.toString());
    if (globals.logger) print("DJOB ->" + idDailyJob.toString());
    var body = json.encode({
      "method": "setEconomia",
      "id_user": idUser.toString(),
      "id_daily_job": idDailyJob.toString(),
      "data_inizio": dataInizioBis,
      "data_fine": dataFineBis
    });
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      return res["error"];
    });
  }

  Future<bool> delEconomia(int id) async {
    var body = json.encode({"method": "delEconomia", "id": id});
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      return res["error"];
    });
  }

  Future<Economia> getEconomia(int idDailyJob, int idUser) async {
    Economia economia;
    var body = json.encode({
      "method": "getEconomia",
      "id_daily_job": idDailyJob.toString(),
      "id_user": idUser.toString()
    });
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      if (res["error_msg"] != "No ore economia") {
        for (var h in res["economia"]) {
          economia = new Economia(
              id: int.tryParse(h['id']),
              idDalilyJob: int.tryParse(h['id_daily_job']),
              idUser: int.tryParse(h['id_user']),
              dataInizio: h['data_inizio'],
              dataFine: h['data_fine']);
        }
      }
      return economia;
    });
  }

  Future<List<WorkingUsers>> getUserAgenzia(int idDailyJob) async {
    List<WorkingUsers> users = new List<WorkingUsers>();
    var body = json.encode(
        {"method": "getUserAgenzia", "id_daily_job": idDailyJob.toString()});
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
      print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      if (res["error_msg"] != "No users") {
        for (var h in res["users"]) {
          WorkingUsers user = new WorkingUsers(
              id: int.tryParse(h['id']),
              firstName: h['first_name'],
              lastName: h['last_name']);
          users.add(user);
        }
      }
      return users;
    });
  }

  Future<String> getEconomiaTot(int idDailyJob) async {
    String economia;
    var body = json.encode(
        {"method": "getEconomiaTot", "id_daily_job": idDailyJob.toString()});
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
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

  Future<String> getTotaleColli(int idDailyJob) async {
    String quantita;
    var body = json.encode(
        {"method": "getTotaleColli", "id_daily_job": idDailyJob.toString()});
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
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
      int idUser, String mese, String anno) async {
    String quantita;
    var body = json.encode({
      "method": "getTotaleColliMese",
      "id_user": idUser.toString(),
      "mese": mese,
      "anno": anno
    });
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
      if (globals.logger) print("id  ->" + idUser.toString());
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
      int idSite, String mese, String anno) async {
    String quantita;
    var body = json.encode({
      "method": "getTotaleColliMesexsito",
      "id_site": idSite.toString(),
      "mese": mese,
      "anno": anno
    });
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
      if (globals.logger) print("id  ->" + idSite.toString());
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

  Future<String> getTotalePersone(int idDailyJob) async {
    String quantita;
    var body = json.encode(
        {"method": "getTotalePersone", "id_daily_job": idDailyJob.toString()});
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
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

  Future<String> getTotaleOre(int idDailyJob) async {
    String quantita = "0";
    var body = json.encode(
        {"method": "getTotaleOre", "id_daily_job": idDailyJob.toString()});
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
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

  Future<bool> setDailyJob(int idDailyJob, int idUser) async {
    var body = json.encode({
      "method": "setDailyJob",
      "id_daily_job": idDailyJob.toString(),
      "id_user": idUser.toString()
    });
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      return res["error"];
    });
  }

  Future<String> getTotaleOreMese(int idUser, String mese, String anno) async {
    String ore = '0.0';
    var body = json.encode({
      "method": "getTotaleOreMese",
      "id_user": idUser.toString(),
      "mese": mese,
      "anno": anno
    });
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
      if (globals.logger) print("id  ->" + idUser.toString());
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

  Future<String> getTotaleOreMesexsito(
      int idSite, String mese, String anno) async {
    String ore = '0.0';
    var body = json.encode({
      "method": "getTotaleOreMesexsito",
      "id_site": idSite.toString(),
      "mese": mese,
      "anno": anno
    });
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
      if (globals.logger) print("id  ->" + idSite.toString());
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

  Future<List<Site>> getSitiEvol(int idUser, String date) async {
    List<Site> siti = new List<Site>();
    var body = json.encode(
        {"method": "getSitiEvol", "id_user": idUser.toString(), "date": date});
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
      if (globals.logger) print("Call getSitiEvol");
      if (globals.logger) print("JSON ->" + res.toString());
      if (globals.logger) print("DATE ->" + date);
      if (globals.logger) print("USER ->" + idUser.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      if (res["error_msg"] != "No siti") {
        for (var h in res["siti"]) {
          Site sito = new Site(
              id: int.tryParse(h['id']),
              ragSoc: int.tryParse(h['rag_soc']),
              siteName: h['site_name'],
              insegna: h['insegna'],
              citta: h['citta'],
              provincia: h['provincia'],
              indirizzo: h['indirizzo']);
          siti.add(sito);
        }
      }
      return siti;
    });
  }

  Future<List<Site>> getSiti(int idUser, String date) async {
    List<Site> siti = new List<Site>();
    var body = json.encode(
        {"method": "getSiti", "id_user": idUser.toString(), "date": date});
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (globals.logger) print("DATE ->" + date);
      if (globals.logger) print("USER ->" + idUser.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      if (res["error_msg"] != "No siti") {
        for (var h in res["siti"]) {
          Site sito = new Site(
              id: int.tryParse(h['id']),
              ragSoc: int.tryParse(h['rag_soc']),
              siteName: h['site_name'],
              insegna: h['insegna'],
              citta: h['citta'],
              provincia: h['provincia'],
              indirizzo: h['indirizzo']);
          siti.add(sito);
        }
      }
      return siti;
    });
  }

  Future<bool> resetUtente(int id) async {
    var body = json.encode({"method": "resetUtente", "id": id});
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      return res["error"];
    });
  }

  Future<bool> resetEconomia(int idUser, int idDailyJob) async {
    var body = json.encode({
      "method": "resetEconomia",
      "id_user": idUser,
      "id_daily_job": idDailyJob
    });
    if (globals.logger) print("JOB  ->" + idDailyJob.toString());
    if (globals.logger) print("USER ->" + idUser.toString());
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      return res["error"];
    });
  }

  Future<String> getPercentuale(int id) async {
    String percentuale = "0";
    var body = json.encode({"method": "getPercentuale", "id": id.toString()});
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      if (res["error_msg"] != "No site") {
        for (var h in res["perc"]) {
          percentuale = h['perc'];
        }
      }
      return percentuale;
    });
  }

  Future<List<Workers>> getDailyJob(int id) async {
    int dj;
    var x = globals.dataLavori.split('/');
    String data = x[2] + '-' + x[0] + '-' + x[1]; //'2019-04-23';
    if (globals.logger) print("Data Lavori " + data);
    var body = json.encode({"method": "getDailyJob", "id": id.toString()});
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      List<Workers> c = new List<Workers>();
      if (res["error_msg"] != "No user") {
        for (var h in res["users"]) {
          Workers work = new Workers(
              id: int.tryParse(h['id']),
              firstName: h['first_name'],
              lastName: h['last_name'],
              idDailyJob: int.tryParse(h['id_daily_job']),
              workId: int.tryParse(h['work_id']),
              agenzia: int.tryParse(h['agenzia']),
              idSito: int.tryParse(h['id_sito']),
              dateStart: h['date_start'],
              dateEnd: h['date_end']);
          dj = int.tryParse(h['id_daily_job']);
          c.add(work);
        }
      }
      globals.idDailyJob = dj == null ? 0 : dj;
      //globals.siteId = ids == null ? 0 : ids;
      return c;
    });
  }

  Future<String> changePassword(String oldPassword, String newPassword) async {
    DatabaseHelper db = new DatabaseHelper();
    User user = await db.getUser(globals.userId);
    if (user.password == oldPassword) {
      var body = json.encode({
        "method": "setpassword",
        "user": user.username,
        "newpass": newPassword,
        "oldpass": oldPassword
      });
      if (newPassword != user.password) {
        return _netUtil.post(loginURL, body: body).then((dynamic response) {
          user.password = newPassword;
          db.changePassword(user);
          return Future.value("200");
        }).catchError((onError) {
          print(onError);
          return Future.value("403");
        });
      } else {
        return Future.value("406");
      }
    } else {
      return Future.value("400");
    }
  }

  Future<bool> setInizioOraList(List<int> listId, String data) async {
    var x = globals.dataLavori.split('/');
    if (x[0].length == 1) x[0] = '0' + x[0];
    if (x[1].length == 1) x[1] = '0' + x[1];
    String dataFake = x[2] + '-' + x[0] + '-' + x[1] + " $data";
    String data3;
    var y = data.split(':');
    if (int.parse(y[0]) < 3) {
      DateTime todayDate = DateTime.parse(dataFake);
      data3 = todayDate.add(new Duration(days: 1)).toString();
      if (globals.logger) print(todayDate.add(new Duration(days: 1)));
    } else {
      if (globals.logger) print(dataFake);
      data3 = dataFake; //'2019-04-23';
    }
    if (globals.logger) print("DATA ->" + data3);
    var body = json.encode(
        {"method": "setDataIn", "datain": data3, "id": listId.join(',')});
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      return res["error"];
    });
  }

  Future<bool> setFineOraList(List<int> listId, String data) async {
    List<Workers> lw = await getDailyJob(listId[0]);

    var x = globals.dataLavori.split('/');
    if (x[0].length == 1) x[0] = '0' + x[0];
    if (x[1].length == 1) x[1] = '0' + x[1];
    String dataFake = x[2] + '-' + x[0] + '-' + x[1] + " $data";
    String data3;

    var y = data.split(':');
    if (int.parse(y[0]) < 12) {
      DateTime todayDate = DateTime.parse(dataFake);
      data3 = todayDate.add(new Duration(days: 1)).toString();
      if (globals.logger) print(todayDate.add(new Duration(days: 1)));
    } else {
      if (globals.logger) print(dataFake);
      data3 = dataFake; //'2019-04-23';
    }
    DateTime dateout = DateTime.parse(data3);
    DateTime datein = DateTime.parse(lw[0].dateStart);
    double difference = dateout.difference(datein).inHours.toDouble();
    if (globals.logger) print("DIFFERENZA " + difference.toString());

    if (difference > 23.0) {
      data3 = dateout.add(new Duration(days: -1)).toString();
    }
    //print ("Differenza " + difference.toString());
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
    var body = json.encode(
        {"method": "setDataOut", "dataout": data3, "id": listId.join(",")});
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      return res["error"];
    });
  }

  Future<bool> setPauseGroup(String lunghezza, List<int> idList) {
    var body = json.encode({
      "method": "setPause",
      "id": globals.idDailyJob,
      "descrizione": "Pausa Generica",
      "lunghezza": lunghezza,
      "id_user": idList.join(",")
    });

    return _netUtil.post(loginURL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      return res["error"];
    });
  }

  Future<EconomiaV2> fetchOreEconomia() {
    EconomiaV2 economiaV2;
    var body = json.encode(
        {"method": "fetchOreEconomia", "id_daily_job": globals.idDailyJob});
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      if (res["error_msg"] == "No ore") {
        return economiaV2 = new EconomiaV2(
            idDalilyJob: globals.idDailyJob,
            normali: 0,
            festive: 0,
            notturne: 0);
      }
      for (var h in res["ore"]) {
        economiaV2 = new EconomiaV2(
            id: int.tryParse(h['id']),
            idDalilyJob: int.tryParse(h['id_daily_job']),
            normali: int.tryParse(h['normali']),
            festive: int.tryParse(h['festive']),
            notturne: int.tryParse(h['notturne']));
      }

      return economiaV2;
    });
  }

  Future<bool> setOreEconomia(int normali, int festive, int notturne) {
    var body = json.encode({
      "method": "setOreEconomia",
      "id_daily_job": globals.idDailyJob,
      "normali": normali == 0 ? "*" : normali.toString(),
      "festive": festive == 0 ? "*" : festive.toString(),
      "notturne": notturne == 0 ? "*" : notturne.toString()
    });
    print(body);
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      print(res);
      return res["error"];
    });
  }

  Future<bool> deleteEconomia() {
    var body = json.encode(
        {"method": "delOreEconomia", "id_daily_job": globals.idDailyJob});
    return _netUtil.post(loginURL, body: body).then((dynamic res) {
      if (globals.logger) print("JSON ->" + res.toString());
      if (res["error"] == "true") throw new Exception(res["error_msg"]);
      print(res);
      return res["error"];
    });
  }
}
