part of 'signin_screen.dart';

class AuthHelper {
  late ZohoSigninCubit zohoSigninCubit;
  late EmailSigninCubit emailSigninCubit;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late ValueNotifier<bool> isPasswordVisible;


  initializeSigninScreen() {
    zohoSigninCubit = ZohoSigninCubit();
    emailSigninCubit = EmailSigninCubit();
    emailController = TextEditingController(
    text: kDebugMode ? 'development@gadgetronix.net' : '',
  );
  passwordController = TextEditingController(
    text: kDebugMode ? 'Miracle@123!' : '',
  );
  isPasswordVisible = ValueNotifier<bool>(false);
  }

  disposeSigninScreen() {
    zohoSigninCubit.close();
    emailSigninCubit.close();
    emailController.dispose();
    passwordController.dispose();
    isPasswordVisible.dispose();
  }

  Future<void> zohoSignIn() async {
    const clientId = Env.zohoClientId;
    const redirectUri = 'com.miracleexperience.app://zoho-callback';

    final authUrl =
        "https://accounts.zoho.com/oauth/v2/auth?scope=AaaServer.profile.READ&client_id=$clientId&response_type=code&redirect_uri=$redirectUri&access_type=offline&prompt=consent";

    // Open Zoho login
    final result = await FlutterWebAuth2.authenticate(
      url: authUrl,
      callbackUrlScheme: 'com.miracleexperience.app',
      options: FlutterWebAuth2Options(preferEphemeral: false,)
    );
    timber('Zoho login result: $result');
    // Extract code
    final uri = Uri.parse(result);
    final code = uri.queryParameters['code'];

    if (code == null) {
      throw Exception('Zoho login failed');
    }
    timber('Zoho login code: $code');
    await zohoSigninCubit.callZohoSigninAPI(code);
  }
  
  void validateEmailPasswordAndSignin() {
    if (emailController.text.trim().isEmpty ||
        emailController.text.trim().isValidEmail() == false) {
      showErrorSnackBar(AppString.pleaseEnterValidEmail);
    } else if (passwordController.text.trim().isEmpty) {
      showErrorSnackBar(AppString.pleaseEnterPassword);
    } else {
      callSigninWithEmail();
    }
  }


  void callSigninWithEmail() {
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
    emailSigninCubit.callSigninAPI(modelRequestSigninEntity);
  }

  Future<void> onEmailSigninSuccess(
    ModelResponseSigninEntity? result,
    String message,
  ) async {
    await SharedPrefUtils.setIsUserLoggedIn(true);
    await SharedPrefUtils.setToken(result?.accessToken?.token ?? "");
    await SharedPrefUtils.setUser(result);
    navigateToPageAndRemoveAllPage(const BalloonManifestScreen());
  }

  Future<void> onZohoSigninSuccess(
    ModelResponseSigninEntity? result,
    String message,
  ) async {
    await SharedPrefUtils.setIsUserLoggedIn(true);
    await SharedPrefUtils.setToken(result?.accessToken?.token ?? "");
    await SharedPrefUtils.setUser(result);
    navigateToPageAndRemoveAllPage(const BalloonManifestScreen());
  }


  // ========== Signout ==========

  void callSignOutAPI({required SignOutCubit signOutCubit}) {
    final modelRequestSigninEntity = ModelRequestSigninEntity()
      ..deviceToken = Platform.isAndroid
          ? Const.androidInfo?.id
          : Const.iosInfo?.identifierForVendor
      ..isSignout = true
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
          : PlatformType.ios.value;
    signOutCubit.callSignOutAPI(modelRequestSigninEntity);
  }

}
