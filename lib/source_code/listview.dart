import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app_code/custom_widgets/custom_search.dart';
import 'package:social_app_code/custom_widgets/item_list_tile.dart';
import 'package:social_app_code/custom_widgets/show_dialog.dart';
import 'main_drawer.dart';

// The list that will be displayed on choosing a category in TheHomePageView.
// If the college and zip code entered are not proper or if college and zip code is not entered, then an dialog is displayed and users are navigated back to home screen after 2 seconds.
class TheListView extends StatefulWidget {
  final String category; // The category choosen from TheHomePageView.
  TheListView({Key key, @required this.category}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TheListView();
  }
}

DocumentSnapshot nextDocument;
DocumentSnapshot prevDocument; // points to last document of previous page.

// Remember, we can’t load Material App again and again,
// it’s loaded when the application is started.
//  However, we can shuffle between different scaffolds within the MaterialApp.

class _TheListView extends State<TheListView> {
  final _thescaffoldkey = GlobalKey<ScaffoldState>();
  // final ScrollController _gridScroll = ScrollController();

  int _itemsInCurrentPage = 0;

  bool _shouldEnableNextButton = true;

  bool _isloading = true; // If true circular progress bar is displayed.

  final _itemsPerPage = 10; // No of items to be displayed in a page.

  // int noOfPages = 5; // Variable used to store the no of pages.

  int _currentPage = 0; // variable used to store the current page number.

  bool _isEndPage = false; // Used to identify if the page is end page.

  List<String> saved = [];

  DocumentSnapshot userDoc; // The user details.

  List<DocumentSnapshot> results =
      []; // The list that stores the details that will be dispalyed in that page.

  // _fetch() {} // ***use this function to fetch the data from network and should add the data in results list. or else code should be modified.***

// Fetch next page from firestore.
  _fetchNext() async {
    setState(() {
      _isloading = true;
    });
    CollectionReference dbRef =
        FirebaseFirestore.instance.collection("products");

    /// Change products to widget.value
    QuerySnapshot eventsQuery = await dbRef
        .where("category", isEqualTo: widget.category)
        .where("college", isEqualTo: userDoc.data()["college"])
        .where("collegeAddress", isEqualTo: userDoc.data()["collegeAddress"])
        .orderBy("name")
        .limit(_itemsPerPage)
        .startAfterDocument(nextDocument)
        .get();

    // print(nextDocument.data()["name"].toString());
    List<DocumentSnapshot> documentList = eventsQuery.docs;
    if (documentList.length == 0) {
      setState(() {
        _isloading = false;
      });
    }
    _itemsInCurrentPage = documentList.length;

    if (_itemsInCurrentPage < _itemsPerPage) {
      if (_itemsInCurrentPage == 0) {
        showAlertDialogBox(
            context, "There aren't any more products to display", "Info");
        _currentPage -= 1;
        _itemsInCurrentPage = results.length;
        prevDocument = results[0];
      } else {
        _isEndPage = true;
        results.clear();
        prevDocument = documentList[0];
        documentList.forEach((element) {
          results.add(element);
        });
      }
    } else {
      _isEndPage = false;
      results.clear();
      prevDocument = documentList[0];
      nextDocument = documentList[_itemsInCurrentPage - 1];
      documentList.forEach((element) {
        results.add(element);
      });
    }
    setState(() {
      results = results;
      _isloading = false;
    });
    // print(results[0].data()["name"].toString());
  }

// Fetch the last page from firestore.
  _fetchPrevious() async {
    setState(() {
      _isloading = true;
    });
    CollectionReference dbRef = FirebaseFirestore.instance
        .collection("products"); // change products to widget.value

    /// Change products to widget.value
    QuerySnapshot eventsQuery = await dbRef
        .where("category", isEqualTo: widget.category)
        .where("college", isEqualTo: userDoc.data()["college"])
        .where("collegeAddress", isEqualTo: userDoc.data()["collegeAddress"])
        .orderBy("name")
        .limitToLast(_itemsPerPage)
        .endBeforeDocument(prevDocument)
        .get();
    _isEndPage = false;
    results.clear();
    // print(prevDocument.data()["name"].toString());
    List<DocumentSnapshot> documentList = eventsQuery.docs;
    if (documentList.length == 0) {
      setState(() {
        _isloading = false;
      });
    }
    _itemsInCurrentPage = documentList.length;
    prevDocument = documentList[0];
    nextDocument = documentList[_itemsInCurrentPage - 1];
    documentList.forEach((element) {
      results.add(element);
    });
    setState(() {
      _isloading = false;
    });
    // print(results[0].data()["name"].toString());
  }

