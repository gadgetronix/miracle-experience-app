import 'package:flutter/services.dart';
import 'package:flutter_kronos_plus/flutter_kronos_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'logger_util.dart';

/// Secure time helper using system uptime for tamper-proof time validation
/// Works offline after initial sync, immune to device time changes
class SecureTimeHelper {
  static const platform = MethodChannel(
    'com.miracleexperience.app/system_uptime',
  );

  static const String _keyNtpTime = 'secure_ntp_time';
  static const String _keySystemUptime = 'secure_system_uptime';

  /// Get system uptime in milliseconds (monotonic clock)
  /// Returns null if platform channel fails
  static Future<int?> getSystemUptime() async {
    try {
      final int uptime = await platform.invokeMethod('getSystemUptime');
      return uptime;
    } on PlatformException catch (e) {
      timber("Failed to get system uptime: '${e.message}'");
      return null;
    }
  }

  /// Sync with NTP servers and persist time + uptime to SharedPreferences
  /// Returns true if sync successful, false otherwise
  static Future<bool> syncAndPersist() async {
    try {

      // Sync with NTP servers via Kronos
      FlutterKronosPlus.sync();

      // Get accurate NTP time
      DateTime? ntpTime = await FlutterKronosPlus.getNtpDateTime;

      // Get system uptime at this exact moment
      int? uptime = await getSystemUptime();

      if (ntpTime != null && uptime != null) {
        final prefs = await SharedPreferences.getInstance();

        // Store both NTP time and system uptime together
        await prefs.setInt(_keyNtpTime, ntpTime.millisecondsSinceEpoch);
        await prefs.setInt(_keySystemUptime, uptime);

        timber(
          'System Uptime: ${uptime}ms (${Duration(milliseconds: uptime).inHours}h)',
        );
        return true;
      }

      timber('Failed to get NTP time or system uptime');
      return false;
    } catch (e) {
      timber('Sync failed: $e');
      return false;
    }
  }

  /// Get accurate current time (online or offline)
  /// - Online: Fetches fresh NTP time
  /// - Offline: Calculates from stored NTP time + system uptime delta
  /// Returns null if no cached data or device was rebooted
  static Future<DateTime?> getAccurateTime() async {
    try {
      // First, try to get fresh NTP time if online
      DateTime? kronosTime = await FlutterKronosPlus.getNtpDateTime;

      if (kronosTime != null) {
        // Online - update persistence and return fresh time
        await syncAndPersist();
        return kronosTime;
      }

      // Offline - calculate from stored data using system uptime

      final prefs = await SharedPreferences.getInstance();
      final storedNtpTime = prefs.getInt(_keyNtpTime);
      final storedUptime = prefs.getInt(_keySystemUptime);

      if (storedNtpTime == null || storedUptime == null) {
        timber('No cached time data available - need initial sync');
        return null;
      }

      // Get current system uptime
      int? currentUptime = await getSystemUptime();

      if (currentUptime == null) {
        timber('Cannot get current system uptime');
        return null;
      }

      // Check if device was rebooted (current uptime < stored uptime)
      if (currentUptime < storedUptime) {
        timber('Device was rebooted (uptime reset) - need new sync');
        timber('   Stored uptime: ${storedUptime}ms');
        timber('   Current uptime: ${currentUptime}ms');
        return DateTime.now();
      }

      // Calculate elapsed time since last sync (using monotonic clock!)
      final uptimeDelta = currentUptime - storedUptime;

      // Calculate accurate current time
      final accurateTime = DateTime.fromMillisecondsSinceEpoch(
        storedNtpTime + uptimeDelta,
      );

      timber(
        'Stored NTP Time: ${DateTime.fromMillisecondsSinceEpoch(storedNtpTime)}',
      );
      timber(' Stored Uptime: ${storedUptime}ms');
      timber(' Current Uptime: ${currentUptime}ms');
      timber(
        'Uptime Delta: ${uptimeDelta}ms (${Duration(milliseconds: uptimeDelta).inHours}h ${Duration(milliseconds: uptimeDelta).inMinutes % 60}m)',
      );
      timber('Calculated Accurate Time: $accurateTime');

      return accurateTime;
    } catch (e) {
      timber('Error getting accurate time: $e');
      return null;
    }
  }

  /// Check if cached time data is available
  static Future<bool> hasCachedTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyNtpTime) &&
        prefs.containsKey(_keySystemUptime);
  }

  /// Get cache status message for user display
  static Future<String> getCacheStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final storedNtpTime = prefs.getInt(_keyNtpTime);
    final storedUptime = prefs.getInt(_keySystemUptime);

    if (storedNtpTime == null || storedUptime == null) {
      return 'No sync data available';
    }

    final currentUptime = await getSystemUptime();

    if (currentUptime == null) {
      return 'Cannot read system uptime';
    }

    if (currentUptime < storedUptime) {
      return 'Device was restarted - sync required';
    }

    final hoursSinceSync = Duration(
      milliseconds: currentUptime - storedUptime,
    ).inHours;

    final lastSyncTime = DateTime.fromMillisecondsSinceEpoch(storedNtpTime);

    return 'Last synced $hoursSinceSync hours ago at ${lastSyncTime.hour}:${lastSyncTime.minute.toString().padLeft(2, '0')}';
  }

  /// Clear cached time data (useful for testing or manual reset)
  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyNtpTime);
    await prefs.remove(_keySystemUptime);
    timber('Time cache cleared');
  }
}
