import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Adds the product to user cart
addThisToCart(String prodId) async {
  var _auth = FirebaseAuth.instance.currentUser.uid;
  await FirebaseFirestore.instance.collection("users").doc(_auth).set({
    "savedItems": FieldValue.arrayUnion([prodId])
  }, SetOptions(merge: true));
}
