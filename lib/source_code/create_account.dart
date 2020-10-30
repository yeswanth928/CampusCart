import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:social_app_code/authentication/auth_exception_handling.dart';
import 'package:social_app_code/authentication/authenticator.dart';
import 'package:social_app_code/custom_widgets/raised_button_for_login.dart';
import 'package:social_app_code/custom_widgets/show_dialog.dart';
import 'package:social_app_code/decoration/form_text_field_border.dart';
import 'package:social_app_code/decoration/padding_for_registration_forms.dart';

// This class displays a scaffold that is used to create a neww account inn the app.
class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>(); // The form key

  // Email form field controller
  TextEditingController _emailController = TextEditingController();
  // Password form field controller
  TextEditingController _passwordController = TextEditingController();

  FireBaseAuthenticationHelper _fbAuthHelper = FireBaseAuthenticationHelper();
// Status of user authentication
  AuthResultStatus _status;

  @override
  void initState() {
    super.initState();
    _emailController.text = "";
    _passwordController.text = "";
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

// Function that sends a verification email to the entered email if it is not already registered.
  Future<void> createTheAccount() async {
    _status = await _fbAuthHelper.createAccount(
        _emailController.text, _passwordController.text);

    if (_status == AuthResultStatus.emailNotVerified) {
      showAlertDialogBox(context,
          "Please Click on the link sent to your mail to verify.", "Info");
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
                          ),
                        )),
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
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.1),
                      color: Theme.of(context).primaryColor,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: _form(context))
                ],
              ));
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

            // This is the password text field.
            Padding(
              padding: paddingForRegistrationForms(context),
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(
                    color: Theme.of(context).textTheme.headline1.color),
                decoration:
                    loginInputBorder(context, "Password", Icons.vpn_key),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Password should be of atleast 6 characters";
                  }
                  return null;
                },
              ),
            ),

            // The create account button
            theRaisedButton(context, "Create account", () {
              if (_formKey.currentState.validate()) {
                createTheAccount();
              }
            }, Icons.account_circle),
            // _raisedButton(
            //     context, "Create Account", () {}, Icons.account_circle)
          ],
        ));
  }
}
