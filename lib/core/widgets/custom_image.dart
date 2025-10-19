import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import '../basic_features.dart';


class CustomNetworkImage extends StatelessWidget {
  final double? height;
  final double? width;
  final String image;
  final BoxFit? fitType;
  final bool showLoader;

  const CustomNetworkImage({
    super.key,
    this.height,
    this.width,
    required this.image,
    this.fitType,
    this.showLoader = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width ?? double.infinity,
      child: CachedNetworkImage(
        fit: fitType ?? BoxFit.cover,
        imageUrl: image,
        placeholder:
            showLoader
                ? (context, url) =>
                    const Center(child: CupertinoActivityIndicator(radius: 10))
                : null,
        errorWidget:
            (context, url, error) =>
                Image.asset(ImageAsset.icLogo, fit: BoxFit.fill),
      ),
    );
  }
}


class CustomRoundCornerNetworkImage extends StatelessWidget {
  final double? height;
  final double? width;
  final double radius;
  final String image;

  const CustomRoundCornerNetworkImage({
    super.key,
    this.height,
    this.width,
    this.radius = 10,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width ?? double.infinity,
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        filterQuality: FilterQuality.none,
        imageBuilder: (context, provider) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: ColorConst.greyColor, width: 1),
              borderRadius: BorderRadius.circular(radius),
              image: DecorationImage(image: provider, fit: BoxFit.cover),
            ),
          );
        },
        /*imageBuilder: (context,provider){
            return ClipRRect(
              borderRadius: BorderRadius.circular(radius), child: Image(images: provider,));
          },*/
        imageUrl: image,
        placeholder:
            (context, url) => const Center(
              child: CupertinoActivityIndicator(
                color: ColorConst.primaryColor,
                radius: 10,
              ),
            ),
        errorWidget:
            (context, url, error) => ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Image.asset(ImageAsset.icLogo),
            ),
      ),
    );
  }
}

class MyRoundCornerAssetImage extends StatelessWidget {
  final double height;
  final double? width;
  final double radius;
  final Color? imageColor;
  final String image;

  const MyRoundCornerAssetImage({
    super.key,
    required this.height,
    this.width,
    this.imageColor,
    this.radius = 10,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(
        image,
        fit: BoxFit.contain,
        height: height,
        width: width,
        color: imageColor,
      ),
    );
  }
}
