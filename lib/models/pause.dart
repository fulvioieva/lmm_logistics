class Pause {
  int id;
  int durata;
  String descrizione;
  Pause({this.durata, this.descrizione, this.id});

  Pause.map(dynamic obj) {
    this.durata = obj["durata"];
    this.descrizione = obj["descrizione"];
    this.id = obj["id"];

  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["durata"] = durata;
    map["descrizione"] = descrizione;

    return map;
  }
}