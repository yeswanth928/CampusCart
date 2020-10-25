import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app_code/custom_widgets/show_snack_bar.dart';
import 'package:social_app_code/functions/get_cart_products.dart';
import 'package:social_app_code/source_code/prod_page_for_cart.dart';

// This class displays a scaffold that displays an user cart.
class TheCart extends StatefulWidget {
  @override
  _TheCartState createState() => _TheCartState();
}

class _TheCartState extends State<TheCart> {
  List theSavedItems =
      []; // This list will hold the product details of products in user cart.

  List theQueryList =
      []; // This list will hold the product id's of products in user cart.

  String _auth = FirebaseAuth.instance.currentUser.uid; // The user user_id.

  bool _isLoading =
      true; // Used to display a circular progress indicator when the app is getting data from firebase.

  DocumentSnapshot theDoc; // The document snapshot of user stored in firestore.

// Get the items stored in user cart from firebase firestore.
  initalizeList() async {
    theDoc =
        await FirebaseFirestore.instance.collection("users").doc(_auth).get();

    if ((theDoc.data()["savedItems"] == null) ||
        (theDoc.data()["savedItems"].toList().length == 0)) {
      setState(() {
        _isLoading = false;
      });
    }

// the list contains the products in the user cart
    List theDocList = await returnTheProductsInUserCart(theDoc);

    // Adding the products to the lists.
    theDocList.forEach((element) {
      if (element != null) {
        theQueryList.add(element.id);
        theSavedItems.add(element.data());
      }
    });
    setState(() {
      _isLoading = false;
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
          "Saved Products",
          style: TextStyle(color: Theme.of(context).backgroundColor),
        ),
      ),
      body: Builder(
        builder: (context) => Container(
          child: _isLoading == false
              ? ListView.builder(
                  itemCount: theSavedItems.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) {
                          // Following events occur when we dismiss an item from user cart.
                          theSavedItems.remove(theSavedItems[index]);
                          theQueryList.remove(theQueryList[index]);
                          reInitializeCart(_auth, theQueryList);
                          showSnackBar(
                              context: context,
                              theContent:
                                  "The Item has been removed from cart");
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
                          img: theSavedItems[index]["url1"],
                          prodName: theSavedItems[index]["name"],
                          prodCat: theSavedItems[index]["category"],
                          prodPrice: theSavedItems[index]["price"],
                          docSnapID: theQueryList[index].toString(),
                          college: theSavedItems[index]["college"],
                          collegeAddress: theSavedItems[index]
                              ["collegeAddress"],
                          sellerMail: theSavedItems[index]["userEmail"],
                          sellerName: theSavedItems[index]["userName"],
                          prodDesc: theSavedItems[index]["description"],
                          url1: theSavedItems[index]["url1"],
                          url2: theSavedItems[index]["url2"],
                          url3: theSavedItems[index]["url3"],
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

// The products tile that will be displayed in the list.
class TheItemListTile extends StatefulWidget {
  final String img;
  final String prodCat;
  final String prodName;
  final String sellerMail;
  final String prodDesc;
  final String url1;
  final String url2;
  final String url3;
  final String college;
  final String collegeAddress;
  final String prodPrice;
  final String sellerName;
  final String docSnapID; // Document id of product in firestore.
  TheItemListTile(
      {this.img,
      this.prodCat,
      this.docSnapID,
      this.prodDesc,
      this.college,
      this.collegeAddress,
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

  // Get the document of product from firestore.
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
                price: widget.prodPrice,
                prodId: widget.docSnapID,
                name: widget.prodName,
                college: widget.college,
                collegeAddress: widget.collegeAddress,
                sellerMail: widget.sellerMail,
                sellerName: widget.sellerName,
                url1: widget.url1,
                url2: widget.url2,
                url3: widget.url3,
              ))),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.15,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
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
