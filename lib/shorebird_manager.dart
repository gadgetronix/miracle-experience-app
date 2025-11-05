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
      var status = await _shorebird.checkForUpdate();

      if (status == UpdateStatus.outdated) {
        bool readyToRestart = false;
        int attempts = 0;

        while (!readyToRestart && attempts < 15) {
          await Future.delayed(const Duration(seconds: 2));
          status = await _shorebird.checkForUpdate();
          if (status == UpdateStatus.restartRequired) readyToRestart = true;
          attempts++;
        }

        if (readyToRestart) {
          shouldShowRestartDialog = true;
        }
      } else if (status == UpdateStatus.restartRequired) {
        shouldShowRestartDialog = true;
      } 
    } on UpdateException catch (e) {
      timber('❌ UpdateException: ${e.message}');
    } catch (e) {
      timber('⚠️ Unexpected error: $e');
    }
  }
}
