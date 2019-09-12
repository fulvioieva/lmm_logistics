import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lmm_logistics/data/rest_ds.dart';
import 'package:lmm_logistics/screens/home/home_screen.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool pswView1, pswView2, pswView3;
  RestDatasource api = RestDatasource();
  TextEditingController oldPassword, newPassword, renewPassword;
  Color oldPasswordColor, newPasswordColor, renewPasswordColor;
  FocusNode oldPasswordFocus, newPasswordFocus, renewPasswordFocus;
  @override
  void initState() {
    pswView1 = pswView2 = pswView3 = false;
    oldPassword = new TextEditingController();
    newPassword = new TextEditingController();
    renewPassword = new TextEditingController();
    oldPasswordColor = Colors.green;
    newPasswordColor = Colors.green;
    renewPasswordColor = Colors.green;
    oldPasswordFocus = FocusNode();
    newPasswordFocus = FocusNode();
    renewPasswordFocus = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              setState(() {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              });
            }),
        title: Text("Cambio password"),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height / 1.5,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: oldPasswordColor, width: 2)),
                    child: Flex(
                      children: <Widget>[
                        Expanded(
                          flex: 8,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: TextField(
                              textInputAction: TextInputAction.next,
                              focusNode: oldPasswordFocus,
                              onSubmitted: (value) {
                                oldPasswordFocus.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(newPasswordFocus);
                              },
                              controller: oldPassword,
                              obscureText: !pswView1,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Inserire la vecchia password',
                                  labelStyle: TextStyle(fontSize: 16)),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: IconButton(
                            icon: Icon(
                              pswView1
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              setState(() {
                                pswView1 = !pswView1;
                              });
                            },
                          ),
                        ),
                      ],
                      direction: Axis.horizontal,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: newPasswordColor, width: 2)),
                    child: Flex(
                      children: <Widget>[
                        Expanded(
                          flex: 8,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: TextField(
                              textInputAction: TextInputAction.next,
                              focusNode: newPasswordFocus,
                              onSubmitted: (value) {
                                oldPasswordFocus.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(renewPasswordFocus);
                              },
                              onChanged: (value) {
                                newPassword.text == renewPassword.text
                                    ? setState(() {
                                        renewPasswordColor = Colors.green;
                                        newPasswordColor = Colors.green;
                                      })
                                    : setState(() {
                                        renewPasswordColor = Colors.red;
                                        newPasswordColor = Colors.red;
                                      });
                              },
                              controller: newPassword,
                              obscureText: !pswView2,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Inserire la nuova password',
                                  labelStyle: TextStyle(fontSize: 16)),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: IconButton(
                            icon: Icon(
                              pswView2
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              setState(() {
                                pswView2 = !pswView2;
                              });
                            },
                          ),
                        ),
                      ],
                      direction: Axis.horizontal,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: renewPasswordColor, width: 2)),
                    child: Flex(
                      children: <Widget>[
                        Expanded(
                          flex: 8,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: TextField(
                              focusNode: renewPasswordFocus,
                              onSubmitted: (value) {
                                oldPasswordFocus.unfocus();
                                changePassword();
                              },
                              textInputAction: TextInputAction.done,
                              onChanged: (value) {
                                renewPassword.text == newPassword.text
                                    ? setState(() {
                                        renewPasswordColor = Colors.green;
                                        newPasswordColor = Colors.green;
                                      })
                                    : setState(() {
                                        renewPasswordColor = Colors.red;
                                        newPasswordColor = Colors.red;
                                      });
                              },
                              controller: renewPassword,
                              obscureText: !pswView3,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Reinserire la nuova password',
                                  labelStyle: TextStyle(fontSize: 16)),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: IconButton(
                            icon: Icon(
                              pswView3
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              setState(() {
                                pswView3 = !pswView3;
                              });
                            },
                          ),
                        ),
                      ],
                      direction: Axis.horizontal,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: MaterialButton(
                    onPressed: () {
                      changePassword();
                    },
                    color: Colors.green,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "Cambia password",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void changePassword() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    setState(() async {
      if (oldPassword.text.isNotEmpty) {
        if (newPassword.text == renewPassword.text) {
          if (newPassword.text.isNotEmpty && renewPassword.text.isNotEmpty) {
            String res = await api.changePassword(oldPassword.text, newPassword.text);
            switch (res) {
              case "200":
                showFlash(
                    context: context,
                    duration: Duration(seconds: 1),
                    builder: (context, controller) {
                      return Flash(
                        controller: controller,
                        style: FlashStyle.floating,
                        boxShadows: kElevationToShadow[4],
                        backgroundColor: Colors.black87,
                        child: FlashBar(
                          message: Text(
                            "Password cambiata correttamente",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }).whenComplete(() {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                });
                break;
              case "400":
                showFlash(
                    context: context,
                    duration: Duration(seconds: 1),
                    builder: (context, controller) {
                      return Flash(
                        controller: controller,
                        style: FlashStyle.floating,
                        boxShadows: kElevationToShadow[4],
                        backgroundColor: Colors.black87,
                        child: FlashBar(
                          message: Text(
                            "La vecchia password non è corretta",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    });
                break;
              case "404":
                showFlash(
                    context: context,
                    duration: Duration(seconds: 1),
                    builder: (context, controller) {
                      return Flash(
                        controller: controller,
                        style: FlashStyle.floating,
                        boxShadows: kElevationToShadow[4],
                        backgroundColor: Colors.black87,
                        child: FlashBar(
                          message: Text(
                            "Ci sono dei problemi con il server, riprova più tardi",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    });
                break;
              case "406":
                showFlash(
                    context: context,
                    duration: Duration(seconds: 1),
                    builder: (context, controller) {
                      return Flash(
                        controller: controller,
                        style: FlashStyle.floating,
                        boxShadows: kElevationToShadow[4],
                        backgroundColor: Colors.black87,
                        child: FlashBar(
                          message: Text(
                            "La nuova password inserita è uguale a quella vecchia",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    });
                break;
            }
          }
        }
      }
    });
  }
}
