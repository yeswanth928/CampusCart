import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app_code/models/user.dart';

// This page requires many modifications , use classes for list tile like fields and use themes
class TheProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor:
              Theme.of(context).appBarTheme.color, // Use themes here
        ),
        body: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.01),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(
                          MediaQuery.of(context).size.height * 0.01),
                      bottomRight: Radius.circular(
                          MediaQuery.of(context).size.height * 0.01))),
              child: GestureDetector(
                onTap: () {
                  // On clicking you will get a simple dialog which contains avatars from which you can choose the one you want
                  chooseAvatar(context: context);
                },
                child: Center(
                  child: Consumer<TheUser>(
                      builder: (BuildContext context, value, Widget child) {
                    return Container(
                        width: MediaQuery.of(context).size.height * 0.3,
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).backgroundColor,
                            image: new DecorationImage(
                                fit: BoxFit.fitHeight,
                                image: new AssetImage(value.avatar != null
                                    ? value.avatar
                                    : "images/avatar1.png"))));
                  }),
                ),
              ),
            ),
            Consumer<TheUser>(
                builder: (BuildContext context, value, Widget child) =>
                    ProfileTile(value.name ?? "User Name", "Name")),
            Consumer<TheUser>(
                builder: (BuildContext context, value, Widget child) =>
                    ProfileTile(TheUser.email ?? "User Email",
                        "Email")), // **********************
            // Consumer<ThemeModel>(
            //     builder: (BuildContext context, value, Widget child) =>
            //         ProfileTile("Your Phone No", "Phone No")),
            Consumer<TheUser>(
                builder: (BuildContext context, value, Widget child) =>
                    ProfileTile(value.college ?? "User college", "College")),
            Consumer<TheUser>(
                builder: (BuildContext context, value, Widget child) =>
                    ProfileTile(value.collegeAddress ?? "College Address",
                        "College Address")),
          ],
        ));
  }
}

// This function displays a simple dialog box from which u can select the avatar
void chooseAvatar({BuildContext context}) {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(
        "Please choose an Avatar",
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      children: [
        avatarInDialog(
            context: context, theAvatarNumberOne: 1, theAvatarNumberTwo: 7),
        avatarInDialog(
            context: context, theAvatarNumberOne: 2, theAvatarNumberTwo: 8),
        avatarInDialog(
            context: context, theAvatarNumberOne: 3, theAvatarNumberTwo: 9),
        avatarInDialog(
            context: context, theAvatarNumberOne: 4, theAvatarNumberTwo: 10),
        avatarInDialog(
            context: context, theAvatarNumberOne: 5, theAvatarNumberTwo: 11),
        avatarInDialog(
            context: context, theAvatarNumberOne: 6, theAvatarNumberTwo: 12),
      ],
    ),
  );
}

// This returns a widget that displays an avatar to choose in Simple Dialog.
Widget avatarInDialog(
    {BuildContext context, int theAvatarNumberOne, int theAvatarNumberTwo}) {
  // theAvatarNumber used as a variable to choose avatar from assets

  return Container(
    child: Row(
      children: [
        Expanded(
            child: GestureDetector(
                onTap: () {
                  Provider.of<TheUser>(context, listen: false)
                      .changeUserAvatar(theAvatarNumberOne);
                  Navigator.pop(context);
                },
                child: Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.03,
                        bottom: MediaQuery.of(context).size.height * 0.03),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).backgroundColor),
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.height * 0.2,
                    child:
                        Image.asset("images/avatar$theAvatarNumberOne.png")))),
        Expanded(
            child: GestureDetector(
                onTap: () {
                  Provider.of<TheUser>(context, listen: false)
                      .changeUserAvatar(theAvatarNumberTwo);
                  Navigator.pop(context);
                },
                child: Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.03,
                        bottom: MediaQuery.of(context).size.height * 0.03),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).backgroundColor),
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.height * 0.2,
                    child:
                        Image.asset("images/avatar$theAvatarNumberTwo.png"))))
      ],
    ),
  );
}

class ProfileTile extends StatelessWidget {
  final String title;
  final String subtitle;
  ProfileTile(this.title, this.subtitle);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        this.title,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Theme.of(context).textTheme.subtitle2.color),
      ),
      subtitle: Text(
        this.subtitle,
        style: TextStyle(color: Theme.of(context).textTheme.headline6.color),
      ),
    );
  }
}
