import 'package:cloud_firestore/cloud_firestore.dart';

// Gets the products stored in user cart from firebase firestore
Future<List<QueryDocumentSnapshot>> returnTheProductsInUserCart(
    DocumentSnapshot firestoreDoc) async {
// firestoreDoc => The Firebase Firestore document of user from which the saved items has to be obtained.

  QuerySnapshot theQuery = await FirebaseFirestore.instance
      .collection("products")
      .where(FieldPath.documentId,
          whereIn: firestoreDoc.data()["savedItems"].toList())
      .get();
  return theQuery.docs;
}

// Upon deleting the item in user cart, the products stored in firestore are updated.
void reInitializeCart(String auth, List updatedList) async {
  // auth => the user id(string type)

  // updtaedList => the new list that has to be updated in firestore

  await FirebaseFirestore.instance
      .collection("users")
      .doc(auth)
      .update({"savedItems": updatedList});
}
