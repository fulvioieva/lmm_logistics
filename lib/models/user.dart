class User {
  String id;
  String username;
  String password;
  User({this.username, this.password, this.id});

  User.map(dynamic obj) {
    this.username = obj["username"];
    this.password = obj["password"];
    this.id = obj["id"].toString();
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["username"] = username;
    map["password"] = password;

    return map;
  }

  List<String> toListString() {
    List<String> list = new List();
    list.add(this.id);
    list.add(this.username);
    list.add(this.password);
    return list;
  }
}
