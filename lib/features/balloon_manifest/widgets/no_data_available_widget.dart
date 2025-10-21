import 'package:flutter/material.dart';
import 'package:miracle_experience_mobile_app/core/basic_features.dart';

/// Widget displayed when no manifest data is available
class NoDataAvailableWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const NoDataAvailableWidget({
    super.key,
    required this.onRetry,
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
            const SizedBox(height: 24),
            _buildRetryButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.cloud_off_outlined,
        size: 64,
        color: Colors.grey.shade400,
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'No Data Available',
      style: fontStyleSemiBold18,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildMessage() {
    return Text(
      'Please connect to the internet to load manifest data.',
      style: fontStyleRegular14,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildRetryButton() {
    return ElevatedButton.icon(
      onPressed: onRetry,
      icon: const Icon(Icons.refresh),
      label: const Text('Retry'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
