import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miracle_experience_mobile_app/features/authentications/signin_screen.dart';
import 'package:miracle_experience_mobile_app/features/balloon_manifest/balloon_manifest_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:upgrader/upgrader.dart';

import 'core/basic_features.dart';
import 'core/utils/app_loader.dart';
import 'core/utils/secure_time_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefUtils.init();
  await Const.config();
  await AppInfo.instance.checkUpdates();
  await Loader.instance.init();
  // await Firebase.initializeApp();
  // await NotificationManager().init();
  await ScreenUtil.ensureScreenSize();
  _initializeKronos();
  // orientations();
  runApp(const MainApp());
}

void orientations() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

Future<void> _initializeKronos() async {
  tz.initializeTimeZones();
  try {
    // timber('🚀 App starting - attempting time sync...');
    final success = await SecureTimeHelper.syncAndPersist();
    if (success) {
      // timber('✅ Initial time sync successful');
    } else {
      // timber('⚠️  Initial time sync failed - app opened offline');
    }
  } catch (e) {
    timber('❌ Initial sync error: $e');
  }
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
              Const.init(context);
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
            child: SharedPrefUtils.getIsUserLoggedIn()
                ? BalloonManifestScreen()
                : SigninScreen(),
          ),
        ),
      ),
    );
  }
}
