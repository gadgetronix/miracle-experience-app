import 'dart:convert';
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
import 'package:miracle_experience_mobile_app/features/balloon_manifest/widgets/time_sync_required_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../core/utils/secure_time_helper.dart';
import '../authentications/signin_screen.dart';
import 'widgets/passengers_table_widget.dart';

part 'widgets/manifest_app_bar.dart';
part 'widgets/general_error_widget.dart';
part 'widgets/mobile_view/mobile_view_sign_widget.dart';
part 'widgets/signature_bottom_sheet.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ManifestAppBar(helper: helper),
      body: _buildBody(),
    );
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

    if (state?.resultType == APIResultType.success) {
      return _handleSuccessState(state?.result, message: state?.message);
    }

    return GeneralErrorWidget(
      message: state?.message ?? 'Something went wrong',
      helper: helper,
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _handleSuccessState(
    ModelResponseBalloonManifestEntity? result, {
    String? message,
  }) {
    SharedPrefUtils.setBalloonManifest(result.toString());
    final assignment = result == null
        ? null
        : result.assignments.isNotNullAndEmpty
        ? result.assignments!.first
        : null;
    helper.updateSignatureNotifiers(assignment: assignment, result: result);

    return assignment != null
        ? PassengersListWidget(
            passengers: assignment.paxes ?? [],
            manifest: result!,
            assignment: assignment,
            helper: helper,
          )
        : GeneralErrorWidget(
            message: message ?? AppString.noAssignmentsAvailable,
            helper: helper,
          );
  }

  Widget _handleOfflineState() {
    final cachedData = SharedPrefUtils.getBalloonManifest();

    if (cachedData == null || cachedData.manifestDate == null) {
      return GeneralErrorWidget(
        message: AppString.noAssignmentsAvailable,
        helper: helper,
      );
    }

    return FutureBuilder<bool>(
      future: helper.canShowOfflineData(cachedData.manifestDate!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        if (snapshot.hasData && snapshot.data == true) {
          final assignment = cachedData.assignments!.first;

          helper.updateSignatureNotifiers(
            assignment: assignment,
            result: cachedData,
          );

          return PassengersListWidget(
            passengers: assignment.paxes ?? [],
            manifest: cachedData,
            assignment: assignment,
            helper: helper,
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
}
