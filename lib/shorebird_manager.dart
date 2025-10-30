import 'package:miracle_experience_mobile_app/core/utils/logger_util.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

class ShorebirdManager {
  final _shorebirdCodePush = ShorebirdUpdater();

  init() async {
    try {
      final isUpdateAvailable = await _shorebirdCodePush.checkForUpdate();

      if (isUpdateAvailable == UpdateStatus.outdated) {
        await Future.wait([_shorebirdCodePush.update()]);
        Future.delayed(const Duration(seconds: 1), () {
          Restart.restartApp();
        });
      }
    } on UpdateException catch (e) {
      timber('Failed to update: $e');
    }
  }
}
