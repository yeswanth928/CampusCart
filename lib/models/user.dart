import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
// import 'package:social_app_code/authentication/auth_exception_handling.dart';
// import 'package:social_app_code/authentication/authenticator.dart';

enum UserStatus { loggedIn, loggedOut }

class TheUser extends ChangeNotifier {
  static String
      id; // should not change once the app is created but can't be made final because we can aet the user variables after authenticating.

  static String email;
  String name;
  String college;
  String collegeAddress;
  String avatar = "images/avatar1.png";

  List savedItems;

  static UserStatus status;

  final theInst = FirebaseFirestore.instance;

// Adds product to user cart
  addProductToSaved(DocumentSnapshot val) {
    savedItems.add(val.data());
    FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({'savedItems': savedItems});
    notifyListeners();
  }

// Removes the product from the user cart
  removePrdouctFromSaved(DocumentSnapshot val) {
    savedItems.remove(val.data());
    FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({'savedItems': savedItems});
    notifyListeners();
  }

// Changes the avatar of the user
  changeUserAvatar(int avatarNumber) {
    avatar = "images/avatar$avatarNumber.png";
    FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({'avatar': avatar});
    notifyListeners();
  }

  bool isProductSaved(DocumentSnapshot val) {
    if (savedItems.contains(val)) {
      return true;
    } else {
      return false;
    }
  }

  getSaved() {
    return savedItems;
  }

  getStatus() {
    return status;
  }

  String userName() {
    return name;
  }

  String userCollege() {
    return college;
  }

  String userCollegeAddress() {
    return collegeAddress;
  }

  // setters for User class

  // ignore: non_constant_identifier_names
  void user_Name(String thename, String thecollege, String thecollegeAddress,
      List thesavedItem, String theAvatar) {
    name = thename;
    college = thecollege;
    collegeAddress = thecollegeAddress;
    savedItems = thesavedItem;
    avatar = theAvatar;
    // theAvatar;
    notifyListeners();
  }

  // modifyStatus(UserStatus value) {
  //   status = value;
  //   notifyListeners();
  // }

  // updateStatus(context) {
  //   FireBaseAuthenticationHelper().loginIfAlreadyAuthenticated(context);
  //   notifyListeners();
  // }

  // set userCollege(String college) {
  //   college = college;
  //   notifyListeners();
  // }

  // set userCollegeAddress(String collegeAddress) {
  //   collegeAddress = collegeAddress;
  //   notifyListeners();
  // }

  // set userFromFirebase(User user) {
  //   id = user.uid;

  //   var theUserRef = theInst.collection('user').document(user.uid);
  //   theUserRef.get().then((value) => {
  //         name = value.data.na
  //         college = value.data['college'],
  //         collegeAddress = value.data['collegeAddress'],
  //       });
  //   notifyListeners();
  // }
}
