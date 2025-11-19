part of '../../wavier_list_screen.dart';

class TabletSpecialRequestItem extends StatefulWidget {
  const TabletSpecialRequestItem({
    super.key,
    required this.passenger,
    required this.waiverListHelper,
  });

  final Map<String, dynamic> passenger;
  final WaiverListHelper waiverListHelper;

  @override
  State<TabletSpecialRequestItem> createState() =>
      _TabletSpecialRequestItemState();
}

class _TabletSpecialRequestItemState extends State<TabletSpecialRequestItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          Row(
            children: [
              // Full Name
              Expanded(
                child: CommonTextField(
                  title: AppString.fullName.endWithColon(),
                  textController: TextEditingController(
                    text: widget.passenger['name'],
                  ),
                  readOnly: true,
                ),
              ),
              const SizedBox(width: 16),

              // Special Request
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    ListBottomSheet.buildSheet(
                      context: context,
                      title: AppString.specialRequest,
                      items: widget.waiverListHelper.specialRequests,
                      currentValue: widget.passenger['special'],
                      onTap: (selectedItem) {
                        setState(() {
                          widget.passenger['special'] = selectedItem;
                        });
                      },
                    );
                  },
                  child: CommonTextField(
                    title: AppString.specialRequest,
                    textController: TextEditingController(
                      text: widget.passenger['special'],
                    ),
                    readOnly: true,
                    textStyle: fontStyleRegular14,
                    suffixIcon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: ColorConst.arrowColor,
                      size: 25,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Dietary Restriction + Medical Condition
          Row(
            children: [
              Expanded(
                child: CommonTextField(
                  title: AppString.dietaryRestriction.endWithColon(),
                  hintText: AppString.ifNothingLeaveBlank,
                  keyBoardType: TextInputType.text,
                  textController: TextEditingController(
                    text: widget.passenger['dietary'],
                  ),
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: CommonTextField(
                  title: AppString.medicalCondition.endWithColon(),
                  textController: TextEditingController(
                    text: widget.passenger['medical'],
                  ),
                  hintText: AppString.ifNothingLeaveBlank,
                  keyBoardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
