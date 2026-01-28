import 'package:flutter/material.dart';
import 'package:miracle_experience_mobile_app/core/basic_features.dart';
import 'package:miracle_experience_mobile_app/features/balloon_manifest/balloon_manifest_screen.dart';
import 'package:miracle_experience_mobile_app/features/balloon_manifest/pax_arrangement/pax_arrangement_screen.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/cubit/balloon_manifest_cubit.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/helper_models/offline_sync_response_model.dart';
import 'package:miracle_experience_mobile_app/features/network_helper/models/response_model/model_response_balloon_manifest_entity.dart';

part 'widgets/mobile_view/mobile_header_widget.dart';
part 'widgets/tablet_view/tablet_header_widget.dart';
part 'widgets/common_view/header_info_widget.dart';
part 'widgets/common_view/passenger_detail_bottom_sheet.dart';
part 'widgets/tablet_view/pax_tablet_view.dart';
part 'widgets/mobile_view/pax_mobile_view.dart';
part 'widgets/common_view/total_weight_widget.dart';
part 'widgets/common_view/empty_pax_widget.dart';

class BalloonManifestBody extends StatefulWidget {
  final List<ModelResponseBalloonManifestAssignmentsPaxes> passengers;
  final BalloonManifestHelper helper;
  final ModelResponseBalloonManifestEntity manifest;
  final ModelResponseBalloonManifestAssignments assignment;

  const BalloonManifestBody({
    super.key,
    required this.passengers,
    required this.helper,
    required this.manifest,
    required this.assignment,
  });

  @override
  State<BalloonManifestBody> createState() => _BalloonManifestBodyState();
}

class _BalloonManifestBodyState extends State<BalloonManifestBody> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LandscapeSide>(
      future: Const.getLandscapeSide(),
      builder: (context, snapshot) {
        final side = snapshot.data ?? LandscapeSide.none;

        // Dynamic padding
        final double leftPaddingForLandscapeMobile =
            !Const.isTablet && side == LandscapeSide.left ? 44 : 25;

        final double rightPaddingForLandscapeMobile =
            !Const.isTablet && side == LandscapeSide.right ? 44 : 10;

        if (widget.passengers.isEmpty) {
          return EmptyPaxWidget();
        }

        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  widget.helper.loadManifestData();
                },
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Column(
                          children: [
                            _buildHeader(),
                            const Divider(height: 1, thickness: 1),

                            if (Const.isTablet || Const.isLandscape) ...[
                              PaxTabletView(
                                leftPadding: leftPaddingForLandscapeMobile,
                                rightPadding: rightPaddingForLandscapeMobile,
                                passengers: widget.passengers,
                                assignment: widget.assignment,
                              ),
                            ] else ...[
                              PaxMobileView(passengers: widget.passengers, assignment: widget.assignment),
                            ],

                            Divider(
                              height: 1,
                              thickness: 0.5,
                              color: Colors.grey.shade300,
                            ),

                            TotalWeightWidget(passengers: widget.passengers),

                            if (Const.isTablet || Const.isLandscape)
                              SizedBox(
                                height:
                                    Dimensions.getSafeAreaBottomHeight() + 10,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            if (!Const.isTablet && !Const.isLandscape)
              MobileViewSignWidget(
                helper: widget.helper,
                manifestId: widget.manifest.uniqueId,
                assignmentId: widget.assignment.id,
              ),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    return BlocConsumer<OfflineSyncCubit, OfflineSyncResponseModel>(
      listener: (context, state) {
        if (state.signatureStatus == SignatureStatus.success) {
          widget.helper.signatureStatus.value = SignatureStatus.success;
          final cacheData = SharedPrefUtils.getBalloonManifest();
          if (cacheData != null &&
              cacheData.assignments.isNotNullAndEmpty &&
              cacheData.assignments!.first.signature != null) {
            widget.helper.signatureTime.value = Const.convertDateTimeToDMYHM(
              cacheData.assignments!.first.signature!.date!,
            );
          }
        }
      },
        builder: (context, syncState) {
        final showOfflineMessage =
            syncState.offlineSyncState == OfflineSyncState.pending ||
            syncState.offlineSyncState == OfflineSyncState.syncing;

          return ValueListenableBuilder<SignatureStatus>(
            valueListenable: widget.helper.signatureStatus,
            builder: (context, value, child) {
              return Column(
                children: [
                  if(showOfflineMessage) ///todo
                  Text(AppString.connectToInternetMessage, style: fontStyleRegular14.apply(color: ColorConst.primaryColor), textAlign: TextAlign.center,),
                  SizedBox(height: 8,),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Const.isTablet || Const.isLandscape ? 25 : 16,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: value == SignatureStatus.success
                          ? ColorConst.successColor
                          : ColorConst.primaryColor,
                    ),
                    child: Const.isTablet || Const.isLandscape
                        ? TabletHeaderWidget(
                            status: value,
                            manifest: widget.manifest,
                            assignment: widget.assignment,
                            helper: widget.helper,
                          )
                        : MobileHeaderWidget(
                            manifest: widget.manifest,
                            assignment: widget.assignment,
                          ),
                  ),
                ],
              );
            },
          );
        }
      );
  }
}
