//import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../navigation_key/global_key.dart';



Future<dynamic> navigateToPageAndRemoveAllPage(Widget routePage,
    {Widget? currentWidget}) {
  return Navigator.of(GlobalVariable.appContext).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => routePage), (route) => false);

}

Future<dynamic> navigateToPage(Widget routePage, {Widget? currentWidget}) {
  try {
    FocusManager.instance.primaryFocus!.unfocus();
  } catch (e) {
    //  FirebaseCrashlytics.instance.recordError(e, s);
  }
  return Navigator.push(
    GlobalVariable.appContext,
    CupertinoPageRoute(builder: (context) => routePage),
  );
}

Future<dynamic> navigateToPageAndRemoveCurrentPage(Widget routePage,
    {Widget? currentWidget}) {
  return Navigator.pushReplacement(
    GlobalVariable.appContext,
    CupertinoPageRoute(builder: (context) => routePage),
  );
}