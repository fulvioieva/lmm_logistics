import 'package:flutter/material.dart';
import 'package:lmm_logistics/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/*
void main() => runApp(new LoginApp());

class LoginApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'LMM Logistics',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('it', 'IT'),
      ],
      theme: new ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.green, //Changing this will change the color of the TabBar
        accentColor: Colors.greenAccent,
      ),

      routes: routes,
    );
  }
}

*/

void main() {
  runApp(new LoginApp(
      child: new MaterialApp(
    title: 'LMM Logistics',
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: [
      const Locale('it', 'IT'),
      const Locale('en', 'US'),
    ],
    theme: new ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.green, //Changing this will change the color of the TabBar
      accentColor: Colors.greenAccent,
    ),

    routes: routes,
  )
  ));
}

class LoginApp extends StatefulWidget {
  final Widget child;

  LoginApp({this.child});

  static restartApp(BuildContext context) {
    final _RestartWidgetState state =
    context.ancestorStateOfType(const TypeMatcher<_RestartWidgetState>());
    state.restartApp();
  }

  @override
  _RestartWidgetState createState() => new _RestartWidgetState();
}

class _RestartWidgetState extends State<LoginApp> {
  Key key = new UniqueKey();

  void restartApp() {
    this.setState(() {
      key = new UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      key: key,
      child: widget.child,
    );
  }
}