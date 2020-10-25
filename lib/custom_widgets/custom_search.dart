import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app_code/custom_widgets/item_list_tile.dart';

// This will display the search page

class TheCustomSearchPage extends SearchDelegate {
  final BuildContext context;

  TheCustomSearchPage(this.context);

// theme of the search bar which is app bar.
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
              color: Theme.of(context).backgroundColor,
              fontWeight: FontWeight.w300),
        ),
        textTheme: Theme.of(context).primaryTextTheme,
        textSelectionTheme: Theme.of(context).textSelectionTheme,
        primaryColor: Theme.of(context).primaryColor,
        textSelectionHandleColor: Theme.of(context).primaryColor,
        textSelectionColor: Theme.of(context).backgroundColor,
        appBarTheme: AppBarTheme(
          color: Theme.of(context).primaryColor,
        ));
  }

  @override
  // implement keyboardType
  TextInputType get keyboardType => TextInputType.text;

  @override
  TextStyle get searchFieldStyle => TextStyle(
      color: Theme.of(context).backgroundColor, fontWeight: FontWeight.w400);

  @override
  // implement searchFieldLabel
  String get searchFieldLabel => "Search";

  CollectionReference dbRef = FirebaseFirestore.instance.collection("products");

  // No of search results to be displayed on the page
  int _itemsPerPage = 45;

  // list used to build search results.
  List<DocumentSnapshot> resultsList = [];

  // List used to build suggestions.
  List<DocumentSnapshot> suggestionsList = [];

  // fetch suggestions.
  getSuggestions(String suggestionText) async {
    QuerySnapshot theSuggestions = await dbRef
        .where("searchArray",
            arrayContains: suggestionText.trim().toLowerCase())
        .orderBy("name")
        .limit(_itemsPerPage)
        .get();
    suggestionsList = [];
    theSuggestions.docs.forEach((element) {
      suggestionsList.add(element);
    });
    return suggestionsList;
  }

  // fetch search results from firestore.
  Future<List<DocumentSnapshot>> fetchSearchResults(
      String theSearchText) async {
    QuerySnapshot theResults = await dbRef
        .where("searchArray", arrayContains: theSearchText.trim().toLowerCase())
        .orderBy("name")
        .limit(_itemsPerPage)
        .get();
    resultsList = [];
    theResults.docs.forEach((element) {
      resultsList.add(element);
    });
    return resultsList;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // displays a clear button that clears the text entered in search field
    return [
      IconButton(
          icon: Icon(
            Icons.clear,
            color: Theme.of(context).backgroundColor,
          ),
          onPressed: () {
            query = '';
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // displays a back button arrow, which when clicked pops out search and goes back.
    return IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Theme.of(context).backgroundColor,
        ),
        onPressed: () => Navigator.of(context).pop());
  }

  @override
  Widget buildResults(BuildContext context) {
    // The results list.
    return FutureBuilder(
      future: fetchSearchResults(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (resultsList.length == 0) {
            return Center(
              child: Text(
                "The item was not found",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            );
          } else {
            return ListView.builder(
                itemCount: resultsList.length,
                itemBuilder: (context, index) => TheItemListTile(
                      img: resultsList[index].data()["url1"].toString(),
                      docSnap: resultsList[index],
                      prodCategory:
                          resultsList[index].data()["category"].toString(),
                      prodName: resultsList[index].data()["name"],
                      prodPrice: resultsList[index].data()["price"].toString(),
                    ));
          }
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // The suggestions list.
    if (query.length > 0 && query.length % 3 == 0 && query.length < 18) {
      getSuggestions(query);
    }
    return (suggestionsList.length == 0)
        ? Container(
            color: Theme.of(context).backgroundColor,
          )
        : ListView.builder(
            itemCount: suggestionsList.length,
            itemBuilder: (context, index) => ListTile(
                  contentPadding: EdgeInsets.only(top: 5, bottom: 0),
                  title: Text(
                    suggestionsList[index].data()["name"],
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                    query = suggestionsList[index].data()["name"];
                  },
                ));
  }
}