  // get the user details.
  Future<void> initializeUser() async {
    String userId = FirebaseAuth.instance.currentUser.uid;
    userDoc =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();
    if (!userDoc.exists) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(
                  "Info",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                content: Text(
                    "Please make sure you have entered proper college name and Zip Code."),
              ));

      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      });
    }
  }

  callInitialize() async {
    await initializeUser();
    _fetch();
  }

// Fetch the initial page from firestore.
  _fetch() async {
    setState(() {
      _isloading = true;
    });
    CollectionReference dbRef = FirebaseFirestore.instance
        .collection("products"); // change products to widget.value
    QuerySnapshot eventsQuery = await dbRef
        .where("category", isEqualTo: widget.category)
        .where("college", isEqualTo: userDoc.data()["college"] ?? "college")
        .where("collegeAddress",
            isEqualTo: userDoc.data()["collegeAddress"] ?? "collegeAddress")
        .orderBy("name")
        .limit(_itemsPerPage)
        .get();

    List<DocumentSnapshot> documentsList = eventsQuery.docs;
    if (documentsList.length == 0) {
      setState(() {
        _shouldEnableNextButton = false;
        _isloading = false;
      });
    }
    _itemsInCurrentPage = documentsList.length;
    _isEndPage = false;
    if (_itemsInCurrentPage != 0) {
      nextDocument = documentsList[_itemsInCurrentPage - 1];
    }

    // print(nextDocument.data()["name"].toString());
    documentsList.forEach((element) {
      results.add(element);
    });
    setState(() {
      _isloading = false;
    });
    // print(results[0].data()["name"].toString());
  }

  @override
  void initState() {
    if (_currentPage == 0) {
      _currentPage += 1;
      callInitialize();
      // _fetch();
    }
    super.initState();
  }

  // var theItems =
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _thescaffoldkey,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.color,
          leading: IconButton(
              icon: Icon(
                Icons.search,
                color: Theme.of(context).appBarTheme.iconTheme.color,
              ),
              onPressed: () {
                showSearch(
                    context: context, delegate: TheCustomSearchPage(context));
              }),
          title: Text(
            "Select the product",
            style: TextStyle(
                fontSize:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? MediaQuery.of(context).size.height * 0.03
                        : MediaQuery.of(context).size.height * 0.05,
                color: Theme.of(context).appBarTheme.textTheme.headline1.color),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        ),
        endDrawer: Drawer(
          semanticLabel: "Menu",
          child: TheMainDrawer(),
        ),
        body: (_isloading == false)
            ? Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.82,
                    child: results.length != 0
                        ? ListView(
                            children: [
                              ListView.builder(
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _itemsInCurrentPage,
                                  // _itemsPerPage,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      child: TheItemListTile(
                                          img: results[index]
                                              .data()["url1"]
                                              .toString(),
                                          // results[index].data()["url1"],
                                          // "images/eat.jpg",
                                          docSnap: results[index],
                                          prodCategory: widget.category,
                                          prodName:
                                              results[index].data()["name"],
                                          prodPrice: results[index]
                                              .data()["price"]
                                              .toString()),
                                      // results[index].data()["price"]),
                                      splashColor:
                                          Theme.of(context).splashColor,
                                      onTap: () {},
                                    );
                                  })
                            ],
                          )
                        : Container(
                            color: Theme.of(context).backgroundColor,
                            child: Center(
                              child: Text(
                                "Sorry there's no products yet",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: Row(
                      children: [
                        Expanded(
                            child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                                onPressed: () {
                                  if (_currentPage == 1) {
                                    showAlertDialogBox(context,
                                        "This is the Starting Page", "Info");
                                  } else {
                                    // _previousPage();
                                    _currentPage -= 1;
                                    _fetchPrevious();
                                  }
                                })),
                        Expanded(
                            child: Text(
                          _currentPage.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color:
                                  Theme.of(context).textTheme.headline6.color),
                          textAlign: TextAlign.center,
                        )),
                        Expanded(
                            child: IconButton(
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                                disabledColor: Colors.grey[400],
                                onPressed: () {
                                  if (_shouldEnableNextButton) {
                                    if (_isEndPage == true) {
                                      showAlertDialogBox(context,
                                          "You have reached the End", "Info");
                                    } else {
                                      // _nextPage();
                                      _currentPage += 1;
                                      _fetchNext();
                                    }
                                  }
                                }))
                      ],
                    ),
                  )
                ],
              )
            : Container(
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.height * 0.1,
                  child: CircularProgressIndicator(),
                ),
              ));
  }
}
