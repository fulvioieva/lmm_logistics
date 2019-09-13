class WorkingUsers {
  final int id;
  final String firstName;
  final String lastName;

  WorkingUsers({this.id, this.firstName, this.lastName});

  factory WorkingUsers.fromJson(Map<String, dynamic> json) {
    return new WorkingUsers(
        id: json['id'],
        firstName: json['first_name'],
        lastName: json['last_name']);
  }

  String getDescription(){
    String a =  this.lastName+ ' ' + this.firstName ;
    if (a.length>20) a = a.substring(0,20) + '..';
    return a;

  }
}