class Site {
  int id;
  int rag_soc;
  String insegna;
  String citta;
  String provincia;
  String indirizzo;
  Site({this.insegna, this.rag_soc, this.id, this.citta, this.provincia, this.indirizzo});

  Site.map(dynamic obj) {
    this.insegna = obj["insegna"];
    this.rag_soc = obj["rag_soc"];
    this.citta = obj["citta"];
    this.provincia = obj["provincia"];
    this.indirizzo = obj["indirizzo"];
    this.id = obj["id"];

  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["indirizzo"] = indirizzo;
    map["provincia"] = provincia;
    map["citta"] = citta;
    map["rag_soc"] = rag_soc;
    map["insegna"] = insegna;
    return map;
  }

  String getDescription(){
    String a =  this.insegna+ ' ' + this.citta + ' (' + this.provincia + ')';
    if (a.length>25) a = a.substring(0,25) + '..';
    return a;

  }
}