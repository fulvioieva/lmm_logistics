import 'dart:async';
//import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:lmm_logistics/models/user.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    //io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, "main.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE User(id INTEGER PRIMARY KEY, username TEXT, password TEXT)");
    print("Created tables");
  }

  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.insert("User", user.toMap());
    return res;
  }

  Future<User> getUser(int id) async {
    var dbClient = await db;
    var res = await dbClient.query("User", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? User.map(res.first) : Null;
  }

  changePassword(User user) async {
    var dbClient = await db;
    var res = await dbClient
        .update("User", user.toMap(), where: "id = ?", whereArgs: [user.id]);
    return res;
  }

  Future<int> deleteUsers() async {
    var dbClient = await db;
    int res = await dbClient.delete("User");
    return res;
  }

  Future<bool> isLoggedIn() async {
    var dbClient = await db;
    var res = await dbClient.query("User");
    return res.length > 0 ? true : false;
  }

  Future<int> idUser() async {
    var dbClient = await db;
    var res = await dbClient.query("User");
    return res.isNotEmpty ? int.parse(User.map(res.first).id) : 0;
  }
}
