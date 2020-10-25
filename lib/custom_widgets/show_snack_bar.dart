import 'package:flutter/material.dart';

// This function is used to display the snack bar. And on clicking the "ok" button in it, the snackbar is dismissed.
void showSnackBar({BuildContext context, String theContent}) {
// context => the build contxet

// theContent => The string that will be displayed in the sanck bar.

  Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).backgroundColor,
      behavior: SnackBarBehavior.floating,
      content: Container(
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Text(
                theContent,
                style: TextStyle(color: Theme.of(context).primaryColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Raised button to dismiss the snack bar
            Expanded(
              flex: 1,
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(),
                onPressed: () => Scaffold.of(context)
                    .removeCurrentSnackBar(reason: SnackBarClosedReason.remove),
                child: Text(
                  "Ok",
                  style: TextStyle(color: Theme.of(context).backgroundColor),
                ),
              ),
            )
          ],
        ),
      )));
}
