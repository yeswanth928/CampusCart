import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app_code/models/login_model.dart';
import 'package:social_app_code/models/user.dart';
import 'auth_exception_handling.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class FireBaseAuthenticationHelper {
  final _auth =
      FirebaseAuth.instance; // Gives us an instance of firebase authenticator
  AuthResultStatus _status; // Status of user e.g. signedIN
  User user; // The User object

  final _googleSignIn = GoogleSignIn();
  // final _firestoreInst = FirebaseFirestore.instance;

  // This method is used to initialize the user class.
  // _initializeTheUser(context) {
  //   return _firestoreInst
  //       .collection('users')
  //       .doc(TheUser.id)
  //       .get()
  //       .then((value) => {
  //             Provider.of<TheUser>(context).user_Name(value.data()['name'],
  //                 value.data()['college'], value.data()['collegeAddress'])
  //           });
  // }

  // This method allows users signin using google.
  Future<AuthResultStatus> signInUsingGoogle(context) async {
    try {
      GoogleSignInAccount googleAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuthenticate =
          await googleAccount.authentication;
      AuthCredential googleCredential = GoogleAuthProvider.credential(
          idToken: googleAuthenticate.idToken,
          accessToken: googleAuthenticate.accessToken);
      UserCredential result =
          await _auth.signInWithCredential(googleCredential);
      if (result.user != null) {
        if (result.user.emailVerified) {
          user = result.user;
          TheUser.id = user.uid;
          TheUser.email = user.email;
          // _initializeTheUser(context);
          _status = AuthResultStatus.successful;
          // Provider.of<UserLogin>(context).modifyToLogin();
          Provider.of<UserLogin>(context)
              .setUserStatus(LoginUserStatus.loggedIn);
        } else {
          _status = AuthResultStatus.emailNotVerified;
        }
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  // Used to register for the app.
  Future<AuthResultStatus> createAccount(
      String email1, String password1) async {
    try {
      User result = (await _auth.createUserWithEmailAndPassword(
              email: email1, password: password1))
          .user;
      await result
          .sendEmailVerification()
          .then((value) => {_status = AuthResultStatus.emailNotVerified})
          .catchError((error) {
        _status = AuthResultStatus.emailNotSent;
      });
    } catch (e) {
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  // Used to send an email if the users forgets password.
  Future<AuthResultStatus> forgotePassword(String email1) async {
    try {
      await _auth
          .sendPasswordResetEmail(email: email1)
          .then((value) => {_status = AuthResultStatus.successful})
          .catchError((error) {
        _status = AuthResultStatus.emailNotSent;
      });
    } catch (e) {
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  // Used for loging the user into the app
  Future<AuthResultStatus> loginToMyAccount(
      email, String password, context) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (result.user != null) {
        if (result.user.emailVerified) {
          user = result.user;
          TheUser.id = user.uid;
          TheUser.email = user.email;
          _status = AuthResultStatus.successful;
          // _initializeTheUser(context);
          // Provider.of<UserLogin>(context).modifyToLogin();
          Provider.of<UserLogin>(context)
              .setUserStatus(LoginUserStatus.loggedIn);
        } else {
          _status = AuthResultStatus.emailNotVerified;
        }
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      _status = AuthExceptionHandler.handleException(e);
    }

    return _status;
  }

  // Used for loging out the user
  logout(context) async {
    if (await _googleSignIn.isSignedIn()) {
      _googleSignIn.signOut();
      _googleSignIn.disconnect();
      // Provider.of<UserLogin>(context).modifyToLogout();
      Provider.of<TheUser>(context, listen: false)
          .user_Name("", "", "", [], "");
      Provider.of<UserLogin>(context, listen: false)
          .setUserStatus(LoginUserStatus.loggedOut);
      await _auth.signOut();
    } else {
      await _auth.signOut();
      // Provider.of<UserLogin>(context).modifyToLogout();
      Provider.of<UserLogin>(context, listen: false)
          .setUserStatus(LoginUserStatus.loggedOut);
    }
  }

// Used to change the password of users.
  Future<AuthResultStatus> changeCurrentUserPassword(String email1) async {
    await _auth
        .sendPasswordResetEmail(email: email1)
        .then((value) => {_status = AuthResultStatus.successful})
        .catchError((e) {
      _status = AuthExceptionHandler.handleException(e);
    });

    return _status;
  }

  // This function is used to login user automatically if he is logged in.
  Future<AuthResultStatus> loginIfAlreadyAuthenticated(
      BuildContext context) async {
    try {
      user = _auth.currentUser;
      if (user != null && user.emailVerified) {
        _status = AuthResultStatus.successful;
        TheUser.id = user.uid;
        TheUser.email = user.email;
        // _initializeTheUser(context);
        _status = AuthResultStatus.successful;
      } else {
        _status = AuthResultStatus.userNotFound;
      }
    } catch (e) {
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }
}
