import 'package:flutter/material.dart';
import 'package:miracle_experience_mobile_app/core/basic_features.dart';
import 'package:miracle_experience_mobile_app/features/balloon_manifest/balloon_manifest_screen.dart';

/// Widget displayed when time sync is required
class TimeSyncRequiredWidget extends StatelessWidget {
  final bool hasCachedTime;
  final String cacheStatus;
  final BalloonManifestHelper helper;

  const TimeSyncRequiredWidget({
    super.key,
    required this.hasCachedTime,
    required this.cacheStatus,
    required this.helper,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        helper.loadManifestData();
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Center(
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
                ),
              ),
            ),
          );
        },
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
      child: Icon(Icons.sync_problem, size: 64, color: Colors.orange.shade700),
    );
  }

  Widget _buildTitle() {
    return Text(
      AppString.timeSyncRequired,
      style: fontStyleSemiBold18,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMessage() {
    String message;

    if (!hasCachedTime) {
      message = AppString.pleaseConnectToInternetOnceToEnableOfflineAccess;
    } else if (cacheStatus.contains('restarted')) {
      message = AppString.yourDeviceWasRestarted;
    } else {
      message = AppString.manifestDataHasExpired;
    }

    return Text(
      message,
      style: fontStyleRegular14,
      textAlign: TextAlign.center,
    );
  }
}
