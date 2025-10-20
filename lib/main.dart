import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miracle_experience_mobile_app/features/authentications/signin_screen.dart';
import 'package:upgrader/upgrader.dart';

import 'core/basic_features.dart';
import 'core/firebase/notification_manager.dart';
import 'core/utils/app_loader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefUtils.init();
  await Const.config();
  await AppInfo.instance.checkUpdates();
  await Loader.instance.init();
  // await Firebase.initializeApp();
  // await NotificationManager().init();
  await ScreenUtil.ensureScreenSize();
  orientations();
  runApp(const MainApp());
}

void orientations() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: MaterialApp(
          theme: ThemeData(
            primaryColor: ColorConst.primaryColor,
            scaffoldBackgroundColor: ColorConst.whiteColor,
            colorScheme: ColorScheme.fromSeed(
              seedColor: ColorConst.primaryColor,
            ),
            progressIndicatorTheme: ProgressIndicatorThemeData(
              color: ColorConst.primaryColor,
            ),
          ),
          builder: EasyLoading.init(
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(
                    1.0,
                    // state.fontHeight?.toDouble() ?? 1.0
                  ),
                ),
                child: child!,
              );
            },
          ),
          navigatorKey: GlobalVariable.navigatorKey,
          debugShowCheckedModeBanner: false,
          title: AppString.appName,
          routes: const <String, WidgetBuilder>{},
          home: UpgradeAlert(
            showIgnore: false,
            showLater: false,
            shouldPopScope: () => false,
            upgrader: Upgrader(
              durationUntilAlertAgain: const Duration(days: 1),
            ),
            child: SigninScreen(),
          ),
        ),
      ),
    );
  }
}
