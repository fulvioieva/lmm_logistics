class Colli {
  int id;
  int idDailyWork;
  int secco;
  int murale;
  int gelo;
  int aSecco;
  int aMurale;
  int aGelo;
  int pedane;
  String note;

  Colli({ this.id,
            this.idDailyWork,
            this.secco,
            this.murale,
            this.gelo,
            this.aSecco,
            this.aMurale,
            this.aGelo,
            this.pedane,
            this.note
  });


  Colli.map(dynamic obj) {
    this.id = obj["id"];
    this.idDailyWork = obj["id_daily_work"];
    this.secco = obj["secco"];
    this.murale = obj["murale"];
    this.gelo = obj["gelo"];
    this.aSecco = obj["a_secco"];
    this.aGelo = obj["a_gelo"];
    this.aMurale = obj["a_murale"];
    this.pedane = obj["pedane"];
    this.note = obj["note"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["id_daily_work"] = idDailyWork;
    map["secco"] = secco;
    map["murale"] = murale;
    map["gelo"] = gelo;
    map["a_secco"] = aSecco;
    map["a_gelo"] = aGelo;
    map["a_murale"] = aMurale;
    map["pedane"] = pedane;
    map["note"] = note;

    return map;
  }




}