

import 'package:flutter/material.dart';
import '../basic_features.dart';

class EmptyDataScreen extends StatefulWidget {
  const EmptyDataScreen(
      {super.key,
        this.title,
        this.subTitle,
        this.buttonText,
        this.image,
        this.btnOnTap });

  final String? title, subTitle,image,buttonText;
  final VoidCallback? btnOnTap;


  @override
  State<EmptyDataScreen> createState() => _EmptyDataScreenState();
}

class _EmptyDataScreenState extends State<EmptyDataScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.commonPaddingForScreen),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             Image.asset(
               widget.image ?? "",
               height: Dimensions.h70,
               width: Dimensions.w70,
             ),

            Visibility(
              visible: widget.title != null,
              child: Text(
                widget.title ?? "",
                style: fontStyleSemiBold18.copyWith(height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
            Visibility(
              visible: widget.subTitle != null,
              child: Padding(
                padding: EdgeInsets.only(top: Dimensions.h5),
                child: Text(
                  widget.subTitle ?? "",
                  style: fontStyleRegular14,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: Dimensions.h20,
            ),
            Visibility(
              visible: widget.buttonText != null,
              child: MyButton(
                title: widget.buttonText ?? "",

                onPressed: () {
                  if (widget.btnOnTap != null) {
                    widget.btnOnTap!();
                  }
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
