import 'package:flutter/material.dart';

EdgeInsets paddingForRegistrationForms(BuildContext context) {
  // This is used for padding of form buttons in registration forms.

  return EdgeInsets.all(MediaQuery.of(context).size.width *
      0.05); // This is only for forms and not for buttons.
}
