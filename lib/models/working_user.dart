class WorkingUsers {
  final int id;
  final String first_name;
  final String last_name;

  WorkingUsers({this.id, this.first_name, this.last_name});

  factory WorkingUsers.fromJson(Map<String, dynamic> json) {
    return new WorkingUsers(
        id: json['id'],
        first_name: json['first_name'],
        last_name: json['last_name']);
  }

  String getDescription(){
    String a =  this.last_name+ ' ' + this.first_name ;
    if (a.length>20) a = a.substring(0,20) + '..';
    return a;

  }
}