library my_prj.globals;

import 'package:lmm_logistics/auth.dart';

List<AuthStateListener> listener;
bool multiSito = true;
bool logger = false;
bool resetDB = false;
bool isLoggedIn = false;
int siteId = 0;
String siteName = "";
int userId = 0;
int idDailyJob = 0;
String dataLavori;
String loginUrl = "http://3.14.111.51/logistics/service.php";