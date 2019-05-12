class Colli {
  int id;
  int id_daily_work;
  int secco;
  int murale;
  int gelo;
  int a_secco;
  int a_murale;
  int a_gelo;
  String note;

  Colli({ this.id,
            this.id_daily_work,
            this.secco,
            this.murale,
            this.gelo,
            this.a_secco,
            this.a_murale,
            this.a_gelo,
            this.note
  });


  Colli.map(dynamic obj) {
    this.id = obj["id"];
    this.id_daily_work = obj["id_daily_work"];
    this.secco = obj["secco"];
    this.murale = obj["murale"];
    this.gelo = obj["gelo"];
    this.a_secco = obj["a_secco"];
    this.a_gelo = obj["a_gelo"];
    this.a_murale = obj["a_murale"];
    this.note = obj["note"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["id_daily_work"] = id_daily_work;
    map["secco"] = secco;
    map["murale"] = murale;
    map["gelo"] = gelo;
    map["a_secco"] = a_secco;
    map["a_gelo"] = a_gelo;
    map["a_murale"] = a_murale;
    map["note"] = note;

    return map;
  }




}