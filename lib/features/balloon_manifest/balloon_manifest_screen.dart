import 'dart:io';
import 'package:flutter/material.dart';
import 'package:miracle_experience_mobile_app/core/network/base_response_model_entity.dart';
import 'package:miracle_experience_mobile_app/core/widgets/show_snakbar.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/cubit/auth_cubit.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/request_model/model_request_signin_entity.dart';
import 'package:miracle_experience_mobile_app/core/basic_features.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/response_model/model_response_balloon_manifest_entity.dart';
import 'package:miracle_experience_mobile_app/core/network/api_result.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/cubit/balloon_manifest_cubit.dart';
import 'package:miracle_experience_mobile_app/features/balloon_manifest/widgets/manifest_content_widget.dart';
import 'package:miracle_experience_mobile_app/features/balloon_manifest/widgets/time_sync_required_widget.dart';
import 'package:miracle_experience_mobile_app/features/balloon_manifest/widgets/no_data_available_widget.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../core/utils/secure_time_helper.dart';
import '../authentications/signin_screen.dart';

part 'widgets/manifest_app_bar.dart';
part 'balloon_manifest_helper.dart';

class BalloonManifestScreen extends StatefulWidget {
  const BalloonManifestScreen({super.key});

  @override
  State<BalloonManifestScreen> createState() => _BalloonManifestScreenState();
}

class _BalloonManifestScreenState extends State<BalloonManifestScreen>
    with WidgetsBindingObserver {
  final helper = BalloonManifestHelper();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    helper.initialize();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      helper.onAppResumed();
    }
  }

  // ========================= UI =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: ManifestAppBar(helper: helper,), body: _buildBody());
  }

  Widget _buildBody() {
    return BlocProvider.value(
      value: helper.balloonManifestCubit,
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
    if (state?.resultType == null ||
        state?.resultType == APIResultType.loading) {
      return _buildLoadingState();
    }

    if (state?.resultType == APIResultType.noInternet) {
      return _handleOfflineState();
    }

    if (state?.resultType == APIResultType.success && state?.result != null) {
      return _handleSuccessState(state!.result!);
    }

    return _buildGenericErrorState(state?.message);
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _handleSuccessState(ModelResponseBalloonManifestEntity result) {
    SharedPrefUtils.setBalloonManifest(result.toString());
    return ManifestContentWidget(manifest: result, isOfflineMode: false);
  }

  Widget _handleOfflineState() {
    final cachedData = SharedPrefUtils.getBalloonManifest();

    if (cachedData == null || cachedData.manifestDate == null) {
      return const NoDataAvailableWidget();
    }

    return FutureBuilder<bool>(
      future: helper.canShowOfflineData(cachedData.manifestDate!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        if (snapshot.hasData && snapshot.data == true) {
          return ManifestContentWidget(
            manifest: cachedData,
            isOfflineMode: true,
          );
        }

        // Reactive cache info updates
        return ValueListenableBuilder<bool>(
          valueListenable: helper.hasCachedTime,
          builder: (context, hasCached, _) {
            return ValueListenableBuilder<String>(
              valueListenable: helper.cacheStatus,
              builder: (context, status, _) {
                return TimeSyncRequiredWidget(
                  hasCachedTime: hasCached,
                  cacheStatus: status,
                );
              },
            );
          },
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
              onPressed: helper.loadManifestData,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  ColorConst.primaryColor,
                ),
                foregroundColor: WidgetStateProperty.all(ColorConst.whiteColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
