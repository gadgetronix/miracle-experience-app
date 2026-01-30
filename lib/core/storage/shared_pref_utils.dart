import 'dart:convert';

import 'package:miracle_experience_mobile_app/features/network_helper/models/helper_models/offline_pax_arrangement_model.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/response_model/model_response_balloon_manifest_entity.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/response_model/model_response_signin_entity.dart';
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

  static String? getFcmToken() {
    return _prefsInstance?.getString("FcmToken");
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

  static int? getLastPatch() {
    return _prefsInstance?.getInt("last_patch");
  }

  static Future<bool> setLastPatch(int value) async {
    var prefs = await _instance;
    return prefs.setInt("last_patch", value);
  }

  static ModelResponseSigninEntity? getUser() {
    String? stringModel = _prefsInstance?.getString("User");
    ModelResponseSigninEntity? userModel =
        stringModel != null
            ? ModelResponseSigninEntity.fromJson(jsonDecode(stringModel))
            : null;
    return userModel;
  }

  static Future<bool> setUser(var value) async {
    var prefs = await _instance;
    if (value == null) {
      return prefs.setString("User", value);
    }
    return prefs.setString("User", value.toString());
  }

  static ModelResponseBalloonManifestEntity? getBalloonManifest() {
    String? stringModel = _prefsInstance?.getString("BalloonManifest");
    ModelResponseBalloonManifestEntity? modelResponseBalloonManifestEntity =
        stringModel.isNotNullAndEmpty()
        ? ModelResponseBalloonManifestEntity.fromJson(jsonDecode(stringModel!))
        : null;
    return modelResponseBalloonManifestEntity;
  }

  static Future<bool> setBalloonManifest(String value) async {
    var prefs = await _instance;
    return prefs.setString("BalloonManifest", value);
  }

  static Future<bool> setBalloonPassengerArrangement({required String key, required String value}) async {
    var prefs = await _instance;
    return prefs.setString(key, value);
  }
  
  static OfflinePaxArrangementModel? getBalloonPassengerArrangement({required String key}) {
    String? stringModel = _prefsInstance?.getString(key);
    if (stringModel == null || stringModel.isEmpty) return null;
    try{
    OfflinePaxArrangementModel? offlinePaxArrangementModel =
         OfflinePaxArrangementModel.fromJson(jsonDecode(stringModel));
    return offlinePaxArrangementModel;}
    catch(e) {
      timber("exception${e.toString()}");
      return null;
    }
  }
  
  static void removeBalloonPassengerArrangement({required String key}) {
    _prefsInstance?.remove(key);
  }


  static List<String>? getPendingSignatures() {
    List<String>? stringList = _prefsInstance?.getStringList(
      "pending_signatures",
    );
    return stringList;
  }

  static Future<bool> setPendingSignatures({
    Map<String, dynamic>? data,
    List<String>? pendingSignatureList,
    bool? isList,
  }) async {
    if (isList == true && pendingSignatureList != null) {
      var prefs = await _instance;
      return prefs.setStringList("pending_signatures", pendingSignatureList);
    }
    final pendingList = SharedPrefUtils.getPendingSignatures() ?? [];
    pendingList.add(jsonEncode(data));
    var prefs = await _instance;
    return prefs.setStringList("pending_signatures", pendingList);
  }
  
  static List<String>? getPendingManifestPaxNames() {
    List<String>? stringList = _prefsInstance?.getStringList(
      "pending_manifest_pax_names",
    );
    return stringList;
  }

  static Future<bool> setPendingManifestPaxNames({
    Map<String, dynamic>? data,
    List<String>? pendingPaxNameUpdate,
    bool? isList,
  }) async {
    if (isList == true && pendingPaxNameUpdate != null) {
      var prefs = await _instance;
      return prefs.setStringList("pending_manifest_pax_names", pendingPaxNameUpdate);
    }
    final pendingList = SharedPrefUtils.getPendingManifestPaxNames() ?? [];
    pendingList.add(jsonEncode(data));
    var prefs = await _instance;
    return prefs.setStringList("pending_manifest_pax_names", pendingList);
  }

  static Future<void> remove() async {
    SharedPreferences.getInstance().then((SharedPreferences pref) {
      pref.clear();
    });
  }

  static Future<void> onLogout() async {
    var prefs = await _instance;
    prefs.remove("IsUserLoggedIn");
    prefs.remove("token");
    prefs.remove("User");
    prefs.remove("BalloonManifest");
    prefs.remove("pending_signatures");
    SharedPrefUtils.setIsUserLoggedIn(false);
  }
}
