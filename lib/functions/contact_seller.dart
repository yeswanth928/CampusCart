import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

//enters a prebuilt message to body of email and fills the receiver name automatically.
contactTheSeller(
    {String theEmail,
    String nameOfProduct,
    String theId,
    // String imgUrl,
    String price,
    String sellerName}) async {
  final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://campuscart.page.link',
      link: Uri.parse('https://campuscart.page.link.com/?prodId=$theId'),
      androidParameters: AndroidParameters(
        packageName: "com.example.testin1",
        // minimumVersion: 16,
      ));
  final Uri thelink = await parameters.buildUrl();

  String theBody =
      "<p>Hi $sellerName,</p> <p>I'm interested in your product, that you offered to sell on Campus Cart Application</p> <p>$thelink</p> <p> I would like to buy it. Please reply back to this email address</p>";
  String subject =
      "Interested in buying the product that was posted on Campus Cart";

  final Email email = Email(
    body: theBody,
    subject: subject,
    recipients: [theEmail],
    isHTML: true,
  );

  await FlutterEmailSender.send(email);
}
