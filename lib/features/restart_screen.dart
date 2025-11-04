import 'dart:io';

import 'package:flutter/material.dart';
import 'package:miracle_experience_mobile_app/core/basic_features.dart';

class RestartScreen extends StatelessWidget {
  const RestartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.whiteColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppString.restartDesc,
                  style: fontStyleRegular16,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConst.primaryColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    exit(0);
                  },
                  child: Text(
                    AppString.restartNow,
                    style: fontStyleRegular16.copyWith(color: ColorConst.whiteColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
