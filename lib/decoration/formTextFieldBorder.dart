import 'package:flutter/material.dart';

// This is used for decorating form input fields border inside the app i.e for editing details.

InputDecoration inputBorder(
  BuildContext context,
  String label, // String to be displayed inside the input field.
  IconData iconName,
  //icon to be displayed outside the border.
) {
  return InputDecoration(
    icon: Icon(
      iconName,
      color: Theme.of(context).iconTheme.color,
    ),
    border: _outlineInputBorder(context),
    focusedBorder: _outlineInputBorder(context),
    enabledBorder: _outlineInputBorder(context),
    errorBorder: _outlineInputBorder(context),
    focusedErrorBorder: _outlineInputBorder(context),
    labelText: label,
    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
    hintStyle: TextStyle(color: Theme.of(context).textTheme.headline1.color),
    errorStyle: TextStyle(color: Colors.red),
  );
}

// This is the input border used for login forms.

InputDecoration loginInputBorder(
  BuildContext context,
  String label, // String to de displayed as label of the text form field.
  IconData iconName, // Icon to be displayed outside the text form field.
) {
  return InputDecoration(
    icon: Icon(
      iconName,
      color: Theme.of(context).appBarTheme.iconTheme.color,
    ),
    border: _outlineInputBorder(context),
    focusedBorder: _outlineInputBorder(context),
    enabledBorder: _outlineInputBorder(context),
    errorBorder: _outlineInputBorder(context),
    focusedErrorBorder: _outlineInputBorder(context),
    labelText: label,
    hintStyle: TextStyle(color: Theme.of(context).textTheme.headline1.color),
    labelStyle: TextStyle(color: Theme.of(context).hintColor),
    errorStyle: TextStyle(color: Theme.of(context).errorColor),
  );
}

// This is function is used in the above functions to avoid rewriting of the same code.

OutlineInputBorder _outlineInputBorder(BuildContext context) {
  return OutlineInputBorder(
      borderSide: BorderSide(color: Theme.of(context).backgroundColor),
      borderRadius: BorderRadius.circular(30));
}
