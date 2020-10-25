import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app_code/custom_widgets/show_modal_sheet.dart';
import 'package:social_app_code/functions/share_product_dynamic_link.dart';
import 'package:social_app_code/models/login_model.dart';
import 'package:social_app_code/models/user.dart';
import 'package:social_app_code/source_code/after_splash.dart';
import 'package:social_app_code/source_code/login_screen.dart';
import 'package:social_app_code/source_code/product_pic.dart';

// Product page that displays a product details
class TheProductPage extends StatefulWidget {
  final DocumentSnapshot theDoc; // document snapshot of product
  final String prodCat; // product category
  final bool isDeepLink; // is the product page displayed on clicking a deeplink

  TheProductPage({Key key, this.theDoc, this.prodCat, this.isDeepLink = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TheProductPage();
  }
}

class _TheProductPage extends State<TheProductPage> {
  bool _buttonState = false;

  @override
  void initState() {
    super.initState();
    // If the user is not logged in and product is not accessed using deeplink the page will pop.
    if ((context.read<UserLogin>().theStatus == LoginUserStatus.loggedOut) &&
        (widget.isDeepLink == false)) {
      Navigator.of(context).pop();
    }
    // If the user is not logged in and product is accessed using deeplink then user will be redirected to login page.
    else if ((context.read<UserLogin>().theStatus ==
            LoginUserStatus.loggedOut) &&
        (widget.isDeepLink == true)) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            child: AppBar(
              title: Text(
                widget.theDoc.data()["name"][0].toString().toUpperCase() +
                    widget.theDoc.data()["name"].toString().substring(1),
                style: TextStyle(color: Theme.of(context).backgroundColor),
                overflow: TextOverflow.ellipsis,
                semanticsLabel:
                    widget.theDoc.data()["name"][0].toString().toUpperCase() +
                        widget.theDoc.data()["name"].toString().substring(1),
              ),
              elevation: 0,
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).backgroundColor,
                  ),
                  onPressed: () {
                    // On clicking the back arrow button if the product page
                    // was opened using deeplink then they are redirected back to homepage
                    // else back to the list view.
                    if (widget.isDeepLink) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => RedirectingClass()));
                    } else {
                      Navigator.of(context).pop();
                    }
                  }),
            ),
            preferredSize: (MediaQuery.of(context).orientation ==
                    Orientation.portrait)
                ? Size.fromHeight(MediaQuery.of(context).size.height * 0.05)
                : Size.fromHeight(MediaQuery.of(context).size.height * 0.1)),
        body: Container(
            child: (MediaQuery.of(context).orientation == Orientation.portrait)
                ? Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(
                                    MediaQuery.of(context).size.height *
                                        0.0125),
                                bottomRight: Radius.circular(
                                    MediaQuery.of(context).size.height *
                                        0.0125))),
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: PageView.builder(
                          controller: PageController(initialPage: 0),
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return ProductPic(
                                widget.theDoc
                                    .data()["url" + (index + 1).toString()],
                                4 / 3);
                          },
                        ),
                      ),
                      Flexible(
                          flex: 11,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: ProductInfo(
                              theButtonstate: _buttonState,
                              prodDoc: widget.theDoc,
                              prodCat: widget.theDoc.data()["category"],
                              sellerName: widget.theDoc.data()["userName"],
                              sellerEmail: widget.theDoc.data()["userEmail"],
                              description: widget.theDoc.data()["description"],
                              price: widget.theDoc.data()["price"],
                              prodname: widget.theDoc.data()["name"],
                              imageUrl: widget.theDoc.data()["url1"],
                              prodID: widget.theDoc.id,
                              college: widget.theDoc.data()["college"],
                              collegeAddress:
                                  widget.theDoc.data()["collegeAddress"],
                            ),
                          ))
                    ],
                  ) //End of the Portrait mode
                : Row(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(
                                      MediaQuery.of(context).size.height *
                                          0.0125))),
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: PageView.builder(
                              itemCount: 3,
                              controller: PageController(initialPage: 0),
                              itemBuilder: (context, index) {
                                return ProductPic("images/eat.jpg", 3 / 4);
                              })),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: ProductInfo(theButtonstate: _buttonState),
                      )
                    ],
                  ) // Updatee this for landscape mode),
            ));
  }
}

// Used to display the product details like price etc.
// ignore: must_be_immutable
class ProductInfo extends StatefulWidget {
  bool theButtonstate;
  String price;
  String description;
  String sellerName;
  String prodCat;
  String prodname;
  String prodID;
  String college;
  String imageUrl;
  String collegeAddress;
  String sellerEmail;
  DocumentSnapshot prodDoc;
  ProductInfo(
      {this.theButtonstate,
      this.description,
      this.prodDoc,
      this.prodCat,
      this.prodname,
      this.prodID,
      this.price,
      this.college,
      this.imageUrl,
      this.collegeAddress,
      this.sellerName,
      this.sellerEmail});
  @override
  State<StatefulWidget> createState() {
    return _ProductInfo();
  }
}

class _ProductInfo extends State<ProductInfo> {
  String theId;
//  function to add product to cart
  addToCart() async {
    var _auth = TheUser.id;
    await FirebaseFirestore.instance.collection("users").doc(_auth).set({
      "savedItems": FieldValue.arrayUnion([widget.prodDoc.id.toString()])
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    theId = widget.prodID;
    return Column(
      children: <Widget>[
        Expanded(
            flex: 2,
            child: Container(
                child: Row(
              children: <Widget>[
                Container(
                  width: (MediaQuery.of(context).orientation ==
                          Orientation.portrait)
                      ? MediaQuery.of(context).size.width * 0.75
                      : MediaQuery.of(context).size.width * 0.4,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "Price : " + widget.price + " .Rs",
                    overflow: TextOverflow.ellipsis,
                    semanticsLabel: "Price : " + widget.price,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline6.color),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        icon: Icon(
                          Icons.add,
                          size: 30,
                          color: Theme.of(context).iconTheme.color,
                          semanticLabel: "Save this product.",
                        ),
                        onPressed: () {
                          addToCart();
                          // function to add details of this product to the user products list.
                        }),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        icon: Icon(
                          Icons.share,
                          semanticLabel: "Share this product",
                        ),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          // on clicking this button you can share the produt dynamic links on various platforms.
                          shareProductDynamicLink(theId, widget.imageUrl);
                        }),
                  ),
                )
              ],
            ))),
        Expanded(
            flex: 6,
            child: SingleChildScrollView(
              child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(10),
                  child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: "Description : ",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600)),
                        TextSpan(
                            text: widget.description,
                            style: TextStyle(color: Colors.black))
                      ]))),
              scrollDirection: Axis.vertical,
            )),
        Expanded(
            flex: 2,
            child: ListTile(
              title: Text(
                "Contact Seller",
                style: TextStyle(
                    color: Theme.of(context).textTheme.headline6.color),
              ),
              trailing: Icon(Icons.keyboard_arrow_up,
                  color: Theme.of(context).primaryColor),
              subtitle: Text(
                widget.sellerName,
                style: TextStyle(
                    color: Theme.of(context).textTheme.subtitle2.color),
              ),
              onTap: () {
                showModalSheet(context,
                    sellerName: widget.sellerName,
                    sellerEmail: widget.sellerEmail,
                    prodID: widget.prodID,
                    imgURl: widget.imageUrl,
                    prodName: widget.prodname,
                    prodPrice: widget.price);
              },
            ))
      ],
    );
  }
}
