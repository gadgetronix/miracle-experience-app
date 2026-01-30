import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miracle_experience_mobile_app/core/network/api_result.dart';
import 'package:miracle_experience_mobile_app/features/authentications/signin_screen.dart';
import 'package:miracle_experience_mobile_app/features/waiver/wavier_list_screen.dart';

import 'core/basic_features.dart';
import 'core/network/base_response_model_entity.dart';
import 'core/widgets/show_snakbar.dart';
import 'features/balloon_manifest/balloon_manifest_screen.dart';
import 'features/network_helper/cubit/auth_cubit.dart';

part 'drawer_menu_helper.dart';

class DrawerMenuScreen extends StatefulWidget {
  const DrawerMenuScreen({super.key, required this.selectedMenu});
  final DrawerMenu selectedMenu;

  @override
  State<DrawerMenuScreen> createState() => _DrawerMenuScreenState();
}

class _DrawerMenuScreenState extends State<DrawerMenuScreen> {
  final DrawerMenuHelper drawerMenuHelper = DrawerMenuHelper();

  @override
  void initState() {
    drawerMenuHelper.initializeDrawerMenu();
    super.initState();
  }

  @override
  void dispose() {
    drawerMenuHelper.disposeDrawerMenu();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Drawer(
        backgroundColor: ColorConst.menuBgColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _menuItem(
                        image: ImageAsset.icBalloonManifest,
                        title: AppString.balloonManifest,
                        selected: widget.selectedMenu == DrawerMenu.balloonManifest,
                        onTap: () {
                          if (widget.selectedMenu == DrawerMenu.balloonManifest) {
                            Navigator.pop(context);
                            return;
                          }
                          navigateToPageAndRemoveAllPage(
                            BalloonManifestScreen(),
                          );
                        },
                      ),
                      // _menuItem(
                      //   image: ImageAsset.icBalloonManifest,
                      //   title: AppString.waiver,
                      //   selected: widget.selectedMenu == DrawerMenu.waivers,
                      //   onTap: () {
                      //     if (widget.selectedMenu == DrawerMenu.waivers) {
                      //       Navigator.pop(context);
                      //       return;
                      //     }
                      //     navigateToPageAndRemoveAllPage(WaiverListScreen());
                      //   },
                      // ),
                    ],
                  ),
                ),
              ),
              _signOutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            ImageAsset.icMenuWhiteLogo,
            width: Dimensions.screenWidth() * 0.5,
          ),
          const SizedBox(height: 16),
          Text(SharedPrefUtils.getUser()?.name ?? '', style: fontStyleMedium18.apply(color: ColorConst.whiteColor),),
          const SizedBox(height: 16),

        ],
      ),
    );
  }

  Widget _menuItem({
    required String image,
    required String title,
    bool selected = false,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14, left: 16, right: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: selected ? ColorConst.selectedMenuColor : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Image.asset(image, height: 22),
              const SizedBox(width: 16),
              Text(
                title,
                style: fontStyleMedium16.apply(color: ColorConst.whiteColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signOutButton(BuildContext context) {
    return BlocProvider.value(
      value: drawerMenuHelper.signOutCubit,
      child:
          BlocListener<SignOutCubit, APIResultState<BaseResponseModelEntity>?>(
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
                  drawerMenuHelper.callSignOutAPI();
                },
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 34,
                  vertical: 30,
                ),
                child: Row(
                  children: [
                    Icon(Icons.logout_outlined, color: ColorConst.whiteColor),
                    SizedBox(width: 10),
                    Text(
                      AppString.logout,
                      style: fontStyleMedium16.apply(
                        color: ColorConst.whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
