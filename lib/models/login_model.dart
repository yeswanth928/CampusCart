import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LoginUserStatus { loggedIn, loggedOut, loadingUser }

// Used to login and logout users
class UserLogin extends ChangeNotifier {
  LoginUserStatus status = LoginUserStatus.loggedOut;

  LoginUserStatus get theStatus => status;

// Gives the current user status
  getUserStatus() async {
    int val = await getUserisLoggedIn();
    print(val);
    switch (val) {
      case 0:
        status = LoginUserStatus.loggedOut;
        break;
      case 1:
        print(LoginUserStatus.loggedIn.toString());
        status = LoginUserStatus.loggedIn;
        break;
      default:
        status = LoginUserStatus.loadingUser;
        break;
    }
    notifyListeners();
  }

// Changes the user status as required.
  setUserStatus(LoginUserStatus val) async {
    SharedPreferences myPref = await SharedPreferences.getInstance();
    switch (val) {
      case LoginUserStatus.loggedIn:
        status = LoginUserStatus.loggedIn;
        myPref.setInt("IsLogged", 1);
        print(1);
        break;
      case LoginUserStatus.loggedOut:
        status = LoginUserStatus.loggedOut;
        myPref.setInt("IsLogged", 0);
        break;
      default:
        status = LoginUserStatus.loggedOut;
        break;
    }
    notifyListeners();
  }

  // modifyToLogin() {
  //   status = LoginUserStatus.loggedIn;
  //   notifyListeners();
  // }

  // modifyToLogout() {
  //   status = LoginUserStatus.loggedOut;
  //   notifyListeners();
  // }

  Future<int> getUserisLoggedIn() async {
    SharedPreferences myPref = await SharedPreferences.getInstance();
    return myPref.getInt("IsLogged") ?? 0;
  }
}
