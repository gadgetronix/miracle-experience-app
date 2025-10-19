import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../basic_features.dart';

class MyNetworkImage extends StatelessWidget {
  final double? height;
  final double? width;
  final String image;
  final BoxFit? fitType;

  const MyNetworkImage(
      {super.key, this.height, this.width, required this.image, this.fitType});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height,
        width: width ?? double.infinity,
        child: CachedNetworkImage(
            fit: fitType ?? BoxFit.cover,
            imageUrl: image,
            placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: ColorConst.shimmerBaseColor,
                  highlightColor: ColorConst.shimmerHighLightColor,
                  child: Container(
                    height: height,
                    color: ColorConst.primaryColor,
                  ),
                ),
            errorWidget: (context, url, error) => Image.asset(
                  ImageAsset.icPlaceHolder,
                  fit: BoxFit.fill,
                )));
  }
}

class MyCircleNetworkImage extends StatelessWidget {
  final double? radius;
  final String image;

  const MyCircleNetworkImage({
    super.key,
    this.radius,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: radius ?? Dimensions.r10,
      child: CachedNetworkImage(
        fit: BoxFit.fill,
        filterQuality: FilterQuality.none,
        imageBuilder: (context, provider) {
          return CircleAvatar(
            radius: radius,
            backgroundImage: provider,
          );
        },
        imageUrl: image,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: ColorConst.shimmerBaseColor,
          highlightColor: ColorConst.shimmerHighLightColor,
          child: CircleAvatar(
            radius: radius,
          ),
        ),
        errorWidget: (context, url, error) => CircleAvatar(
          radius: radius,
          backgroundColor: Colors.grey,
          backgroundImage: AssetImage(ImageAsset.icPlaceHolder,),
        ),
      ),
    );
  }
}

class MyRoundCornerNetworkImage extends StatelessWidget {
  final double? height;
  final double? width;
  final double radius;
  final int cacheWidth;
  final Color borderColor;
  final String image;

  const MyRoundCornerNetworkImage({
    super.key,
    this.height,
    this.cacheWidth = 300,
    this.borderColor = Colors.white,
    this.width,
    this.radius = 8,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
          border: Border.all(color: borderColor, width: 0.7)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: CachedNetworkImage(
            fit: BoxFit.cover,
            memCacheWidth: cacheWidth,
            height: height,
            width: width,
            filterQuality: FilterQuality.none,
            imageUrl: image,
            placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: ColorConst.shimmerBaseColor,
                  highlightColor: ColorConst.shimmerHighLightColor,
                  child: Container(
                    height: height,
                    width: width,
                    color: ColorConst.primaryColor,
                  ),
                ),
            errorWidget: (context, url, error) => ClipRRect(
                borderRadius: BorderRadius.circular(
                  radius,
                ),
                child: Image.asset(ImageAsset.icPlaceHolder))),
      ),
    );
  }
}



class MyRoundCornerFileImage extends StatelessWidget {
  final double height;
  final double? width;
  final double radius;
  final File? image;

  const MyRoundCornerFileImage({
    super.key,
    required this.height,
    this.width,
    this.radius = 10,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width ?? double.infinity,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: ColorConst.greyColor, width: 0.5),
          borderRadius: BorderRadius.circular(radius),
          image: DecorationImage(
            image: FileImage(image!),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
