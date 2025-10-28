part of '../balloon_manifest_screen.dart';

class SignatureBottomSheet {
  static Future<void> show({
    required BuildContext context,
    required BalloonManifestHelper helper,
    String? manifestId,
    int? assignmentId,
  }) {
    final UploadSignatureCubit uploadSignatureCubit = UploadSignatureCubit();
    final SignatureController controller = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );

    return CustomBottomSheet.instance.modalBottomSheet(
      context: context,
      bottomButtonName: AppString.submit,
      child: BlocProvider.value(
        value: uploadSignatureCubit,
        child:
            BlocListener<
              UploadSignatureCubit,
              APIResultState<BaseResponseModelEntity>?
            >(
              listener: (context, state) {
                if (state?.resultType == APIResultType.loading) {
                  EasyLoading.show();
                } else if (state?.resultType == APIResultType.success) {
                  helper.updateSignedDateInPrefs(
                    signedDateTime: DateTime.now().toIso8601String(),
                    imageName: 'success.png',
                  );
                  EasyLoading.dismiss();
                  Navigator.pop(context);
                } else if (state?.resultType == APIResultType.noInternet) {
                  helper.updateSignedDateInPrefs(
                    signedDateTime: DateTime.now().toIso8601String(),
                  );
                  Navigator.pop(context);
                  EasyLoading.dismiss();
                } else if (state?.resultType == APIResultType.failure) {
                  EasyLoading.dismiss();
                  Navigator.pop(context);
                  showErrorSnackBar(
                    state?.message ?? 'Something went wrong. Please try again.',
                  );
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Signature(
                    controller: controller,
                    height: 300,
                    backgroundColor: Colors.grey[200]!,
                  ),
                ],
              ),
            ),
      ),
      onBottomPressed: () async {
        if (controller.isNotEmpty) {
          final bytes = await controller.toPngBytes();
          if (bytes != null) {
            final tempDir = await getTemporaryDirectory();
            final file = File('${tempDir.path}/signature.png');
            await file.writeAsBytes(bytes);

            await uploadSignatureCubit.callUploadSignatureAPI(
              assignmentId: assignmentId ?? 0,
              signedDate: DateTime.now().toIso8601String(),
              signatureFile: file,
            );
          }
        } else {
          EasyLoading.showToast("Please add your signature before submitting.");
        }
      },
    );
  }
}
