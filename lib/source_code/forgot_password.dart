import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:social_app_code/authentication/auth_exception_handling.dart';
import 'package:social_app_code/authentication/authenticator.dart';
import 'package:social_app_code/custom_widgets/raised_button_for_login.dart';
import 'package:social_app_code/custom_widgets/show_dialog.dart';
import 'package:social_app_code/decoration/form_text_field_border.dart';
import 'package:social_app_code/decoration/padding_for_registration_forms.dart';

// This class builds a scaffold that displays the forgot password page and on entering a valid registeres email id, an password reset email will be sent to your email account.
class ForgotEmailPassword extends StatefulWidget {
  @override
  _ForgotEmailPasswordState createState() => _ForgotEmailPasswordState();
}

class _ForgotEmailPasswordState extends State<ForgotEmailPassword> {
  final _formKey = GlobalKey<FormState>(); // For ghe forgot password form

  TextEditingController _emailController =
      TextEditingController(); // Text editing controller for email form field

  FireBaseAuthenticationHelper _fbAuthHelper = FireBaseAuthenticationHelper();

  AuthResultStatus _status;

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

  Future<void> forgotThePassword() async {
    _status = await _fbAuthHelper.forgotePassword(_emailController.text);

    if (_status == AuthResultStatus.successful) {
      showAlertDialogBox(
          context,
          "Please Click on the link sent to your mail to change Password.",
          "Info");
    } else {
      String errorMessage =
          AuthExceptionHandler.generateExceptionMessage(_status);
      showAlertDialogBox(context, errorMessage, "Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: (MediaQuery.of(context).orientation == Orientation.portrait)
            ? Container(
                color: Theme.of(context).primaryColor,
                child: Column(
                  children: <Widget>[
                    Expanded(
                        // Contains the Icon
                        flex: 3,
                        child: Container(
                            alignment: Alignment.center,
                            child: ImageIcon(
                              AssetImage("images/logo_white_png_1080.png"),
                              color: Theme.of(context).backgroundColor,
                              size: MediaQuery.of(context).size.height * 0.2,
                            ))),
                    Expanded(
                        //Contains the form and buttons
                        flex: 5,
                        child: Container(child: _form(context)))
                  ],
                ),
              )
            : Row(
                // for Main icon.
                children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      color: Theme.of(context).primaryColor,
                      alignment: Alignment.center,
                      child: ImageIcon(
                        AssetImage("images/logo_white_png_1080.png"),
                        color: Theme.of(context).backgroundColor,
                        size: MediaQuery.of(context).size.height * 0.2,
                      )),
                  Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.1),
                      color: Theme.of(context).primaryColor,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: _form(context))
                ],
              ));
  }

// The email form field and "Send Password reset link" button
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
                style: TextStyle(
                    color: Theme.of(context).textTheme.headline1.color),
                decoration: loginInputBorder(context, "Email ID", Icons.email),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter a valid Email ID";
                  }
                  return null;
                },
              ),
            ),

            // Send password reset link button
            theRaisedButton(context, "Send Password Reset Link", () {
              if (_formKey.currentState.validate()) {
                forgotThePassword();
              }
            }, Icons.account_circle)
          ],
        ));
  }
}
