import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:social_app_code/custom_widgets/show_snack_bar.dart';
import 'package:social_app_code/source_code/prod_page_for_cart.dart';

// The class used to display the list of items that the user has offered to sell
class TheUserAddedProducts extends StatefulWidget {
  @override
  _TheuserAddedProducts createState() => _TheuserAddedProducts();
}

class _TheuserAddedProducts extends State<TheUserAddedProducts> {
  List theAddedItems = []; // The list the stores the user items
  String _auth = FirebaseAuth.instance.currentUser.uid;
  bool _isLoading = true; // Used to set circular progress indicator
  var _itemToBeRemoved; // Takes the item to delete if the user wishes to delete

  initalizeList() async {
    DocumentSnapshot theDoc =
        await FirebaseFirestore.instance.collection("users").doc(_auth).get();

    if ((theDoc.data()["addedItems"] == null) ||
        (theDoc.data()["addedItems"].toList().length == 0)) {
      setState(() {
        _isLoading = false;
      });
    }
    List theDocList = theDoc.data()["addedItems"].toList();

    theDocList.forEach((element) {
      theAddedItems.add(element);
    });
    setState(() {
      _isLoading = false;
    });
  }

  reInitializeTheList() async {
    List<String> urls = [
      _itemToBeRemoved["url1"],
      _itemToBeRemoved["url2"],
      _itemToBeRemoved["url3"]
    ];
    await FirebaseFirestore.instance
        .collection("users")
        .doc(_auth)
        .update({"addedItems": theAddedItems});
    await FirebaseFirestore.instance
        .collection("products")
        .doc(_itemToBeRemoved["pid"])
        .delete();
    urls.forEach((element) async {
      await FirebaseStorage.instance
          .ref()
          .getStorage()
          .getReferenceFromUrl(element)
          .then((value) => value.delete());
    });
  }

  @override
  initState() {
    initalizeList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Products",
          style: TextStyle(color: Theme.of(context).backgroundColor),
        ),
      ),
      body: Builder(
        builder: (context) => Container(
          child: _isLoading == false
              ? ListView.builder(
                  itemCount: theAddedItems.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) {
                          _itemToBeRemoved = theAddedItems[index];
                          theAddedItems.remove(theAddedItems[index]);
                          // We are deleting the item from firestore and removing the item from the list
                          reInitializeTheList();
                          // _scaffoldKey.currentState.removeCurrentSnackBar();
                          // After deleting the item from firestore and deleting a snackbar will be displayed.
                          showSnackBar(
                              context: context,
                              theContent:
                                  "The item has been successfully removed.");
                        },
                        background: Container(
                          color: Theme.of(context).primaryColor,
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(left: 15),
                                    child: Icon(
                                      Icons.delete,
                                      color: Theme.of(context).backgroundColor,
                                    ),
                                  )),
                              Expanded(flex: 3, child: Container()),
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.only(right: 15),
                                    child: Icon(
                                      Icons.delete,
                                      color: Theme.of(context).backgroundColor,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        child: TheItemListTile(
                          img: theAddedItems[index]["url1"],
                          prodName: theAddedItems[index]["name"],
                          prodCat: theAddedItems[index]["category"],
                          prodPrice: theAddedItems[index]["price"],
                          docSnapID: theAddedItems[index]["id"],
                          sellerMail: theAddedItems[index]["userEmail"],
                          sellerName: theAddedItems[index]["userName"],
                          prodDesc: theAddedItems[index]["description"],
                          url1: theAddedItems[index]["url1"],
                          url2: theAddedItems[index]["url2"],
                          url3: theAddedItems[index]["url3"],
                        ));
                  })
              : Container(
                  alignment: Alignment.center,
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.height * 0.1,
                      child: CircularProgressIndicator())),
        ),
      ),
    );
  }
}

// The list tile
class TheItemListTile extends StatefulWidget {
  final String img;
  final String prodCat;
  final String prodName;
  final String sellerMail;
  final String prodDesc;
  final String url1;
  final String url2;
  final String url3;
  final String prodPrice;
  final String sellerName;
  final String docSnapID;
  TheItemListTile(
      {this.img,
      this.prodCat,
      this.docSnapID,
      this.prodDesc,
      this.url1,
      this.url2,
      this.url3,
      this.sellerMail,
      this.prodName,
      this.prodPrice,
      this.sellerName});
  @override
  State<StatefulWidget> createState() {
    return _TheItemListTile();
  }
}

class _TheItemListTile extends State<TheItemListTile> {
  IconData tileTraiIcon = Icons.add_circle_outline;
  DocumentSnapshot theDocSnap;

  _fetchDocument() async {
    theDocSnap = await FirebaseFirestore.instance
        .collection(widget.prodCat)
        .doc(widget.docSnapID)
        .get();
  }

  @override
  void initState() {
    _fetchDocument();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TheCartProductPage(
                theDoc: theDocSnap,
                prodCat: widget.prodCat,
                description: widget.prodDesc,
                prodId: widget.docSnapID,
                price: widget.prodPrice,
                name: widget.prodName,
                sellerMail: widget.sellerMail,
                sellerName: widget.sellerName,
                url1: widget.url1,
                url2: widget.url2,
                url3: widget.url3,
              ))),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.15,
        child: Card(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: NetworkImage(
                        widget.img,
                      ),
                    ),
                  ),
                ),
                flex: 2,
              ),
              Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.prodName,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .color),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.prodPrice,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .color),
                          ),
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
