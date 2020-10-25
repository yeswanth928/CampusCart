import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

reportTheProduct(
    {String theEmail, // The email of the owner who posted the product
    String nameOfProduct, // The product name
    String theId, // The product id
    String sellerName}) async {
  String appEmail =
      "yeswanthkumar052000@gmail.com"; // The Email to which we have to report the product (support email).

  final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://campuscart.page.link',
      link: Uri.parse('https://campuscart.page.link.com/?prodId=$theId'),
      androidParameters: AndroidParameters(
        packageName: "com.example.testin1",
        // minimumVersion: 16,
      ));
  final Uri thelink = await parameters.buildUrl();

  String theBody =
      "<p>Hi, I would like to report this product</p><p>Product Id: $theId</p><p>Owner Email:$theEmail</p><p>$thelink</p><p>Because, </p>";
  String subject = "Reporting a product that was posted on Campus Cart";

  final Email email = Email(
    body: theBody,
    subject: subject,
    recipients: [appEmail],
    isHTML: true,
  );

  await FlutterEmailSender.send(email);
}
