class Economia {
  int id;
  int id_daily_job;
  int id_user;
  String data_inizio;
  String data_fine;

  Economia(
      {this.id_daily_job,
      this.id_user,
      this.id,
      this.data_inizio,
      this.data_fine});

  Economia.map(dynamic obj) {
    this.id = obj["id"];
    this.id_daily_job = obj["id_daily_job"];
    this.id_user = obj["id_user"];
    this.data_inizio = obj["data_inizio"];
    this.data_fine = obj["data_fine"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["id_daily_job"] = id_daily_job;
    map["id_user"] = id_user;
    map["data_inizio"] = data_inizio;
    map["data_fine"] = data_fine;

    return map;
  }
}
