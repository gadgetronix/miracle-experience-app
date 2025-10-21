import 'package:flutter/material.dart';
import 'package:miracle_experience_mobile_app/core/basic_features.dart';

/// Widget displayed when time sync is required
class TimeSyncRequiredWidget extends StatelessWidget {
  final bool hasCachedTime;
  final String cacheStatus;
  final VoidCallback onSyncPressed;
  final bool isSyncing;

  const TimeSyncRequiredWidget({
    super.key,
    required this.hasCachedTime,
    required this.cacheStatus,
    required this.onSyncPressed,
    required this.isSyncing,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIcon(),
            const SizedBox(height: 24),
            _buildTitle(),
            const SizedBox(height: 12),
            _buildMessage(),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.sync_problem,
        size: 64,
        color: Colors.orange.shade700,
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Time Sync Required',
      style: fontStyleSemiBold18,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMessage() {
    String message;
    
    if (!hasCachedTime) {
      message = 'Please connect to internet once to enable offline access.';
    } else if (cacheStatus.contains('restarted')) {
      message = 'Your device was restarted. Please connect to internet to re-sync time.';
    } else {
      message = 'Manifest data has expired.';
    }

    return Text(
      message,
      style: fontStyleRegular14,
      textAlign: TextAlign.center,
    );
  }

  }
