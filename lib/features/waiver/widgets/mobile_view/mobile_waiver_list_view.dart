part of '../../wavier_list_screen.dart';

class MobileWaiverListView extends StatefulWidget {
  const MobileWaiverListView({
    super.key,
    required this.waivers,
    required this.helper,
  });

  final List<ModelResponseWaiverListEntity> waivers;
  final WaiverListHelper helper;

  @override
  State<MobileWaiverListView> createState() => _MobileWaiverListViewState();
}

class _MobileWaiverListViewState extends State<MobileWaiverListView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WaiverFilterWidget(helper: widget.helper),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: widget.waivers.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final item = widget.waivers[index];
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: ColorConst.dividerColor,
                          width: index != widget.waivers.length - 1 ? 2 : 0,
                        ),
                      ),
                    ),
                    padding: EdgeInsets.only(left: 6),
                    child: ListTile(
                      title: Text(
                        "${item.customerName} x ${item.pax} ${item.bookingCode.isNotNullAndEmpty() ? item.bookingCode!.wrapWithBrackets() : ''}",
                        style: fontStyleMedium14,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${item.area}: ${item.pickupLocation}',
                            style: fontStyleRegular14.apply(
                              color: ColorConst.textSecondaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              item.isWaiverSigned == true
                                  ? GestureDetector(
                                    onTap: () => navigateToPage(SpecialRequestScreen(waiverListHelper: widget.helper)),
                                    child: Row(
                                        children: [
                                          Text(
                                            AppString.waiver,
                                            style: fontStyleMedium12.apply(
                                              color: ColorConst.successColor,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Image.asset(
                                            ImageAsset.icTickmark,
                                            width: 16,
                                            height: 16,
                                          ),
                                        ],
                                      ),
                                  )
                                  : GestureDetector(
                                    onTap: () => navigateToPage(WaiverDetailsScreen()),
                                    child: Text(
                                        AppString.waiverPending,
                                        style: fontStyleMedium12.apply(
                                          color: ColorConst.primaryColor,
                                        ),
                                      ),
                                  ),
                              if (item.isWaiverSigned == true) ...[
                                item.checkIn.isNullOrEmpty()
                                    ? Row(
                                        children: [
                                          Text(
                                            AppString.checkedIn,
                                            style: fontStyleMedium12.apply(
                                              color: ColorConst.successColor,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Image.asset(
                                            ImageAsset.icTickmark,
                                            width: 16,
                                            height: 16,
                                          ),
                                        ],
                                      )
                                    : Text(
                                        AppString.checkInPending,
                                        style: fontStyleMedium12.apply(
                                          color: ColorConst.blueColor,
                                        ),
                                      ),
                              ],
                            ],
                          ),
                        ],
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: ColorConst.arrowColor,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: 5,
                      decoration: BoxDecoration(
                        color: item.isWaiverSigned == false
                            ? ColorConst.primaryColor
                            : (item.isWaiverSigned == true &&
                                  item.checkIn.isNotNullOrEmpty())
                            ? ColorConst.successColor
                            : ColorConst.blueColor,
                        borderRadius: BorderRadius.only(
                          topRight: index == 0
                              ? Radius.elliptical((5.0), (15.0))
                              : Radius.zero,
                          bottomRight: index == widget.waivers.length - 1
                              ? Radius.elliptical((5.0), (15.0))
                              : Radius.zero,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}