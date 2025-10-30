part of '../balloon_manifest_screen.dart';

class GeneralErrorWidget extends StatelessWidget {
  const GeneralErrorWidget({
    super.key,
    required this.message,
    required this.helper,
  });

  final String message;
  final BalloonManifestHelper helper;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        helper.loadManifestData();
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight, // 👈 ensures full height
            ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 50.0),
                        child: Text(
                          message,
                          style: fontStyleMedium15.copyWith(
                            color: ColorConst.textGreyColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
