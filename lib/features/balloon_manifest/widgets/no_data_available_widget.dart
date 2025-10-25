import 'package:flutter/material.dart';
import 'package:miracle_experience_mobile_app/core/basic_features.dart';

/// Widget displayed when no manifest data is available
class NoDataAvailableWidget extends StatelessWidget {
  const NoDataAvailableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No Data Available',
              style: fontStyleSemiBold18,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
