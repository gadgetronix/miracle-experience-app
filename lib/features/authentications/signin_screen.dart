import 'dart:io';

import 'package:flutter/material.dart';
import 'package:miracle_experience_mobile_app/core/basic_features.dart';
import 'package:miracle_experience_mobile_app/core/widgets/show_snakbar.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/cubit/auth_cubit.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/request_model/model_request_signin_entity.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/response_model/model_response_signin_entity.dart';

import '../../core/widgets/common_progress_button.dart';
import '../balloon_manifest/balloon_manifest_screen.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  ValueNotifier<bool> isPasswordVisible = ValueNotifier<bool>(false);

  final SigninCubit signinCubit = SigninCubit();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar.blankAppbar(),
      body: Padding(
        padding: EdgeInsets.only(
          top: Dimensions.getSafeAreaTopHeight() + 20,
          bottom: 20,
          left: Const.isTablet ? Dimensions.screenWidth() * 0.25 : 20,
          right: Const.isTablet ? Dimensions.screenWidth() * 0.25 : 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sample image header or illustration
            SizedBox(
              height: Dimensions.screenHeight() * 0.1,
              width: Dimensions.screenWidth() * 0.4,
              child: Image.asset(ImageAsset.icScreenLogo),
            ),
            SizedBox(height: 30),
            // Headline or main title
            Text(
              AppString.welcomeToMiracleExperienceSigninToContinue,
              style: fontStyleSemiBold18,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            CommonTextField(
              hintText: AppString.enterYourEmail,
              keyBoardType: TextInputType.emailAddress,
              textController: emailController,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.none,
            ),
            SizedBox(height: 5),
            ValueListenableBuilder<bool>(
              valueListenable: isPasswordVisible,
              builder: (context, visible, child) {
                return CommonTextField(
                  hintText: AppString.enterYourPassword,
                  keyBoardType: TextInputType.visiblePassword,
                  textController: passwordController,
                  obscureText: !visible,
                  textInputAction: TextInputAction.done,
                  suffixIcon: InkWell(
                    onTap: () {
                      isPasswordVisible.value = !isPasswordVisible.value;
                    },
                    child: Icon(
                      Icons.visibility_rounded,
                      color: visible
                          ? ColorConst.primaryColor
                          : ColorConst.suffixColor,
                      size: 22,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 15),

            BlocProvider.value(
              value: signinCubit,
              child:
                  BlocConsumerRoundedButtonWithProgress<
                    SigninCubit,
                    ModelResponseSigninEntity
                  >(
                    buttonLabel: AppString.signIn,
                    onTap: validate,
                    onSuccess: (modelResponse, msg) =>
                        onSuccess(modelResponse, msg),
                    onError: (message) =>
                        showErrorSnackBar(context, message ?? ''),
                    isEnabled: true,
                    onNoInternet: () {
                      // navigateToPage(NoInternet(onPressed: validate));
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void validate() {
    if (emailController.text.trim().isEmpty ||
        emailController.text.trim().isValidEmail() == false) {
      showErrorSnackBar(context, AppString.pleaseEnterValidEmail);
    } else if (passwordController.text.trim().isEmpty) {
      showErrorSnackBar(context, AppString.pleaseEnterPassword);
    } else {
      callSigninAPI();
    }
  }

  void callSigninAPI() {
    FocusManager.instance.primaryFocus?.unfocus();
    ModelRequestSigninEntity modelRequestSigninEntity =
        ModelRequestSigninEntity()
          ..deviceToken = Platform.isAndroid
              ? Const.androidInfo?.id
              : Const.iosInfo?.identifierForVendor
          ..isSignout = false
          ..appVersion = AppInfo.instance.packageInfo?.version ?? ''
          ..osVersion = Platform.isAndroid
              ? Const.androidInfo?.version.release
              : Const.iosInfo?.systemVersion
          ..deviceMf = Platform.isAndroid
              ? Const.androidInfo?.manufacturer
              : Const.iosInfo?.name
          ..deviceModel = Platform.isAndroid
              ? Const.androidInfo?.model
              : Const.iosInfo?.model
          ..uId = Platform.isAndroid
              ? Const.androidInfo?.id
              : Const.iosInfo?.identifierForVendor
          ..userRole = 1
          ..platform = Platform.isAndroid
              ? PlatformType.android.value
              : PlatformType.ios.value
          ..email = emailController.text.trim()
          ..password = passwordController.text.trim();
    signinCubit.callSigninAPI(modelRequestSigninEntity);
  }

  Future<void> onSuccess(
    ModelResponseSigninEntity? result,
    String message,
  ) async {
    await SharedPrefUtils.setIsUserLoggedIn(true);
    await SharedPrefUtils.setToken(result?.accessToken?.token ?? "");
    navigateToPageAndRemoveAllPage(const BalloonManifestScreen());
    // await SharedPrefUtils.setUser(result);
  }
}
