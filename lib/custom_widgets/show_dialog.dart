import 'package:flutter/material.dart';

//This was the initial alert dialog box.
// This function is used to show an alert dialog box
// devshowAlertDialogBox(BuildContext context, String message, String type) {
//   // message => the String that has to displayed on the alert

//   // type => This is the title string of alert dialog e.g. Info, Warning, Error etc

//   showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(
//             type,
//             style: TextStyle(color: Colors.red),
//           ),
//           content: Text(message),
//           actions: [
//             FlatButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: Text(
//                   "OK",
//                   style: TextStyle(color: Colors.blue),
//                 ))
//           ],
//         );
//       });
// }

// This function is used to show an alert dialog box
showAlertDialogBox(BuildContext context, String message, String type) {
  // message => the String that has to displayed on the alert

  // type => This is the title string of alert dialog e.g. Info, Warning, Error etc

  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            type,
            style: TextStyle(color: Colors.red),
          ),
          content: Text(message),
          actions: [
            RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "OK",
                  style: TextStyle(color: Theme.of(context).backgroundColor),
                ))
          ],
        );
      });
}
