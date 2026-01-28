import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miracle_experience_mobile_app/features/authentications/signin_screen.dart';
import 'package:miracle_experience_mobile_app/features/balloon_manifest/balloon_manifest_screen.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/cubit/balloon_manifest_cubit.dart';
import 'package:miracle_experience_mobile_app/features/restart_screen.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'package:upgrader/upgrader.dart';

import 'core/basic_features.dart';
import 'core/firebase/notification_manager.dart';
import 'core/utils/app_loader.dart';
import 'core/utils/secure_time_helper.dart';
import 'shorebird_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  await SharedPrefUtils.init();
  await NotificationManager.instance.init();

  
  await Const.config();
  await AppInfo.instance.checkUpdates();
  await Loader.instance.init();
  await ScreenUtil.ensureScreenSize();
  await ShorebirdManager().preInitCheck();
  await _initializeKronos();

  runApp(
    BlocProvider(
      create: (_) => OfflineSyncCubit(),
      child: const AppRoot(),
    ),
  );
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {
  await Firebase.initializeApp();
}


void orientations() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

Future<void> _initializeKronos() async {
  tz.initializeTimeZones();
  try {
    final success = await SecureTimeHelper.syncAndPersist();
    if (success) {
    } else {}
  } catch (e) {
    timber('Initial sync error: $e');
  }
}


class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: GlobalVariable.navigatorKey,
        title: AppString.appName,
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
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(1.0)),
              child: child!,
            );
          },
        ),
        home: const MainApp(),
      ),
    );
  }
}


class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: UpgradeAlert(
        showIgnore: false,
        showLater: false,
        shouldPopScope: () => false,
        upgrader: Upgrader(
          durationUntilAlertAgain: const Duration(days: 1),
        ),
        child: ShorebirdManager().shouldShowRestartDialog
            ? RestartScreen()
            : SharedPrefUtils.getIsUserLoggedIn()
                ? BalloonManifestScreen()
                : SigninScreen(),
      ),
    );
  }
}
