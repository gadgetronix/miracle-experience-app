import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:miracle_experience_mobile_app/core/basic_features.dart';
import 'package:miracle_experience_mobile_app/core/widgets/show_snakbar.dart';
import 'package:miracle_experience_mobile_app/features/envied/env.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/cubit/auth_cubit.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/request_model/model_request_signin_entity.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/response_model/model_response_signin_entity.dart';

import '../../core/widgets/common_progress_button.dart';
import '../balloon_manifest/balloon_manifest_screen.dart';

part 'auth_helper.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final AuthHelper signinHelper = AuthHelper();

  @override
  void initState() {
    signinHelper.initializeSigninScreen();
    super.initState();
  }

  @override
  void dispose() {
    signinHelper.disposeSigninScreen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      // resizeToAvoidBottomInset: isLandscape && !Const.isTablet,
      backgroundColor: ColorConst.whiteColor,
      appBar: CustomAppBar.blankAppbar(backgroundColor: ColorConst.whiteColor),
      body: 
      // (isLandscape && !Const.isTablet)
      //     ?
           SingleChildScrollView(child: _buildContent())
          // : _buildContent(),
    );
  }

  Padding _buildContent() {
    return Padding(
      padding: EdgeInsets.only(
        top: Dimensions.getSafeAreaTopHeight() + 20,
        bottom: 20,
        left: Const.isTablet ? Dimensions.screenWidth() * 0.25 : 20,
        right: Const.isTablet ? Dimensions.screenWidth() * 0.25 : 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: Dimensions.screenHeight() * 0.1,
            width: Dimensions.screenWidth() * 0.4,
            child: Image.asset(ImageAsset.icScreenLogo),
          ),
          SizedBox(height: 30),
          Text(
            AppString.welcomeToMiracleExperienceSigninToContinue,
            style: fontStyleSemiBold18,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
      
          BlocProvider.value(
            value: signinHelper.zohoSigninCubit,
            child:
                BlocConsumerRoundedButtonWithProgress<
                  ZohoSigninCubit,
                  ModelResponseSigninEntity
                >(
                  buttonLabel: AppString.signInWithZoho,
                  trailingImage: ImageAsset.icZoho,
                  textColor: ColorConst.textColor,
                  onTap: signinHelper.zohoSignIn,
                  onSuccess: (modelResponse, msg) =>
                      signinHelper.onZohoSigninSuccess(modelResponse, msg),
                  onError: (message) => showErrorSnackBar(message ?? ''),
                  isEnabled: true,
                  backGroundColor: ColorConst.whiteColor,
                  borderColor: ColorConst.primaryColor,
                  progressColor: ColorConst.primaryColor,
                  onNoInternet: () {
                    showErrorSnackBar(AppString.noInternetFound);
                    // navigateToPage(NoInternet(onPressed: validate));
                  },
                ),
          ),
          SizedBox(height: 20),
          Text(
            AppString.orSignInWithEmail,
            style: fontStyleMedium14.copyWith(color: ColorConst.textGreyColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
      
          CommonTextField(
            hintText: AppString.enterYourEmail,
            keyBoardType: TextInputType.emailAddress,
            textController: signinHelper.emailController,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.none,
          ),
          SizedBox(height: 5),
          ValueListenableBuilder<bool>(
            valueListenable: signinHelper.isPasswordVisible,
            builder: (context, visible, child) {
              return CommonTextField(
                hintText: AppString.enterYourPassword,
                keyBoardType: TextInputType.visiblePassword,
                textController: signinHelper.passwordController,
                obscureText: !visible,
                textInputAction: TextInputAction.done,
                suffixIcon: InkWell(
                  onTap: () {
                    signinHelper.isPasswordVisible.value = !signinHelper.isPasswordVisible.value;
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
            value: signinHelper.emailSigninCubit,
            child:
                BlocConsumerRoundedButtonWithProgress<
                  EmailSigninCubit,
                  ModelResponseSigninEntity
                >(
                  buttonLabel: AppString.signIn,
                  onTap: () => signinHelper.validateEmailPasswordAndSignin(),
                  onSuccess: (modelResponse, msg) =>
                      signinHelper.onEmailSigninSuccess(modelResponse, msg),
                  onError: (message) => showErrorSnackBar(message ?? ''),
                  isEnabled: true,
                  onNoInternet: () {
                    showErrorSnackBar(AppString.noInternetFound);
                  },
                ),
          ),
        ],
      ),
    );
  }
}
