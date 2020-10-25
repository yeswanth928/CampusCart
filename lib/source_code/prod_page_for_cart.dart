import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app_code/custom_widgets/show_modal_sheet.dart';
import 'package:social_app_code/functions/share_product_dynamic_link.dart';
import 'package:social_app_code/source_code/product_pic.dart';

// The product page for products in cart
class TheCartProductPage extends StatefulWidget {
  final DocumentSnapshot theDoc;
  final String prodId;
  final String prodCat;
  final String name;
  final String sellerName;
  final String sellerMail;
  final String description;
  final String url1;
  final String college;
  final String collegeAddress;
  final String url2;
  final String url3;
  final String price;

  TheCartProductPage(
      {Key key,
      this.theDoc,
      this.prodCat,
      this.description,
      this.name,
      this.prodId,
      this.college,
      this.collegeAddress,
      this.price,
      this.sellerMail,
      this.sellerName,
      this.url1,
      this.url2,
      this.url3})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TheCartProductPage();
  }
}

class _TheCartProductPage extends State<TheCartProductPage> {
  bool _buttonState = false;

  List urlList = [];

  @override
  void initState() {
    urlList.add(widget.url1);
    urlList.add(widget.url2);
    urlList.add(widget.url3);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            child: AppBar(
              title: Text(
                widget.name[0].toString().toUpperCase() +
                    widget.name.toString().substring(1),
                style: TextStyle(color: Theme.of(context).backgroundColor),
                overflow: TextOverflow.ellipsis,
                semanticsLabel: widget.name[0].toString().toUpperCase() +
                    widget.name.toString().substring(1),
              ),
              elevation: 0,
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
                            return ProductPic(urlList[index].toString(), 4 / 3);
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
                              prodCat: widget.prodCat,
                              prodID: widget.prodId,
                              prodname: widget.name,
                              college: widget.college,
                              imageUrl: widget.url1,
                              collegeAddress: widget.collegeAddress,
                              sellerName: widget.sellerName,
                              sellerEmail: widget.sellerMail,
                              description: widget.description,
                              price: widget.price,
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
  String imageUrl;
  String college;
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
      this.imageUrl,
      this.price,
      this.college,
      this.collegeAddress,
      this.sellerName,
      this.sellerEmail});
  @override
  State<StatefulWidget> createState() {
    return _ProductInfo();
  }
}

class _ProductInfo extends State<ProductInfo> {
  @override
  Widget build(BuildContext context) {
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
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        icon: Icon(
                          Icons.share,
                          semanticLabel: "Share this product",
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          shareProductDynamicLink(
                              widget.prodID, widget.imageUrl);
                        }),
                  ),
                )
              ],
            ))),
        Expanded(
            flex: 6,
            child: SingleChildScrollView(
              // padding: EdgeInsets.only(top: 5),
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
                      ]))
                  // Text(widget.description),
                  ),
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
