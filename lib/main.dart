import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app_code/models/login_model.dart';
import 'package:social_app_code/models/user.dart';
import 'package:social_app_code/source_code/after_splash.dart';
import 'package:social_app_code/source_code/product_page.dart';
import 'package:social_app_code/themes/theme_model.dart';
import 'package:provider/provider.dart';
import 'themes/theme_model.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // Used to get all the required values before running the app
  WidgetsFlutterBinding.ensureInitialized();

  // get key value pairs if stored on mobile disk already.
  SharedPreferences myPrefs = await SharedPreferences.getInstance();
  var theVal = myPrefs.get("themeVal");
  var theUser = myPrefs.getString("name") ?? "User Name";
  var theCollege = myPrefs.getString("college") ?? "College Name";
  var theAddress = myPrefs.getString("collegeAddress") ?? "College Address";
  // ignore: missing_required_param

  FirebaseAnalytics analytics = FirebaseAnalytics();

  runApp(FutureBuilder(
    future: Firebase.initializeApp(),
    builder: (context, snapshot) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      if (snapshot.hasError) {
        return Text("something is wrong");
      } else if (snapshot.connectionState == ConnectionState.done) {
        return MultiProvider(
          child: MyApp(),
          providers: [
            ChangeNotifierProvider<ThemeModel>(
                create: (BuildContext context) =>
                    ThemeModel(theVal, theUser, theCollege, theAddress)),
            ChangeNotifierProvider<TheUser>(
              create: (BuildContext context) => TheUser(),
            ),
            ChangeNotifierProvider<UserLogin>(
              create: (context) => UserLogin(),
            )
          ],
          builder: (BuildContext context, child) {
            // SystemChrome.setPreferredOrientations([
            //   DeviceOrientation.portraitUp,
            // ]);
            return MaterialApp(
              home: MyApp(),
              theme: Provider.of<ThemeModel>(context).getTheme(),
              navigatorObservers: [
                FirebaseAnalyticsObserver(analytics: analytics),
              ],
            );
          },
        );
      }
      return CircularProgressIndicator();
    },
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Opens the product on clicking dynamic link.
  Future<void> retrieveDynamicLink() async {
    // FirebaseDynamicLinks.instance.onLink(onSuccess: (linkData) async {
    //   final Uri deepLink = linkData?.link;
    //   print(linkData.toString());
    //   if (deepLink != null) {
    //     var id = deepLink.queryParameters;
    //     DocumentSnapshot theDoc = await FirebaseFirestore.instance
    //         .collection("products")
    //         .doc(id["prodId"])
    //         .get();
    //     Navigator.of(context).push(MaterialPageRoute(
    //         builder: (context) => TheProductPage(
    //               theDoc: theDoc,
    //             )));
    //   }
    // }, onError: (OnLinkErrorException e) async {
    //   print(e);
    // });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      var id = deepLink.queryParameters;

      DocumentSnapshot theDoc = await FirebaseFirestore.instance
          .collection("products")
          .doc(id["prodId"])
          .get();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => TheProductPage(
                theDoc: theDoc,
                isDeepLink: true,
              )));

      return deepLink.toString();
    }
  }

  @override
  void initState() {
    final _auth = FirebaseAuth.instance;
    User user;
    user = _auth.currentUser;
    // initializes the user status i.e. logged in  or not.
    if (user != null && user.emailVerified) {
      retrieveDynamicLink();
      TheUser.id = user.uid;
      TheUser.email = user.email;
      context.read<UserLogin>().getUserStatus();
    }
    super.initState();
    // After 2 seconds navigate user from splash screen.
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => RedirectingClass()));
    });
  }

  @override
  build(BuildContext context) {
    // splash screen
    return Scaffold(
      body: Center(
          child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.height * 0.3,
              child: Image.asset("images/logo_curved_png_1080.png"))),
    );
  }
}
