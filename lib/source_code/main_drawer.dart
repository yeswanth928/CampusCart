import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app_code/authentication/authenticator.dart';
import 'package:social_app_code/models/user.dart';
import 'package:social_app_code/source_code/change_password.dart';
import 'package:social_app_code/source_code/profile_page.dart';
import 'package:social_app_code/source_code/users_products.dart';

// This class builds a drawer that will be displayed on clicking the menu button
class TheMainDrawer extends StatefulWidget {
  TheMainDrawer();
  @override
  _TheMainDrawerState createState() => _TheMainDrawerState();
}

class _TheMainDrawerState extends State<TheMainDrawer> {
  String userName =
      "User Name"; //used to store the user name value obtained from shared preferences.
  String userEmail =
      "User Email"; //used to store the user email value obtained from shared preferences.

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Card(
              margin: EdgeInsets.zero,
              color: Theme.of(context).primaryColor,
              child:
                  // Drawer header in the drawer that displays username and user email.
                  DrawerHeader(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(5), // use media queries here
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              child: ListTile(
                            leading: Icon(
                              Icons.person_pin,
                              color: Theme.of(context).backgroundColor,
                            ),
                            title: Consumer<TheUser>(
                              builder: (context, value, child) {
                                return Text(
                                  value.userName() ?? "UserName",
                                  style: TextStyle(
                                      color: Theme.of(context).backgroundColor),
                                );
                              },
                            ),
                            subtitle: Text(
                              TheUser.email,
                              style: TextStyle(
                                  color: Theme.of(context).backgroundColor),
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TheProfilePage()));
                            },
                          )),
                          Divider(),
                          Container(
                              margin: EdgeInsets.only(top: 15),
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "Menu",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .color),
                              ))
                        ],
                      ))),
          // The list tile that when clicked navigates user to change password page.
          ListTile(
            title: Text("Change Password"),
            leading: Icon(
              Icons.lock,
              color: Theme.of(context).iconTheme.color,
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditEmailPage()));
            },
          ),
          // The list tile that when clicked navigates user to the items that user wants to sell on appp.
          ListTile(
            title: Text("Your Items"),
            leading: Icon(
              Icons.business_center,
              color: Theme.of(context).iconTheme.color,
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TheUserAddedProducts()));
            },
          ),
          // The list tile that when clicked logs out the user.
          ListTile(
            title: Text("LogOut"),
            leading: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).iconTheme.color,
            ),
            onTap: () {
              FireBaseAuthenticationHelper().logout(context);
            },
          ),
        ],
      ),
    );
  }
}
