class Site {
  int id;
  int ragSoc;
  String insegna;
  String siteName;
  String citta;
  String provincia;
  String indirizzo;
  Site({this.insegna, this.ragSoc, this.siteName, this.id, this.citta, this.provincia, this.indirizzo});

  Site.map(dynamic obj) {
    this.insegna = obj["insegna"];
    this.siteName = obj["site_name"];
    this.ragSoc = obj["rag_soc"];
    this.citta = obj["citta"];
    this.provincia = obj["provincia"];
    this.indirizzo = obj["indirizzo"];
    this.id = obj["id"];

  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["site_name"] = siteName;
    map["indirizzo"] = indirizzo;
    map["provincia"] = provincia;
    map["citta"] = citta;
    map["rag_soc"] = ragSoc;
    map["insegna"] = insegna;
    return map;
  }

  String getDescription(){
    //String a =  this.insegna+ ' ' + this.citta + ' (' + this.provincia + ')';
    String a =  this.siteName;
    if (a.length>25) a = a.substring(0,25) + '..';
    return a;

  }
}