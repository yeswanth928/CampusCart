import 'package:flutter/material.dart';
import 'package:social_app_code/authentication/auth_exception_handling.dart';
import 'package:social_app_code/authentication/authenticator.dart';
import 'package:social_app_code/custom_widgets/show_dialog.dart';
import 'package:social_app_code/decoration/form_text_field_border.dart';
import 'package:social_app_code/decoration/padding_for_registration_forms.dart';

class EditEmailPage extends StatefulWidget {
  @override
  _EditEmailPageState createState() => _EditEmailPageState();
}

class _EditEmailPageState extends State<EditEmailPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = "";
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

// The function used to change password
  Future changePassword() async {
    var status = await FireBaseAuthenticationHelper()
        .changeCurrentUserPassword(_emailController.text);
    if (status == AuthResultStatus.successful) {
      showAlertDialogBox(
          context, "Password reset link has been sent to Email.", "Info");
    } else {
      var res = AuthExceptionHandler.generateExceptionMessage(status);
      showAlertDialogBox(context, res, "Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).appBarTheme.iconTheme,
          textTheme: Theme.of(context).appBarTheme.textTheme,
          shape: RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5))),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context)),
          title: Text("Change Password"),
        ),
        body: (MediaQuery.of(context).orientation == Orientation.portrait)
            ? Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.1),
                color: Theme.of(context).backgroundColor,
                child: Container(child: _form(context)),
              )
            : Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.1),
                color: Theme.of(context).backgroundColor,
                width: MediaQuery.of(context).size.width * 0.5,
                child: _form(context)));
  }

// The form
  _form(context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            // This is the email text field.
            Padding(
              padding: paddingForRegistrationForms(context),
              child: TextFormField(
                controller: _emailController,
                style: TextStyle(color: Theme.of(context).primaryColor),
                cursorColor: Theme.of(context).primaryColor,
                decoration: inputBorder(context, "Email ID", Icons.email),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter a valid Email ID";
                  }
                  return null;
                },
              ),
            ),

            _raisedButton(context, "Send password reset link.", () {},
                Icons.account_circle)
          ],
        ));
  }

// The Raised button button
  Widget _raisedButton(
      BuildContext context, String text, Function onClik, IconData iconVal) {
    // text => the text to be displayed on the button

    // onClik => The function to be called on clicking the button

    // iconVal => The icon to be displayed at the beginig of the button
    return Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05,
            bottom: MediaQuery.of(context).size.height * 0.01),
        child: RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            color: Theme.of(context).primaryColor,
            child: ListTile(
                leading: Icon(
                  iconVal,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text(
                  text,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headline1.color,
                  ),
                )),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                changePassword();
                // Write a function here to send verification email.
              }
            }));
  }
}
