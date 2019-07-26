class Site {
  int id;
  int rag_soc;
  String insegna;
  String site_name;
  String citta;
  String provincia;
  String indirizzo;
  Site({this.insegna, this.rag_soc, this.site_name, this.id, this.citta, this.provincia, this.indirizzo});

  Site.map(dynamic obj) {
    this.insegna = obj["insegna"];
    this.site_name = obj["site_name"];
    this.rag_soc = obj["rag_soc"];
    this.citta = obj["citta"];
    this.provincia = obj["provincia"];
    this.indirizzo = obj["indirizzo"];
    this.id = obj["id"];

  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["site_name"] = site_name;
    map["indirizzo"] = indirizzo;
    map["provincia"] = provincia;
    map["citta"] = citta;
    map["rag_soc"] = rag_soc;
    map["insegna"] = insegna;
    return map;
  }

  String getDescription(){
    //String a =  this.insegna+ ' ' + this.citta + ' (' + this.provincia + ')';
    String a =  this.site_name;
    if (a.length>25) a = a.substring(0,25) + '..';
    return a;

  }
}