import 'package:firebase_messaging/firebase_messaging.dart';
import '../basic_features.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtils {
  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance!;
  }

  static generateFcmTokens() async {
    await FirebaseMessaging.instance.getToken().then((token) async {
      await SharedPrefUtils.setFcmToken(token!);
      logger.w("Firebase token ~~~~~~~> $token");
    });
  }

  static String getVersionCode() {
    return _prefsInstance?.getString("VersionCode") ?? "1.0.0";
  }

  static Future<bool> setVersionCode(String value) async {
    var prefs = await _instance;
    return prefs.setString("VersionCode", value);
  }

  static bool getIsUserLoggedIn() {
    return _prefsInstance?.getBool("IsUserLoggedIn") ?? false;
  }

  static Future<bool> setIsUserLoggedIn(bool value) async {
    var prefs = await _instance;
    return prefs.setBool("IsUserLoggedIn", value);
  }

  static String getFcmToken() {
    return _prefsInstance?.getString("FcmToken") ?? "";
  }

  static Future<bool> setFcmToken(String value) async {
    var prefs = await _instance;
    return prefs.setString("FcmToken", value);
  }

  static String getToken() {
    return _prefsInstance?.getString("token") ?? "";
  }

  static Future<bool> setToken(String value) async {
    var prefs = await _instance;
    return prefs.setString("token", value);
  }

  // static ModelResponseAuthEntity? getUser() {
  //   String? stringModel = _prefsInstance?.getString("User");
  //   ModelResponseAuthEntity? userModel =
  //       stringModel != null
  //           ? ModelResponseAuthEntity.fromJson(jsonDecode(stringModel))
  //           : null;
  //   return userModel;
  // }

  // static Future<bool> setUser(var value) async {
  //   var prefs = await _instance;
  //   if (value == null) {
  //     return prefs.setString("User", value);
  //   }
  //   return prefs.setString("User", value.toString());
  // }

  static Future<void> remove() async {
    SharedPreferences.getInstance().then((SharedPreferences pref) {
      pref.clear();
    });
  }

  static Future<void> onLogout() async {
    var prefs = await _instance;
    prefs.remove("User");
    SharedPrefUtils.setIsUserLoggedIn(false);
  }

}
