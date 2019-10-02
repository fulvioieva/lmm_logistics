import 'dart:ui';
import 'package:lmm_logistics/utils/globals.dart' as globals;
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:lmm_logistics/data/database_helper.dart';
import 'package:lmm_logistics/data/rest_ds.dart';
import 'package:lmm_logistics/models/user.dart';
import 'package:lmm_logistics/screens/home/insertdate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  DatabaseHelper db = new DatabaseHelper();
  bool isloading = false;
  RestDatasource api = new RestDatasource();

  @override
  void initState() {
    db.initDb();
    autoLogIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/login_background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: new Center(
          child: new ClipRect(
            child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: new Container(
                child: Center(
                  child: isloading == false
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text("Login",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 24)),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: TextField(
                                controller: username,
                                decoration:
                                    InputDecoration(labelText: "Username"),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: TextField(
                                controller: password,
                                obscureText: true,
                                decoration:
                                    InputDecoration(labelText: "Password"),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {
                                if (username.text.isNotEmpty &&
                                    password.text.isNotEmpty) {
                                  setState(() {
                                    login(username.text, password.text);
                                  });
                                } else {
                                  showFlash(
                                      context: context,
                                      duration: Duration(seconds: 1),
                                      builder: (context, controller) {
                                        return Flash(
                                          controller: controller,
                                          style: FlashStyle.floating,
                                          boxShadows: kElevationToShadow[4],
                                          backgroundColor: Colors.red,
                                          child: FlashBar(
                                            message: Text(
                                              "Campi inseriti non corretti!",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        );
                                      });
                                }
                              },
                              color: Colors.green,
                              child: Text(
                                "LOGIN",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        )
                      : CircularProgressIndicator(
                          backgroundColor: Colors.green,
                        ),
                ),
                height: 300.0,
                width: 300.0,
                decoration: new BoxDecoration(
                    color: Colors.grey.shade200.withOpacity(0.5)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void login(String username, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isloading = true;
    });
    User user = await api.login(username, password).then((User user) {
      return user;
    }).catchError((error) {
      print(error);
    });
    if (user != null) {
      prefs.setString("id", user.id);
      prefs.setString("username", user.username);
      prefs.setString("password", user.password);
      await db.deleteUsers();
      await db.saveUser(user).then((dynamic value) {
        globals.userId = int.parse(user.id);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => InsertDate()));
      });
    } else {
      setState(() {
        isloading = false;
      });
      showFlash(
          context: context,
          duration: Duration(seconds: 1),
          builder: (context, controller) {
            return Flash(
              controller: controller,
              style: FlashStyle.floating,
              boxShadows: kElevationToShadow[4],
              backgroundColor: Colors.red,
              child: FlashBar(
                message: Text(
                  "Campi inseriti non corretti!",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          });
    }
  }

  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String username = prefs.getString('username');
    final String password = prefs.getString('password');

    if (username != null) {
      login(username, password);
    } else {
      setState(() {
        isloading = false;
      });
    }
  }
}
