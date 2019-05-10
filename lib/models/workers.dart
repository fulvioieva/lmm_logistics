class Workers {
  int id;
  String first_name;
  String last_name;
  int work_day;
  int id_sito;
  String date_start;
  String date_end;

  Workers({ this.id,
            this.first_name,
            this.last_name,
            this.work_day,
            this.id_sito,
            this.date_start,
            this.date_end
  });


  Workers.map(dynamic obj) {
    this.id = obj["id"];
    this.first_name = obj["first_name"];
    this.last_name = obj["last_name"];
    this.work_day = obj["work_day"];
    this.id_sito = obj["id_sito"];
    this.date_start = obj["date_start"];
    this.date_end = obj["date_end"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["first_name"] = first_name;
    map["last_name"] = last_name;
    map["work_day"] = work_day;
    map["id_sito"] = id_sito;
    map["date_start"] = date_start;
    map["date_end"] = date_end;

    return map;
  }

  factory Workers.fromJson(Map<String, dynamic> json) {
    return Workers(
      id: json['id'] as int,
      first_name: json['first_name'] as String,
      last_name: json['last_name'] as String,
      work_day: json['work_day'] as int,
      id_sito: json['id_sito'] as int,
      date_start: json['date_start'] as String,
      date_end: json['date_end'] as String,

    );
  }



}