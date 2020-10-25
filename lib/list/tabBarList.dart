import 'package:flutter/material.dart';
import 'package:social_app_code/source_code/enter_details.dart';
import 'package:social_app_code/source_code/home_page.dart';
import 'package:social_app_code/source_code/select_theme_page.dart';
import 'package:social_app_code/source_code/upload_image.dart';

// The main screens used in TabBarView
var tabBodyScreens = <Widget>[
  TheHomePageView(),
  TheImagePickerScreen(),
  ModifyDetailsPage(),
  SelectThemeClass()
];

// The Tab bar Tabs(icons and names)

var tabBarItems = <Tab>[
  Tab(
    icon: Icon(Icons.home),
    text: "Home",
  ),
  Tab(
    icon: Icon(Icons.add_box),
    text: "Add Product",
  ),
  Tab(
    icon: Icon(Icons.account_balance),
    text: "Account",
  ),
  Tab(
    icon: Icon(Icons.adjust),
    text: "Theme",
  )
];
