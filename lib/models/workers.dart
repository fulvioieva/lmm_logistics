class Workers {
  int id;
  String firstName;
  String lastName;
  int idDailyJob;
  int idSito;
  int workId;
  int agenzia;
  String dateStart;
  String dateEnd;
  int pause;

  Workers({ this.id,
            this.firstName,
            this.lastName,
            this.idDailyJob,
            this.idSito,
            this.workId,
            this.agenzia,
            this.dateStart,
            this.dateEnd,
            this.pause
  });


  Workers.map(dynamic obj) {
    this.id = int.tryParse(obj["id"]);
    this.firstName = obj["first_name"];
    this.lastName = obj["last_name"];
    this.idDailyJob = int.tryParse(obj["id_daily_job"]);
    this.idSito = int.tryParse(obj["id_sito"]);
    this.workId = int.tryParse(obj["work_id"]);
    this.agenzia = int.tryParse(obj["agenzia"]);
    this.dateStart = obj["date_start"];
    this.dateEnd = obj["date_end"];
    this.pause = int.tryParse(obj["pause"]);
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["first_name"] = firstName;
    map["last_name"] = lastName;
    map["id_daily_job"] = idDailyJob;
    map["id_sito"] = idSito;
    map["work_id"] = workId;
    map["agenzia"] = agenzia;
    map["date_start"] = dateStart;
    map["date_end"] = dateEnd;
    map["pause"] = pause;

    return map;
  }

}