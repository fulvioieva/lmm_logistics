class EconomiaV2 {
  int id;
  int idDalilyJob;
  int normali;
  int festive;
  int notturne;

  EconomiaV2(
      {this.id, this.idDalilyJob, this.normali, this.festive, this.notturne});

  EconomiaV2.map(dynamic obj) {
    this.id = obj["id"];
    this.idDalilyJob = obj["id_daily_job"];
    this.normali = obj["normali"];
    this.festive = obj["festive"];
    this.notturne = obj["notturne"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["id_daily_job"] = idDalilyJob;
    map["normali"] = normali;
    map["festive"] = festive;
    map["notturne"] = notturne;

    return map;
  }
}
