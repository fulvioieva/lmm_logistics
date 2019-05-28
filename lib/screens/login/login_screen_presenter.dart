import 'package:lmm_logistics/data/rest_ds.dart';
import 'package:lmm_logistics/models/user.dart';
import 'package:lmm_logistics/utils/globals.dart' as globals;

abstract class LoginScreenContract {
  void onLoginSuccess(User user);

  void onLoginError(String errorTxt);
}

class LoginScreenPresenter {
  LoginScreenContract _view;
  RestDatasource api = new RestDatasource();

  LoginScreenPresenter(this._view);


  doLogin(String username, String password) async  {
    try {
      if (globals.logger) print("DoLogin-> " + username + ' ' + password);
      var user = await api.login(username, password);
      _view.onLoginSuccess(user);
    } on Exception catch(error) {
      _view.onLoginError(error.toString());
    }
  }
/*
  doLogin(String username, String password) {
    api.login(username, password).then((User user) {
      _view.onLoginSuccess(user);
    }).catchError((Exception error) => _view.onLoginError(error.toString()));
  }

  */
}
