part of '../balloon_manifest_screen.dart';

class ManifestAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ManifestAppBar({super.key, required this.helper});

  final BalloonManifestHelper helper;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        AppString.balloonManifest,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: FontAsset.helvetica,
        ),
      ),
      elevation: 2,
      backgroundColor: ColorConst.whiteColor,
      surfaceTintColor: Colors.transparent,
      actions: [
        BlocProvider.value(
          value: helper.signOutCubit,
          child:
              BlocListener<
                SignOutCubit,
                APIResultState<BaseResponseModelEntity>?
              >(
                listener: (context, state) {
                  EasyLoading.dismiss();
                  if (state?.resultType == APIResultType.loading) {
                    EasyLoading.show();
                  } else if (state?.resultType == APIResultType.success) {
                    SharedPrefUtils.onLogout();
                    navigateToPageAndRemoveAllPage(const SigninScreen());
                  } else {
                    showErrorSnackBar(state?.message ?? 'Logout failed');
                  }
                },
                child: GestureDetector(
                  onTap: () => showLogoutDialog(
                    title: AppString.logout,
                    content: AppString.logoutDesc,
                    cancelText: AppString.cancel,
                    yesText: AppString.logout,
                    noFunction: () => Navigator.pop(context),
                    yesFunction: () {
                      Navigator.pop(context);
                      helper.callSignOutAPI();
                    },
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 25),
                    child: Text(AppString.logout, style: fontStyleMedium16),
                  ),
                ),
              ),
        ),
      ],
    );
  }
}
