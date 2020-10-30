import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app_code/authentication/auth_exception_handling.dart';
import 'package:social_app_code/authentication/authenticator.dart';
import 'package:social_app_code/custom_widgets/raised_button_for_login.dart';
import 'package:social_app_code/custom_widgets/show_dialog.dart';
import 'package:social_app_code/decoration/form_text_field_border.dart';
import 'package:social_app_code/decoration/padding_for_registration_forms.dart';
import 'package:social_app_code/source_code/create_account.dart';
import 'package:social_app_code/source_code/forgot_password.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  // Text controller for user name fiels
  TextEditingController userName = TextEditingController();

  // Text controller for password field
  TextEditingController passWord = TextEditingController();

  final FireBaseAuthenticationHelper fbAuthHelper =
      FireBaseAuthenticationHelper();

  @override
  void initState() {
    super.initState();
    // signInUserAutomatically();
    unamePass();
  }

// function to signin using Google
  Future<void> signinusinggoogle() async {
    AuthResultStatus status = await fbAuthHelper.signInUsingGoogle(context);
    if (status == AuthResultStatus.successful) {
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => TheHomePage()));
    } else {
      String errorMessage =
          AuthExceptionHandler.generateExceptionMessage(status);
      showAlertDialogBox(context, errorMessage, "Error");
    }
  }

// Autofill user name and password if already saved on phone
  void unamePass() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    userName.text = myPrefs.get("uname") ?? "";
    passWord.text = myPrefs.get("passw") ?? "";
  }

// When user name and password is entered save it to the phones disk
  void setUnamePass(String field, String val) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString(field, val);
  }

// Validate user details for signing in.
  Future<void> validatingSignin() async {
    if (_formKey.currentState.validate()) {
      AuthResultStatus status = await fbAuthHelper.loginToMyAccount(
          userName.text, passWord.text, context);

      if (status == AuthResultStatus.successful) {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => TheHomePage()));
      } else {
        String errorMessage =
            AuthExceptionHandler.generateExceptionMessage(status);
        showAlertDialogBox(context, errorMessage, "Error");
      }
    }
  }

// The form
  Form _form() {
    return Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Padding(
              // The User Name field widget
              padding: paddingForRegistrationForms(context),
              child: TextFormField(
                controller: userName,
                style: TextStyle(
                    color: Theme.of(context).textTheme.headline1.color),
                decoration:
                    loginInputBorder(context, "Enter User Email", Icons.person),
                validator: (String som) {
                  if (userName.text.length == 0) {
                    return "! Please Enter a valid User Email";
                  }
                  return null;
                },
              ),
            ),

            Padding(
              // The Password field Widget
              padding: paddingForRegistrationForms(context),
              child: TextFormField(
                controller: passWord,
                obscureText: true,
                style: TextStyle(
                    color: Theme.of(context).textTheme.headline1.color),
                decoration:
                    loginInputBorder(context, "Enter Password", Icons.vpn_key),
                onSaved: (newValue) {
                  passWord.text = newValue;
                },
                validator: (String value) {
                  if (passWord.text.length == 0) {
                    return "! Please Enter a valid Password";
                  }
                  return null;
                },
              ),
            ),

            Container(
              // Contains SigIn and submit buttons
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),

                  // SignIn with google Button
                  Expanded(
                    child: RaisedButton(
                      onPressed: () {
                        signinusinggoogle();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      color: Theme.of(context).backgroundColor,
                      child: Text(
                        "Signin with Google",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.headline6.color,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),

                  // Submit Button
                  Expanded(
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          setUnamePass("uname", userName.text);
                          setUnamePass("passw", passWord.text);
                          validatingSignin();
                        }
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      color: Theme.of(context).backgroundColor,
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.headline6.color,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                ],
              ),
            ),

            Padding(
              // Forgot Password.
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.05),
              child: Container(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotEmailPassword()));
                    },
                    child: Text(
                      "Forgot Password",
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                  )),
            ),

            // Create a new account button
            theRaisedButton(context, "Create Account", () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateAccount()));
            }, Icons.lock_open)
          ],
        ));
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
                            // padding: EdgeInsets.only(top: 15),
                            color: Theme.of(context).primaryColor,
                            alignment: Alignment.center,
                            child: ImageIcon(
                              AssetImage("images/logo_white_png_1080.png"),
                              color: Theme.of(context).backgroundColor,
                              size: MediaQuery.of(context).size.height * 0.2,
                            ))),
                    Expanded(
                        //Contains the form and buttons
                        flex: 5,
                        child: Container(child: _form()))
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
                      child: _form())
                ],
              ));
  }
}
