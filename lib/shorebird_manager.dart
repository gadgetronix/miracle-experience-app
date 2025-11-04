import 'dart:io';
import 'package:flutter/services.dart';
import 'package:miracle_experience_mobile_app/core/basic_features.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

class ShorebirdManager {
  // ---- Singleton pattern ----
  ShorebirdManager._internal();
  static final ShorebirdManager _instance = ShorebirdManager._internal();
  factory ShorebirdManager() => _instance;

  final _shorebird = ShorebirdUpdater();

  /// in-memory flag accessible anywhere
  bool shouldShowRestartDialog = false;

  /// Check for updates *before* runApp
  Future<void> preInitCheck() async {
    try {
      print('🔍 Checking for Shorebird update...');
      var status = await _shorebird.checkForUpdate();
      print('📦 Initial update status: $status');

      if (status == UpdateStatus.outdated) {
        print('⬇️ Patch outdated — waiting to finish download...');
        bool readyToRestart = false;
        int attempts = 0;

        while (!readyToRestart && attempts < 15) {
          await Future.delayed(const Duration(seconds: 2));
          status = await _shorebird.checkForUpdate();
          print('⏳ Checking again... $status');
          if (status == UpdateStatus.restartRequired) readyToRestart = true;
          attempts++;
        }

        if (readyToRestart) {
          print('✅ Patch ready — marking restart required.');
          shouldShowRestartDialog = true;
        } else {
          print('⚠️ Timed out waiting for patch download.');
        }
      } else if (status == UpdateStatus.restartRequired) {
        print('📦 Patch already downloaded — mark restart required.');
        shouldShowRestartDialog = true;
      } else {
        print('✅ App is up-to-date.');
      }
    } on UpdateException catch (e) {
      print('❌ UpdateException: ${e.message}');
    } catch (e) {
      print('⚠️ Unexpected error: $e');
    }
  }
}
