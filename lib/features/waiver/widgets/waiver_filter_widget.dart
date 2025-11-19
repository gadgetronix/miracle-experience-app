part of '../wavier_list_screen.dart';

class WaiverFilterWidget extends StatelessWidget {
  const WaiverFilterWidget({super.key, required this.helper});

  final WaiverListHelper helper;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorConst.dividerColor,
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Location dropdown
            Expanded(
              child: ValueListenableBuilder<String>(
                valueListenable: helper.selectedArea,
                builder: (context, area, _) {
                  return GestureDetector(
                    onTap: () async {
                      final selected = await CustomBottomSheet.instance
                          .modalBottomSheet(
                            context: context,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 35),
                                Center(
                                  child: Text(
                                    AppString.filterLocation,
                                    style: fontStyleSemiBold18,
                                  ),
                                ),
                                const SizedBox(height: 25),
                                Flexible(
                                  child: ListView.builder(
                                    primary: false,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemCount: helper.areaList.length,
                                    itemBuilder: (context, int index) {
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: ColorConst.dividerColor,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: ListTile(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          title: Center(
                                            child: Text(
                                              helper.areaList[index],
                                              style: fontStyleSemiBold16,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          trailing:
                                              helper.areaList[index] == area
                                              ? const Icon(
                                                  Icons.check,
                                                  color:
                                                      ColorConst.primaryColor,
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
                                              helper.areaList[index],
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
                          );

                      if (selected != null) {
                        helper.selectedArea.value = selected;
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
                valueListenable: helper.selectedDate,
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
                        helper.selectedDate.value = picked;
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
                            Const.convertDateTimeToDMY(date ?? DateTime.now()),
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
    );
  }
}
