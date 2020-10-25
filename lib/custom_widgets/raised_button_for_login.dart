import 'package:flutter/material.dart';

// The raised button used in login form, create account page and forgort password forms.
Widget theRaisedButton(
    BuildContext context, String text, Function onClik, IconData iconVal) {
// context => The build context

// text => The String to be displayed on the button

// onClik => The function to be called on clicking the raised button

// iconVal => The icon to be displayed at the begining of the button.
  return Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.05,
          right: MediaQuery.of(context).size.width * 0.05,
          bottom: MediaQuery.of(context).size.height * 0.01),
      child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          color: Theme.of(context).backgroundColor,
          child: ListTile(
              leading: Icon(
                iconVal,
                color: Theme.of(context).iconTheme.color,
              ),
              title: Text(
                text,
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline6.color,
                ),
              )),
          onPressed: onClik));
}
