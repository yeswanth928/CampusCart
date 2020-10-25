import 'package:flutter/material.dart';
import 'package:social_app_code/functions/contact_seller.dart';
import 'package:social_app_code/functions/report_product.dart';

void showModalSheet(context,
    {String sellerName,
    String sellerEmail,
    String prodName,
    String prodID,
    String imgURl,
    String prodPrice}) {
  showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(MediaQuery.of(context).size.height * 0.0125),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
            child: ListView(
          children: <Widget>[
            // The list tile used to display seller name.
            ListTile(
              title: Text(
                sellerName, // The name of the seller
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Theme.of(context).textTheme.headline6.color),
              ),
              subtitle: Text(
                "Name",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Theme.of(context).textTheme.subtitle2.color),
              ),
            ),
            // The list tile used to contact the seller using email.
            ListTile(
              title: Text(
                sellerEmail, // The email of seller.
                overflow: TextOverflow.ellipsis,
                semanticsLabel: sellerEmail,
                style: TextStyle(
                    color: Theme.of(context).textTheme.headline6.color),
              ),
              subtitle: Text(
                "Email",
                style: TextStyle(
                    color: Theme.of(context).textTheme.subtitle2.color),
              ),
              trailing: IconButton(
                  color: Theme.of(context).iconTheme.color,
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    await contactTheSeller(
                        theEmail: sellerEmail,
                        sellerName: sellerName,
                        theId: prodID,
                        nameOfProduct: prodName,
                        price: prodPrice);
                  }),
            ),
            // The list tile used to report the product to app support.
            ListTile(
              title: Text(
                "Report the Product",
                overflow: TextOverflow.ellipsis,
                semanticsLabel: "Report the Product",
                style: TextStyle(
                    color: Theme.of(context).textTheme.headline6.color),
              ),
              onTap: () async {
                await reportTheProduct(
                    theEmail: sellerEmail,
                    sellerName: sellerName,
                    theId: prodID,
                    nameOfProduct: prodName);
              },
            )
          ],
        ));
      });
}
