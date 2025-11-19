part of '../../wavier_list_screen.dart';

class MobileSpecialRequestItem extends StatefulWidget {
  const MobileSpecialRequestItem({super.key, required this.passenger, required this.waiverListHelper});

  final Map<String, dynamic> passenger;
  final WaiverListHelper waiverListHelper;

  @override
  State<MobileSpecialRequestItem> createState() => _MobileSpecialRequestItemState();
}

class _MobileSpecialRequestItemState extends State<MobileSpecialRequestItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(widget.passenger['name'], style: fontStyleSemiBold14,),
                  const SizedBox(height: 16),

                  GestureDetector(
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
                  const SizedBox(height: 16),

                  // Dietary Restriction 
                  CommonTextField(
                    title: AppString.dietaryRestriction.endWithColon(),
                    hintText: AppString.ifNothingLeaveBlank,
                    keyBoardType: TextInputType.text,
                    textController: TextEditingController(
                      text: widget.passenger['dietary'],
                    ),
                    textInputAction: TextInputAction.next,
                  ),

                  const SizedBox(height: 16),

                  CommonTextField(
                    title: AppString.medicalCondition.endWithColon(),
                    textController: TextEditingController(
                      text: widget.passenger['medical'],
                    ),
                    hintText: AppString.ifNothingLeaveBlank,
                    keyBoardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                ],
              ),
            );
  }
}