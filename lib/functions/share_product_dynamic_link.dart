import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share/share.dart';
// import 'package:image_downloader/image_downloader.dart';

// Allows sharing of product dynamic link using whatsapp etc.
Future<void> shareProductDynamicLink(String theId, String theImageUrl) async {
  // The app logo url stored in firebase storage
  Uri appLogo = Uri.parse(
      "https://firebasestorage.googleapis.com/v0/b/social-app-code.appspot.com/o/ProjectResources%2Flogo_with_background_and_name.png?alt=media&token=9c6722f8-e630-431d-9448-78d7823eb281");

  final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://campuscart.page.link',
      link: Uri.parse('https://campuscart.page.link.com/?prodId=$theId'),
      androidParameters: AndroidParameters(
        packageName: "com.example.testin1",
        // minimumVersion: 16,
      ),
      socialMetaTagParameters:
          SocialMetaTagParameters(title: "Camps Cart", imageUrl: appLogo));
  // The dynamic link generated
  final Uri dynamiclink = await parameters.buildUrl();
  // var imageId = await ImageDownloader.downloadImage(theImageUrl);
  // var path = await ImageDownloader.findPath(imageId);

  Share.share("Check this product on Campus Cart $dynamiclink");
}
