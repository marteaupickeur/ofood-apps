import 'package:flutter/material.dart';
import 'package:ofood/services/authentification.dart';
import 'package:ofood/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrentUser extends ChangeNotifier {
  AuthenticationService auth = AuthenticationService();

  var user;
  var userData;
  bool userDataFlag = false;

  getUserFromAuth() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    user = sp.getString('myUserId');
    if (user != null) {
      getUserDataFromDatabase();
    }

    notifyListeners();
  }

  getUserDataFromDatabase() async {
    Stream s = await DatabaseService(user).getUser();
    s.listen((snapshot) {
      userData = snapshot;
      userDataFlag = true;
    });
    notifyListeners();
  }
}
