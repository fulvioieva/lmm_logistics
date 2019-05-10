class User {
  int id;
  String username;
  String password;
  User({this.username, this.password, this.id});

  User.map(dynamic obj) {
    this.username = obj["username"];
    this.password = obj["password"];
    this.id = obj["id"];

  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["username"] = username;
    map["password"] = password;

    return map;
  }
}