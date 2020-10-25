import 'package:flutter/material.dart';
import 'themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeType { Pink, Cyan, Green, Red, Yellow }

// This class is used to change the color of the app and also user details
class ThemeModel extends ChangeNotifier {
  ThemeData currentTheme; // Current color
  ThemeType _themeType; // The theme color
  String currentVal; // current color string
  String profileName, profileCollege, profileCollegeAddress;

  ThemeModel(this.currentVal, this.profileName, this.profileCollege,
      this.profileCollegeAddress);

// This function updates user details stored in disk
  updateUserDetails(String user, String college, String collegeAddress) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();

    myPrefs.setString("name", user);
    myPrefs.setString("college", college);
    myPrefs.setString("collegeAddress", collegeAddress);
    profileName = user;
    profileCollege = college;
    profileCollegeAddress = collegeAddress;

    notifyListeners();
  }

// Returns the current theme
  getTheme() {
    currentVal = currentVal ?? "pink";
    switch (currentVal) {
      case "pink":
        currentTheme = pinkTheme;
        _themeType = ThemeType.Pink;
        break;
      case "cyan":
        currentTheme = cyanTheme;
        _themeType = ThemeType.Cyan;
        break;
      case "green":
        currentTheme = greenTheme;
        _themeType = ThemeType.Green;
        break;
      case "red":
        currentTheme = redTheme;
        _themeType = ThemeType.Red;
        break;
      case "yellow":
        currentTheme = yellowTheme;
        _themeType = ThemeType.Yellow;
        break;
      default:
        break;
    }
    return currentTheme;
  }

// changes current theme to pink and also saves this to disk
  changeToPink() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    if (_themeType != ThemeType.Pink) {
      myPrefs.setString("themeVal", "pink");
      currentVal = "pink";
      return notifyListeners();
    }
  }

// changes current theme to cyan and also saves this to disk
  changeToCyan() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    if (_themeType != ThemeType.Cyan) {
      myPrefs.setString("themeVal", "cyan");
      currentVal = "cyan";
      return notifyListeners();
    }
  }

// changes current theme to green and also saves this to disk
  changeToGreen() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    if (_themeType != ThemeType.Green) {
      myPrefs.setString("themeVal", "green");
      currentVal = "green";
      return notifyListeners();
    }
  }

// changes current theme to red and also saves this to disk
  changeToRed() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    if (_themeType != ThemeType.Red) {
      myPrefs.setString("themeVal", "red");
      currentVal = "red";
      return notifyListeners();
    }
  }

// changes current theme to yellow and also saves this to disk
  changeToYellow() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    if (_themeType != ThemeType.Yellow) {
      myPrefs.setString("themeVal", "yellow");
      currentVal = "yellow";
      return notifyListeners();
    }
  }
}
