import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'package:miracle_experience_mobile_app/core/basic_features.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/response_model/model_response_balloon_manifest_entity.dart';
import 'package:miracle_experience_mobile_app/core/network/api_result.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/cubit/balloon_manifest_cubit.dart';
import 'package:miracle_experience_mobile_app/features/balloon_manifest/widgets/manifest_content_widget.dart';
import 'package:miracle_experience_mobile_app/features/balloon_manifest/widgets/time_sync_required_widget.dart';
import 'package:miracle_experience_mobile_app/features/balloon_manifest/widgets/no_data_available_widget.dart';

import '../../core/utils/secure_time_helper.dart';

/// Balloon Manifest Screen with offline support and secure time validation
///
/// Features:
/// - Displays balloon assignment manifest data
/// - Works offline after initial sync
/// - Validates time using tamper-proof system uptime
/// - Shows data only before 11:00 AM EAT cutoff on manifest date
class BalloonManifestScreen extends StatefulWidget {
  const BalloonManifestScreen({super.key});

  @override
  State<BalloonManifestScreen> createState() => _BalloonManifestScreenState();
}

class _BalloonManifestScreenState extends State<BalloonManifestScreen>
    with WidgetsBindingObserver {
  // ========== Dependencies ==========
  late final BalloonManifestCubit _balloonManifestCubit;

  // ========== State Variables ==========
  bool _hasCachedTime = false;
  String _cacheStatus = '';
  bool _isSyncing = false;

  // ========== Lifecycle Methods ==========

  @override
  void initState() {
    super.initState();
    _initializeDependencies();
    _initializeTimezone();
    _registerLifecycleObserver();
    _initializeTimeSync();
    _loadManifestData();
  }

  @override
  void dispose() {
    _unregisterLifecycleObserver();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _onAppResumed();
    }
  }

  // ========== Initialization Methods ==========

  void _initializeDependencies() {
    _balloonManifestCubit = BalloonManifestCubit();
  }

  void _initializeTimezone() {
    tz.initializeTimeZones();
  }

  void _registerLifecycleObserver() {
    WidgetsBinding.instance.addObserver(this);
  }

  void _unregisterLifecycleObserver() {
    WidgetsBinding.instance.removeObserver(this);
  }

  void _loadManifestData() {
    _balloonManifestCubit.callBalloonManifestAPI();
  }

  // ========== Time Sync Methods ==========

  /// Initialize time sync on app start
  Future<void> _initializeTimeSync() async {
    await _syncTime();
    await _updateCacheStatus();
  }

  /// Called when app resumes from background
  Future<void> _onAppResumed() async {
    await _syncTime();
    await _updateCacheStatus();
  }

  /// Sync time with NTP servers
  Future<void> _syncTime() async {
    try {
      await SecureTimeHelper.syncAndPersist();
    } catch (e) {
      debugPrint('Time sync error: $e');
    }
  }

  /// Update cache status information
  Future<void> _updateCacheStatus() async {
    final hasCached = await SecureTimeHelper.hasCachedTime();
    final status = await SecureTimeHelper.getCacheStatus();

    if (mounted) {
      setState(() {
        _hasCachedTime = hasCached;
        _cacheStatus = status;
      });
    }
  }

  /// Manual sync triggered by user
  Future<void> _handleManualSync() async {
    if (_isSyncing) return;

    setState(() => _isSyncing = true);

    _showSyncingSnackbar();

    final success = await SecureTimeHelper.syncAndPersist();

    setState(() => _isSyncing = false);

    if (success) {
      await _updateCacheStatus();
      _showSyncSuccessSnackbar();
      setState(() {}); // Refresh UI
    } else {
      _showSyncFailedSnackbar();
    }
  }

  // ========== Validation Methods ==========

  /// Validate if offline manifest data can be shown
  /// Returns true only if current time is before 11:00 AM EAT on manifest date
  Future<bool> _canShowOfflineData(String manifestDateStr) async {
    try {
      // Get accurate time (online or calculated via system uptime)
      final accurateTime = await SecureTimeHelper.getAccurateTime();

      if (accurateTime == null) {
        debugPrint('⚠️ Cannot get accurate time for validation');
        return false;
      }

      // Convert to EAT timezone (East Africa Time - UTC+3)
      final eatLocation = tz.getLocation('Africa/Nairobi');
      final eatTime = tz.TZDateTime.from(accurateTime, eatLocation);

      // Parse manifest date
      final manifestDate = DateTime.parse(manifestDateStr);

      // Create cutoff time: manifestDate at 11:00 AM EAT
      final cutoffTime = _createCutoffTime(eatLocation, manifestDate);

      final canShow = eatTime.isBefore(cutoffTime);

      _logValidationResult(eatTime, cutoffTime, canShow);

      return canShow;
    } catch (e) {
      debugPrint('❌ Validation error: $e');
      return false;
    }
  }

  /// Create cutoff time for validation (11:00 AM EAT)
  tz.TZDateTime _createCutoffTime(tz.Location location, DateTime manifestDate) {
    return tz.TZDateTime(
      location,
      manifestDate.year,
      manifestDate.month,
      manifestDate.day,
      11, // 11 AM
      0, // 0 minutes
      0, // 0 seconds
    );
  }

  /// Log validation result for debugging
  void _logValidationResult(
    tz.TZDateTime currentTime,
    tz.TZDateTime cutoffTime,
    bool canShow,
  ) {
    debugPrint('🕐 Current EAT Time: $currentTime');
    debugPrint('⏰ Cutoff Time (11 AM): $cutoffTime');
    debugPrint(
      canShow
          ? '✅ Can show offline data'
          : '❌ Data expired (past 11 AM cutoff)',
    );
  }

  // ========== Snackbar Methods ==========

  void _showSyncingSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Syncing time...'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showSyncSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Time synced successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showSyncFailedSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('❌ Sync failed. Check internet connection.'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  // ========== UI Builder Methods ==========

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(title: const Text('Balloon Manifest', style: TextStyle(fontWeight: FontWeight.bold),), elevation: 2, backgroundColor: ColorConst.whiteColor, centerTitle: true,);
  }

  Widget _buildBody() {
    return BlocProvider.value(
      value: _balloonManifestCubit,
      child:
          BlocBuilder<
            BalloonManifestCubit,
            APIResultState<ModelResponseBalloonManifestEntity>?
          >(builder: (context, state) => _buildContent(state)),
    );
  }

  Widget _buildContent(
    APIResultState<ModelResponseBalloonManifestEntity>? state,
  ) {
    // Loading state
    if (state?.resultType == null ||
        state?.resultType == APIResultType.loading) {
      return _buildLoadingState();
    }

    // Error state (offline or failed)
    if (state?.resultType == APIResultType.failure ||
        state?.resultType == APIResultType.noInternet) {
      return _handleOfflineState();
    }

    // Success state (online)
    if (state?.resultType == APIResultType.success && state?.result != null) {
      return _handleSuccessState(state!.result!);
    }

    // Generic error state
    return _buildGenericErrorState(state?.message);
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _handleSuccessState(ModelResponseBalloonManifestEntity result) {
    // Save to cache
    SharedPrefUtils.setBalloonManifest(result.toString());

    // Display content
    return ManifestContentWidget(manifest: result, isOfflineMode: false);
  }

  Widget _handleOfflineState() {
    final cachedData = SharedPrefUtils.getBalloonManifest();

    // No cached data available
    if (cachedData == null || cachedData.manifestDate == null) {
      return NoDataAvailableWidget(onRetry: _handleManualSync);
    }

    // Validate cached data with time check
    return FutureBuilder<bool>(
      future: _canShowOfflineData(cachedData.manifestDate!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        if (snapshot.hasData && snapshot.data == true) {
          // Can show cached data
          return ManifestContentWidget(
            manifest: cachedData,
            isOfflineMode: true,
          );
        }
        // return SizedBox();

        // Cannot show cached data (expired or no valid time)
        return TimeSyncRequiredWidget(
          hasCachedTime: _hasCachedTime,
          cacheStatus: _cacheStatus,
          onSyncPressed: _handleManualSync,
          isSyncing: _isSyncing,
        );
      },
    );
  }

  Widget _buildGenericErrorState(String? message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              message ?? 'An error occurred',
              style: fontStyleSemiBold14,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadManifestData,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
