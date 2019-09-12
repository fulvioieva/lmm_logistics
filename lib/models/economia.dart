class Economia {
  int id;
  int idDalilyJob;
  int idUser;
  String dataInizio;
  String dataFine;

  Economia(
      {this.idDalilyJob,
      this.idUser,
      this.id,
      this.dataInizio,
      this.dataFine});

  Economia.map(dynamic obj) {
    this.id = obj["id"];
    this.idDalilyJob = obj["id_daily_job"];
    this.idUser = obj["id_user"];
    this.dataInizio = obj["data_inizio"];
    this.dataFine = obj["data_fine"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["id_daily_job"] = idDalilyJob;
    map["id_user"] = idUser;
    map["data_inizio"] = dataInizio;
    map["data_fine"] = dataFine;

    return map;
  }
}
