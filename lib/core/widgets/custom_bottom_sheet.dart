import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../basic_features.dart';

class CustomBottomSheet {
  CustomBottomSheet._();

  static final instance = CustomBottomSheet._();

  modalBottomSheet({
    required Widget child,
    required BuildContext context,
    String? bottomButtonName,
    VoidCallback? onBottomPressed,
    VoidCallback? onCloseButton,
    Color? bottomButtonColor,
  }) {
    // FocusManager.instance.primaryFocus?.unfocus();
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimensions.r10),
                topRight: Radius.circular(Dimensions.r10))),
        isScrollControlled: true,

        // clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                color: Colors.transparent,
                alignment: Alignment.center,
                child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      if (onCloseButton != null) {
                        onCloseButton();
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: ColorConst.whiteColor,
                      radius: Dimensions.r16,
                      child: const Icon(
                        Icons.close_rounded,
                        // color: ColorConst.blackColor,
                        size: 22,
                      ),
                    )),
              ),
              Wrap(
                children: [
                  Container(
                    width: Dimensions.screenWidth(),
                    decoration: BoxDecoration(
                        color: ColorConst.whiteColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(Dimensions.r10),
                            topRight: Radius.circular(Dimensions.r10))),
                    constraints: BoxConstraints(
                        maxHeight: Dimensions.screenHeight() * 0.875),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: child,
                        ),
                        SizedBox(height: Dimensions.getKeyBoardHeight()),
                        if (bottomButtonName.isNotNullAndEmpty())
                          BottomNavButton(
                              text: bottomButtonName!,
                              bgColor: bottomButtonColor,
                              onPressed: onBottomPressed ?? () {})
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }


  cupertinoActionSheet({required List<Widget> actions}) {
    return showCupertinoModalPopup(
        context: GlobalVariable.appContext,
        builder: (BuildContext context) => CupertinoActionSheet(
          actions: actions,
          cancelButton: CupertinoActionSheetAction(
            child: Text(
              "Cancel",
              style: fontStyleBold20.copyWith(
                fontFamily: FontAsset.sfPro,
                color: ColorConst.secondaryColor,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ));
  }


}
