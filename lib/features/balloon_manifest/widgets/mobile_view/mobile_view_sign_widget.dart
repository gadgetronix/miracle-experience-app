part of '../../balloon_manifest_screen.dart';

class MobileViewSignWidget extends StatelessWidget {
  const MobileViewSignWidget({
    super.key,
    required this.helper,
    required this.manifestId,
    required this.assignmentId,
  });
  final BalloonManifestHelper helper;
  final String? manifestId;
  final int? assignmentId;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SignatureStatus>(
      valueListenable: helper.signatureStatus,
      builder: (context, status, child) {
        return GestureDetector(
          onTap: status == SignatureStatus.pending
              ? () {
                  SignatureBottomSheet.show(
                    context: context,
                    manifestId: manifestId,
                    assignmentId: assignmentId,
                    helper: helper,
                  );
                }
              : null,
          child: Container(
            padding: EdgeInsets.only(
              bottom: Dimensions.getSafeAreaBottomHeight() == 0
                  ? 0
                  : Platform.isAndroid
                  ? Dimensions.getSafeAreaBottomHeight()
                  : 12,
            ),
            color: status == SignatureStatus.success
                ? ColorConst.successColor
                : ColorConst.primaryColor,
            height: Dimensions.bottomPadding(),
            width: double.infinity,
            child: Center(
              child: ValueListenableBuilder<String>(
                valueListenable: helper.signatureTime,
                builder: (context, value, child) {
                  return status == SignatureStatus.pending
                      ? Text(
                          AppString.sign,
                          style: fontStyleBold14.apply(
                            color: ColorConst.whiteColor,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,

                                children: [
                                  Text(
                                    AppString.signed,
                                    style: fontStyleBold14.copyWith(
                                      color: ColorConst.whiteColor,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(
                                    Icons.done,
                                    color: ColorConst.whiteColor,
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              ValueListenableBuilder<String>(
                                valueListenable: helper.signatureTime,
                                builder: (context, value, child) {
                                  return Text(
                                    value,
                                    style: fontStyleRegular12.copyWith(
                                      color: ColorConst.whiteColor,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
