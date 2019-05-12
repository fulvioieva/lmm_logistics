class Workers {
  int id;
  String first_name;
  String last_name;
  int id_daily_job;
  int id_sito;
  int work_id;
  String date_start;
  String date_end;

  Workers({ this.id,
            this.first_name,
            this.last_name,
            this.id_daily_job,
            this.id_sito,
            this.work_id,
            this.date_start,
            this.date_end
  });


  Workers.map(dynamic obj) {
    this.id = obj["id"];
    this.first_name = obj["first_name"];
    this.last_name = obj["last_name"];
    this.id_daily_job = obj["id_daily_job"];
    this.id_sito = obj["id_sito"];
    this.work_id = obj["work_id"];
    this.date_start = obj["date_start"];
    this.date_end = obj["date_end"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["first_name"] = first_name;
    map["last_name"] = last_name;
    map["id_daily_job"] = id_daily_job;
    map["id_sito"] = id_sito;
    map["work_id"] = work_id;
    map["date_start"] = date_start;
    map["date_end"] = date_end;

    return map;
  }

}