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
    // return _buildMobilewaiversList();
    return Column(
      children: [
        // 🔹 Filter Row
        Container(
          color: ColorConst.dividerColor,
          child: IntrinsicHeight(
            child: Row(
              children: [
                // Location dropdown
                Expanded(
                  child: ValueListenableBuilder<String>(
                    valueListenable: widget.helper.selectedArea,
                    builder: (context, area, _) {
                      return GestureDetector(
                        onTap: () async {
                          final selected = await CustomBottomSheet.instance
                              .modalBottomSheet(
                                context: context,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.of(context).size.height *
                                        0.8,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const SizedBox(height: 35),
                                      Center(
                                        child: Text(
                                          "Filter location",
                                          style: fontStyleSemiBold18,
                                        ),
                                      ),
                                      const SizedBox(height: 25),
                                      Flexible(
                                        child: ListView.builder(
                                          primary: false,
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          itemCount:
                                              widget.helper.areaList.length,
                                          itemBuilder: (context, int index) {
                                            return Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 5,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: ColorConst.dividerColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: ListTile(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                title: Center(
                                                  child: Text(
                                                    widget
                                                        .helper
                                                        .areaList[index],
                                                    style: fontStyleSemiBold16,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                trailing:
                                                    widget
                                                            .helper
                                                            .areaList[index] ==
                                                        area
                                                    ? const Icon(
                                                        Icons.check,
                                                        color: ColorConst
                                                            .primaryColor,
                                                        size: 20,
                                                      )
                                                    : const SizedBox(
                                                        width: 20,
                                                        height: 20,
                                                      ),
                                                leading: const SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                ),
                                                onTap: () {
                                                  Navigator.pop(
                                                    context,
                                                    widget
                                                        .helper
                                                        .areaList[index],
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              );

                          if (selected != null) {
                            widget.helper.selectedArea.value = selected;
                          }
                        },
                        child: Container(
                          color: ColorConst.transparent,
                          padding: const EdgeInsets.only(
                            right: 15,
                            left: 20,
                            top: 20,
                            bottom: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(area, style: fontStyleSemiBold14),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                color: ColorConst.arrowColor,
                                size: 25,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                VerticalDivider(color: Color(0xfff0f0f0), thickness: 2),
                // Date picker
                Expanded(
                  child: ValueListenableBuilder<DateTime?>(
                    valueListenable: widget.helper.selectedDate,
                    builder: (context, date, _) {
                      return GestureDetector(
                        onTap: () async {
                          final picked = await openCalendar(
                            context: context,
                            initialDate: date ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2050),
                          );

                          if (picked != null) {
                            widget.helper.selectedDate.value = picked;
                          }
                        },
                        child: Container(
                          color: ColorConst.transparent,
                          padding: const EdgeInsets.only(
                            right: 15,
                            left: 20,
                            top: 20,
                            bottom: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Const.convertDateTimeToDMY(
                                  date ?? DateTime.now(),
                                ),
                                style: fontStyleSemiBold14,
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                color: ColorConst.arrowColor,
                                size: 25,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),

        // 🔹 Waiver List
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
                                  ? Row(
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
                                    )
                                  : Text(
                                      AppString.waiverPending,
                                      style: fontStyleMedium12.apply(
                                        color: ColorConst.primaryColor,
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
