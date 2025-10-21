import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:miracle_experience_mobile_app/core/basic_features.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/response_model/model_response_balloon_manifest_entity.dart';
import 'package:miracle_experience_mobile_app/core/network/api_result.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/cubit/balloon_manifest_cubit.dart';


import '../../core/utils/secure_time_helper.dart';

class BalloonManifestScreen extends StatefulWidget {
  const BalloonManifestScreen({super.key});

  @override
  State<BalloonManifestScreen> createState() => _BalloonManifestScreenState();
}

class _BalloonManifestScreenState extends State<BalloonManifestScreen> 
    with WidgetsBindingObserver {
  final BalloonManifestCubit balloonManifestCubit = BalloonManifestCubit();
  bool _hasCachedTime = false;
  String _cacheStatus = '';
  
  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    WidgetsBinding.instance.addObserver(this);
    _initializeTime();
    balloonManifestCubit.callBalloonManifestAPI();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Re-sync when app comes to foreground
    if (state == AppLifecycleState.resumed) {
      _initializeTime();
    }
  }

  /// Initialize time sync on app start/resume
  Future<void> _initializeTime() async {
    // Try to sync (works if online, silent fail if offline)
    await SecureTimeHelper.syncAndPersist();
    
    // Check cache status
    final hasCached = await SecureTimeHelper.hasCachedTime();
    final status = await SecureTimeHelper.getCacheStatus();
    
    setState(() {
      _hasCachedTime = hasCached;
      _cacheStatus = status;
    });
  }

  /// Validate if offline manifest data can be shown
  /// Returns true if current time is before 11:00 AM EAT on manifestDate
  Future<bool> _canShowOfflineData(String manifestDateStr) async {
    try {
      // Get accurate time (online or calculated via system uptime)
      DateTime? accurateTime = await SecureTimeHelper.getAccurateTime();
      
      if (accurateTime == null) {
        timber('⚠️  Cannot get accurate time for validation');
        return false;
      }

      // Convert to EAT timezone (East Africa Time - UTC+3)
      final eatLocation = tz.getLocation('Africa/Nairobi');
      final eatTime = tz.TZDateTime.from(accurateTime, eatLocation);

      // Parse manifest date (e.g., "2025-10-22")
      final manifestDate = DateTime.parse(manifestDateStr);
      
      // Create cutoff time: manifestDate at 11:00 AM EAT
      final cutoffTime = tz.TZDateTime(
        eatLocation,
        manifestDate.year,
        manifestDate.month,
        manifestDate.day,
        11, // 11 AM
        0,  // 0 minutes
        0,  // 0 seconds
      );
      
      timber('🕐 Current EAT Time: $eatTime');
      timber('⏰ Cutoff Time (11 AM): $cutoffTime');
      
      final canShow = eatTime.isBefore(cutoffTime);
      timber(canShow ? '✅ Can show offline data' : '❌ Data expired (past 11 AM cutoff)');
      
      return canShow;
      
    } catch (e) {
      timber('❌ Validation error: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Balloon Manifest'),
        actions: [
          // Show sync status
          if (_hasCachedTime)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  _cacheStatus,
                  style: TextStyle(fontSize: 11, color: Colors.white70),
                ),
              ),
            ),
        ],
      ),
      body: BlocProvider.value(
        value: balloonManifestCubit,
        child: BlocBuilder<
            BalloonManifestCubit,
            APIResultState<ModelResponseBalloonManifestEntity>?>(
          builder: (_, state) {
            if (state?.resultType == null ||
                state?.resultType == APIResultType.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state != null) {
              if (state.resultType == APIResultType.success &&
                  state.result != null) {
                // Online - save and show data
                // final dummy = state.result;
                // dummy?.manifestDate = "2025-10-22"; // For testing
                // SharedPrefUtils.setBalloonManifest(dummy.toString());
                SharedPrefUtils.setBalloonManifest(state.result.toString());
                return _buildManifestContent(state.result!);
              } else {
                // Offline - validate with cached time
                final cachedData = SharedPrefUtils.getBalloonManifest();
                
                if (cachedData != null && cachedData.manifestDate != null) {
                  // Use FutureBuilder to handle async validation
                  return FutureBuilder<bool>(
                    future: _canShowOfflineData(cachedData.manifestDate!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      if (snapshot.hasData && snapshot.data == true) {
                        // Can show offline data
                        return _buildManifestContent(cachedData);
                      } else {
                        // Data expired or time validation failed
                        return _buildTimeSyncRequiredMessage();
                      }
                    },
                  );
                } else {
                  // No cached manifest data
                  return _buildNoDataMessage();
                }
              }
            }
            
            return Center(
              child: Text(
                state?.message ?? 'An error occurred',
                style: fontStyleSemiBold14,
              ),
            );
          },
        ),
      ),
    );
  }

  /// Build manifest content widget
  Widget _buildManifestContent(ModelResponseBalloonManifestEntity result) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.commonPaddingForScreen,
          vertical: Dimensions.h200,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Offline indicator
              if (result == SharedPrefUtils.getBalloonManifest())
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.offline_bolt, size: 16, color: Colors.orange.shade800),
                      SizedBox(width: 6),
                      Text(
                        'Offline Mode',
                        style: TextStyle(
                          color: Colors.orange.shade800,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Manifest data
              Text(
                'Balloon of Pilot: ${result.assignments?.first.pilotName ?? 'N/A'}',
                style: fontStyleSemiBold16,
              ),
              SizedBox(height: 16),
              
              // Add more manifest fields as needed
              Text(
                'Manifest Date: ${result.manifestDate ?? 'N/A'}',
                style: fontStyleRegular14,
              ),
              
              // Add more fields...
            ],
          ),
        ),
      ),
    );
  }

  /// Build time sync required message
  Widget _buildTimeSyncRequiredMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sync_problem,
              size: 64,
              color: Colors.orange,
            ),
            SizedBox(height: 24),
            Text(
              'Time Sync Required',
              style: fontStyleSemiBold16,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              _hasCachedTime 
                  ? _cacheStatus.contains('restarted')
                      ? 'Your device was restarted. Please connect to internet to sync time.'
                      : 'Manifest data has expired (past 11:00 AM EAT cutoff).'
                  : 'Please connect to internet once to enable offline access.',
              style: fontStyleRegular14,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            if (_hasCachedTime)
              Text(
                _cacheStatus,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                // Show loading
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Syncing time...')),
                );
                
                final success = await SecureTimeHelper.syncAndPersist();
                
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('✅ Time synced successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  setState(() {});
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('❌ Sync failed. Check internet connection.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              icon: Icon(Icons.sync),
              label: Text('Sync Time'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build no data message
  Widget _buildNoDataMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 24),
            Text(
              'No Data Available',
              style: fontStyleSemiBold16,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              'Please connect to the internet to load manifest data.',
              style: fontStyleRegular14,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
