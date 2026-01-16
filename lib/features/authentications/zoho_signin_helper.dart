part of 'zoho_signin_screen.dart';

class ZohoSigninHelper {
  late ZohoSigninCubit zohoSigninCubit;

  initialize() {
    zohoSigninCubit = ZohoSigninCubit();
  }

  dispose() {
    zohoSigninCubit.close();
  }

  Future<void> zohoSignIn() async {
    const clientId = '1000.T1FX69H6H1AZFDIE2UUHXQ41WIE0VA';
    const redirectUri = 'com.miracleexperience.app://oauth';

    final authUrl =
        "https://accounts.zoho.com/oauth/v2/auth?scope=AaaServer.profile.READ&client_id=$clientId&response_type=code&redirect_uri=$redirectUri&access_type=offline&prompt=consent";

    // Open Zoho login
    final result = await FlutterWebAuth2.authenticate(
      url: authUrl,
      callbackUrlScheme: 'com.miracleexperience.app',
    );

    // Extract code
    final uri = Uri.parse(result);
    final code = uri.queryParameters['code'];

    if (code == null) {
      throw Exception('Zoho login failed');
    }
    timber('Zoho login code: $code');
    await zohoSigninCubit.callZohoSigninAPI(code);
  }
}
