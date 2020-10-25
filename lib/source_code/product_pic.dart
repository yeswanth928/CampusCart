import 'package:flutter/material.dart';

// Used by product page to display image
class ProductPic extends StatelessWidget {
  final String imageName; // The image url
  final double aspectRatio; // Aspect ratio of image

  ProductPic(this.imageName, this.aspectRatio);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: AspectRatio(
        aspectRatio: this.aspectRatio,
        child: Card(
          clipBehavior: Clip.hardEdge,
          color: Theme.of(context).primaryColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7.5
                  // MediaQuery.of(context).size.width * 0.05
                  ),
              side: BorderSide(
                  width: 4,
                  color: Theme.of(context).backgroundColor,
                  style: BorderStyle.solid)),
          child: Image.network(this.imageName),
        ),
      ),
    );
  }
}
