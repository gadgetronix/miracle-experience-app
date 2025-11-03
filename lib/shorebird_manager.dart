import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/services.dart';
import 'package:miracle_experience_mobile_app/core/basic_features.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

class ShorebirdManager {
  final _shorebird = ShorebirdUpdater();

  Future<void> init() async {
    try {
      print('🔍 Checking for Shorebird update...');
      var status = await _shorebird.checkForUpdate();
      print('📦 Initial update status: $status');

      final int? lastPatch = SharedPrefUtils.getLastPatch();
      var currentPatch = await _shorebird.readCurrentPatch();

      if (status == UpdateStatus.outdated) {
        print(
          '⬇️ Patch is outdated. Waiting for Shorebird to finish downloading...',
        );

        // Poll every 2 seconds until restartRequired
        bool readyToRestart = false;
        int attempts = 0;

        while (!readyToRestart && attempts < 15) {
          // max 30 seconds
          await Future.delayed(const Duration(seconds: 2));
          status = await _shorebird.checkForUpdate();
          print('⏳ Checking again... $status');
          if (status == UpdateStatus.restartRequired) {
            readyToRestart = true;
          }
          attempts++;
        }

        if (readyToRestart) {
          print('✅ Patch ready to apply, restarting...');
          currentPatch = await _shorebird.readCurrentPatch();
          await SharedPrefUtils.setLastPatch(currentPatch?.number ?? -1);
          relaunchApp();
        } else {
          print('⚠️ Timed out waiting for patch to finish downloading.');
        }
      } else if (status == UpdateStatus.restartRequired) {
        print('📦 Restart required...');

        // Avoid restarting again and again for same patch
        if (currentPatch?.number != lastPatch) {
          print('🔁 Restarting for new patch...');
          await SharedPrefUtils.setLastPatch(currentPatch?.number ?? -1);
          relaunchApp();
        } else {
          print('✅ Already restarted for this patch. Skipping restart.');
        }
      } else {
        print('✅ App is up to date.');
      }
    } on UpdateException catch (e) {
      print('❌ UpdateException: ${e.message}');
    } catch (e) {
      print('⚠️ Unexpected error: $e');
    }
  }

  Future<void> relaunchApp() async {
    if (Platform.isAndroid) {
      try {
        const packageName = 'com.miracleexperience.app';

        final intent = AndroidIntent(
          action: 'android.intent.action.MAIN',
          category: 'android.intent.category.LAUNCHER',
          package: packageName,
          componentName: '$packageName/$packageName.MainActivity',
          flags: <int>[
            Flag.FLAG_ACTIVITY_NEW_TASK,
            Flag.FLAG_ACTIVITY_CLEAR_TASK,
          ],
        );

        // Launch new instance then close current
        await Future.delayed(const Duration(milliseconds: 500));
        await intent.launch();
        SystemNavigator.pop();
      } catch (e) {
        print(
          '⚠️ Relaunch via intent failed, fallback to Restart.restartApp() ${e.toString()}',
        );
      }
    } else {
      exit(0); // iOS can’t relaunch itself
    }
  }
}
