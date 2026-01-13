
import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:miracle_experience_mobile_app/core/basic_features.dart';
import 'package:miracle_experience_mobile_app/core/widgets/show_snakbar.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/cubit/auth_cubit.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/response_model/model_response_signin_entity.dart';

import '../../core/widgets/common_progress_button.dart';
import '../balloon_manifest/balloon_manifest_screen.dart';

part 'signin_helper.dart';

class ZohoSigninScreen extends StatefulWidget {
  const ZohoSigninScreen({super.key});

  @override
  State<ZohoSigninScreen> createState() => _ZohoSigninScreenState();
}

class _ZohoSigninScreenState extends State<ZohoSigninScreen> {

  final SigninHelper signinHelper = SigninHelper();

  @override
  void initState() {
   signinHelper.initialize();
    super.initState();
  }
  

  @override
  void dispose() {
    signinHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      resizeToAvoidBottomInset: isLandscape && !Const.isTablet,
      backgroundColor: ColorConst.whiteColor,
      appBar: CustomAppBar.blankAppbar(backgroundColor: ColorConst.whiteColor,),
      body: (isLandscape && !Const.isTablet)
          ? SingleChildScrollView(child: _buildContent())
          : _buildContent(),
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
                  buttonLabel: AppString.signIn,
                  onTap: signinHelper.zohoSignIn,
                  onSuccess: (modelResponse, msg) =>
                      onSuccess(modelResponse, msg),
                  onError: (message) => showErrorSnackBar(message ?? ''),
                  isEnabled: true,
                  onNoInternet: () {
                    showErrorSnackBar(AppString.noInternetFound);
                    // navigateToPage(NoInternet(onPressed: validate));
                  },
                ),
          ),
        ],
      ),
    );
  }


  Future<void> onSuccess(
    ModelResponseSigninEntity? result,
    String message,
  ) async {
    await SharedPrefUtils.setIsUserLoggedIn(true);
    await SharedPrefUtils.setToken(result?.accessToken?.token ?? "");
    navigateToPageAndRemoveAllPage(const BalloonManifestScreen());
    // navigateToPageAndRemoveAllPage(const WaiverListScreen());
    // await SharedPrefUtils.setUser(result);
  }
}
