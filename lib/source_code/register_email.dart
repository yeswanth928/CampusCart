import 'package:flutter/material.dart';
import 'package:social_app_code/decoration/formTextFieldBorder.dart';
import 'package:social_app_code/decoration/paddingForRegistrationForms.dart';
import 'package:social_app_code/source_code/home_page.dart';

// The code here is similar to register_phone_number.dart  except for the validator function and icon and label of the text form fields and also the name of the text controller.
class RegisterEmail extends StatefulWidget {
  @override
  _RegisterEmailState createState() => _RegisterEmailState();
}

class _RegisterEmailState extends State<RegisterEmail> {
  final _formKey = GlobalKey<FormState>(); // Used for form validation
  TextEditingController emailTextController =
      TextEditingController(); // Email text controller

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);

    return Scaffold(
        body: (mediaquery.orientation == Orientation.portrait)
            ?

            // Portrait orientation widget
            Container(
                color: Theme.of(context).primaryColor,
                child: Column(
                  children: [
                    Expanded(
                        flex: 3,
                        child: Container(
                          child: ImageIcon(
                            AssetImage("images/logo_white_png_1080.png"),
                            color: Theme.of(context).backgroundColor,
                            size: MediaQuery.of(context).size.height * 0.2,
                          ),
                        )),
                    Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.only(
                              left: mediaquery.size.width * 0.05,
                              right: mediaquery.size.width * 0.05,
                              bottom: mediaquery.size.height * 0.01,
                              top: mediaquery.size.height * 0.01),
                          child: ListView(
                            children: [_form(), _submitButton()],
                          ),
                        )),
                    Expanded(flex: 3, child: Container())
                  ],
                ),
              )
            :

            // Landscape orientation widget.
            Row(
                children: [
                  Container(
                    height: mediaquery.size.height,
                    color: Theme.of(context).primaryColor,
                    width: mediaquery.size.width * 0.5,
                    child: ImageIcon(
                      AssetImage("images/logo_white_png_1080.png"),
                      color: Theme.of(context).backgroundColor,
                      size: MediaQuery.of(context).size.height * 0.2,
                    ),
                  ),
                  Container(
                    color: Theme.of(context).primaryColor,
                    width: mediaquery.size.width * 0.5,
                    child: Column(
                      // This is same as the portrait widget column, but just remove the icon as the first column child and insert Expanded(flex: 3, child: Container()).
                      children: [
                        Expanded(flex: 3, child: Container()),
                        Expanded(
                            flex: 4,
                            child: Container(
                              padding: paddingForRegistrationForms(context),
                              child: Column(
                                children: [_form(), _submitButton()],
                              ),
                            )),
                        Expanded(flex: 2, child: Container())
                      ],
                    ),
                  )
                ],
              ));
  }

// the email registration form
  Widget _form() {
    return Form(
        key: _formKey,
        child: TextFormField(
            style:
                TextStyle(color: Theme.of(context).textTheme.headline1.color),
            controller: emailTextController,
            decoration: loginInputBorder(
              context,
              "Email",
              Icons.email,
            ),
            validator: (value) {
              if (value.length > 50 || value.isEmpty) {
                return "Only Gmail, Outlook, Email and Yahoo mails are allowed to register.";
              } else {
                return null;
              }
            }));
  }

// The Submit button widget

  Widget _submitButton() {
    return Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.05,
          right: MediaQuery.of(context).size.width * 0.05,
          bottom: MediaQuery.of(context).size.height * 0.01,
          top: MediaQuery.of(context).size.height * 0.01),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: Theme.of(context).backgroundColor,
        child: ListTile(
            title: Text(
          "Submit",
          style: TextStyle(
            color: Theme.of(context).textTheme.headline6.color,
          ),
        )),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            // Write function here to register Email.
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TheHomePageView()));
          }
        },
      ),
    );
  }
}
