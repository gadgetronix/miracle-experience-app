import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miracle_experience_mobile_app/core/widgets/show_snakbar.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:intl/intl.dart';
import '../basic_features.dart';
import '../custom/flush_bar.dart';

class AppInfo {
  AppInfo._();
  static final instance = AppInfo._();
  PackageInfo? packageInfo;

  checkUpdates() async {
    packageInfo = await PackageInfo.fromPlatform();

    String? appVersions = packageInfo?.version;
    await SharedPrefUtils.setVersionCode(appVersions ?? '');
    logger.d("appVersion===> $appVersions");
    logger.d("appVersion===> ${SharedPrefUtils.getVersionCode()}");
  }
}

class Const {
  static DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  static AndroidDeviceInfo? androidInfo;
  static IosDeviceInfo? iosInfo;
  static String packageName = "com.miracleexperience.app";
  static String platform = Platform.isAndroid ? "Android" : "iOS";
  static bool? _isTablet;

  static void init(BuildContext context) {
    final data = MediaQuery.of(context);
    final shortestSide = data.size.shortestSide;
    _isTablet = shortestSide >= 600; // common threshold
  }

  static bool get isTablet {
    if (_isTablet == null) {
      throw Exception(
        'Const.init(context) must be called before using isTablet',
      );
    }
    return _isTablet!;
  }

  static Future<void> config() async {
    if (Platform.isAndroid) {
      androidInfo = await deviceInfoPlugin.androidInfo;
    } else {
      iosInfo = await deviceInfoPlugin.iosInfo;
    }
  }

  static String emailPattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  static Pattern phonePattern = r'(^[0-9 ]*$)';

  static String getDateInDMY(DateTime date) {
    DateFormat format = DateFormat('dd/MM/yyyy');
    String formattedDate = format.format(date);
    return formattedDate;
  }

  static String convertDateTimeToMDYHMSA(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = DateFormat('M/d/yyyy h:mm:ss a').format(dateTime);
    return formattedDate;
  }

  static String convertDateTimeToDMYHM(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = DateFormat('d/M/yyyy HH:mm').format(dateTime);
    return formattedDate;
  }
  
  static String convertDateTimeToDMY(DateTime dateTime) {
    String formattedDate = DateFormat('d MMM yyyy').format(dateTime);
    return formattedDate;
  }

  static String convertDateTimeToHHMMA(String date, {bool addSpace = true}) {
    DateTime dateTime = DateFormat('HH:mm').parse(date);
    String formattedDate = DateFormat(
      addSpace ? 'hh:mm a' : 'hh:mma',
    ).format(dateTime);
    return formattedDate;
  }

  static String formatDateWithOrdinal(DateTime date) {
    DateFormat formatter = DateFormat(
      "d'${_getOrdinalIndicator(date.day)}' MMMM",
    );
    return formatter.format(date);
  }

  static String _getOrdinalIndicator(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  static List<String> allowExtension = ['jpg', 'pdf', 'jpeg', 'png'];

  static String getFileExtension(String fileName) {
    return fileName.split('.').last;
  }

  static bool validateEmail(String email) {
    return RegExp(emailPattern).hasMatch(email);
  }

  static showFlushBar(String title, String des, String image) async {
    await Future.delayed(const Duration(milliseconds: 500), () {});

    await Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      boxShadows: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6,
          offset: Offset(0, 5),
          spreadRadius: 0.1,
        ),
      ],
      backgroundColor: ColorConst.flushbarBackgroundColor,
      icon: Image.asset(image, width: Dimensions.w32),
      titleText: Text(
        title,
        style: fontStyleSemiBold18.apply(color: ColorConst.secondaryColor),
        textAlign: TextAlign.center,
      ),
      messageText: Text(
        des,
        style: fontStyleRegular14.apply(color: ColorConst.textGreyColor),
        textAlign: TextAlign.center,
      ),
      borderRadius: BorderRadius.all(Radius.circular(Dimensions.r16)),
      margin: EdgeInsets.all(Dimensions.commonPaddingForScreen),
      duration: const Duration(seconds: 4),
    ).show(GlobalVariable.appContext);
  }

  static DateTime? backButtonPressedTime;

  static bool showExitPopup(BuildContext context) {
    DateTime currentTime = DateTime.now();

    //Statement 1 Or statement2

    bool backButton =
        backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime!) >
            const Duration(seconds: 2);

    if (backButton) {
      backButtonPressedTime = currentTime;
      showErrorSnackBar('Press again to exit');
      return false;
    } else {
      SystemNavigator.pop();
      return true;
    }
  }
}

class FontAsset {
  static const String fontHeightSmall = "fontHeightSmall";
  static const String fontHeightNormal = "fontHeightNormal";
  static const String fontHeightLarge = "fontHeightLarge";

  static const String helvetica = "Helvetica";
  // static const String montserrat = "Montserrat";
  static const String sfPro = "SFProText";

  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  // static const FontWeight extraBold = FontWeight.w800;
  // static const FontWeight black = FontWeight.w900;
}
