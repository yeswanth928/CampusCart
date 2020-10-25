import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app_code/models/login_model.dart';
import 'package:social_app_code/source_code/login_screen.dart';
import 'package:social_app_code/source_code/main_page.dart';

// After splash screen the user is navigated to respective page using this class.
// If user is already logged in, user is navigated to home screen.
// If user is not looged in, the user is navigated to logged in.
class RedirectingClass extends StatefulWidget {
  @override
  _RedirectingClassState createState() => _RedirectingClassState();
}

class _RedirectingClassState extends State<RedirectingClass> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Consumer<UserLogin>(
        builder: (context, value, child) {
          switch (value.theStatus) {
            case LoginUserStatus.loggedIn:
              return TheHomePage();
              break;
            case LoginUserStatus.loggedOut:
              return LoginPage();
              break;
            default:
              return Container(
                color: Theme.of(context).backgroundColor,
                child: CircularProgressIndicator(),
              );
              break;
          }
        },
      ),
    );
  }
}
