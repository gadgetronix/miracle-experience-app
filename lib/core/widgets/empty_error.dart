import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../basic_features.dart';

class MyErrorWidget extends StatelessWidget {
  final String? message;
  final Function? onPress;
  final double? height;

  const MyErrorWidget(this.message, {super.key, this.onPress,this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height??double.infinity,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(message??"",
              textAlign: TextAlign.center,
              style: fontStyleRegular14.apply(color: ColorConst.dialogRedColor)),
        ),
      ),
    );
  }
}

class MyEmptyWidget extends StatelessWidget {
  final String message;
  final Function? onPress;
  const MyEmptyWidget( this.message, {super.key, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(message,
            textAlign: TextAlign.center,
            style: fontStyleRegular14.apply(color: ColorConst.textColor)),
      ),
    );
  }
}


class EmptyLoaderWidget extends StatelessWidget {
  const EmptyLoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CupertinoActivityIndicator(
        color: Colors.black,
      ),
    );
  }
}