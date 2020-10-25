import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app_code/functions/add_product_to_cart.dart';
import 'package:social_app_code/source_code/product_page.dart';

//List Tiles to display images.

class TheItemListTile extends StatefulWidget {
  final String img;
  final String prodCategory;
  final String prodName;
  final String prodPrice;
  final String sellerName;
  final DocumentSnapshot docSnap;
  TheItemListTile(
      {this.img,
      this.docSnap,
      this.prodCategory,
      this.prodName,
      this.prodPrice,
      this.sellerName});
  @override
  State<StatefulWidget> createState() {
    return _TheItemListTile();
  }
}

class _TheItemListTile extends State<TheItemListTile> {
  IconData tileTraiIcon = Icons.add;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TheProductPage(
                    theDoc: widget.docSnap,
                    prodCat: widget.prodCategory,
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
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600
                                // color: Theme.of(context)
                                //     .textTheme
                                //     .headline6
                                //     .color
                                ),
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
              Expanded(
                  flex: 1,
                  child: IconButton(
                      icon: Icon(
                        this.tileTraiIcon,
                        size: 30,
                        color: Theme.of(context).iconTheme.color,
                        semanticLabel: "Save this to Cart",
                      ),
                      onPressed: () async {
                        if (this.tileTraiIcon == Icons.add) {
                          await addThisToCart(widget.docSnap.id.toString());
                          setState(() {
                            this.tileTraiIcon = Icons.beenhere;
                          });
                        }
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
