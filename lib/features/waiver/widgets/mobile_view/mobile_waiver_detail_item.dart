part of '../../waiver_details_screen.dart';

class MobileWaiverDetailItem extends StatefulWidget {
  const MobileWaiverDetailItem({super.key, required this.passenger, required this.gender, required this.weightType, required this.country, required this.specialRequests});

  final Map<String, dynamic> passenger;
  final List<String> gender, weightType, country, specialRequests;

  @override
  State<MobileWaiverDetailItem> createState() => _MobileWaiverDetailItemState();
}

class _MobileWaiverDetailItemState extends State<MobileWaiverDetailItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                            // First Name
                            CommonTextField(
                              title: AppString.firstName.endWithColon(),
                              textController: TextEditingController(
                                text: widget.passenger['firstName'],
                              ),
                              keyBoardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              hintText: AppString.firstName,
                              
                            ),
                            const SizedBox(height: 10),
                            // Last Name
                            CommonTextField(
                              title: AppString.lastName.endWithColon(),
                              textController: TextEditingController(
                                text: widget.passenger['lastName'],
                              ),
                              keyBoardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              hintText: AppString.lastName,
                              
                            ),
                            const SizedBox(height: 10),
                            

                        Row(
                          children: [

                            // Age
                            Expanded(
                              flex: 2,
                              child: CommonTextField(
                                title: AppString.age.endWithColon(),
                                textController: TextEditingController(
                                  text: widget.passenger['age'].toString(),
                                ),
                                keyBoardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                hintText: AppString.age,
                                
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                          
                        const SizedBox(width: 10),

                            //weight
                            Expanded(
                              flex: 1,
                              child: CommonTextField(
                                title: AppString.weight.endWithColon(),
                                hintText: AppString.weight,
                                keyBoardType: TextInputType.number,
                                
                                textController: TextEditingController(
                                  text: widget.passenger['weight'],
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                maxLength: 3,
                                textInputAction: TextInputAction.done,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                              ),
                            ),

                            SizedBox(width: 3.0),
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () async {
                                  FocusManager.instance.primaryFocus?.unfocus();

                                  ListBottomSheet.buildSheet(
                                    context: context,
                                    title: AppString.weight,
                                    items: widget.weightType,
                                    currentValue: widget.passenger['weightType'],
                                    onTap: (String selectedItem) {
                                      setState(() {
                                        widget.passenger['weightType'] = selectedItem;
                                      });
                                    },
                                  );
                                },
                                child: CommonTextField(
                                  title: '',
                                  textController: TextEditingController(
                                    text: widget.passenger['weightType'],
                                  ),
                                  readOnly: true,
                                  textStyle: fontStyleRegular14,
                                  suffixIcon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: ColorConst.arrowColor,
                                    size: 25,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                ),
                              ),
                            ),]),

                            const SizedBox(height: 10),

                            Row(
                              children: [

//Gender
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () async {
                                  FocusManager.instance.primaryFocus?.unfocus();
                              
                                  ListBottomSheet.buildSheet(
                                    context: context,
                                    title: AppString.gender,
                                    items: widget.gender,
                                    currentValue: widget.passenger['gender'],
                                    onTap: (String selectedItem) {
                                      setState(() {
                                        widget.passenger['gender'] = selectedItem;
                                      });
                                    },
                                  );
                                },
                                child: CommonTextField(
                                  title: AppString.gender.endWithColon(),
                                  textController: TextEditingController(
                                    text: widget.passenger['gender'],
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
                            const SizedBox(width: 10),

                            //country
                                Expanded(
                                  flex: 3,
                                  child: GestureDetector(
                                    onTap: () async {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      ListBottomSheet.buildSheet(
                                        context: context,
                                        title: AppString.country,
                                        items: widget.country,
                                        currentValue: widget.passenger['country'],
                                        onTap: (String selectedItem) {
                                          setState(() {
                                            widget.passenger['country'] = selectedItem;
                                          });
                                        },
                                      );
                                    },
                                    child: CommonTextField(
                                      title: AppString.country.endWithColon(),
                                      textController: TextEditingController(
                                        text: widget.passenger['country'],
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

                            const SizedBox(height: 10),
                            // Special Request
                            GestureDetector(
                              onTap: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                            
                                ListBottomSheet.buildSheet(
                                  context: context,
                                  title: AppString.specialRequest,
                                  items: widget.specialRequests,
                                  currentValue: widget.passenger['special'],
                                  onTap: (String selectedItem) {
                                    setState(() {
                                      widget.passenger['special'] = selectedItem;
                                    });
                                  },
                                );
                              },
                              child: CommonTextField(
                                title: AppString.specialRequest.endWithColon(),
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
                            const SizedBox(height: 10),
                            // Dietary Restriction
                            CommonTextField(
                              title: AppString.dietaryRestriction
                                  .endWithColon(),
                              hintText: AppString.ifNothingLeaveBlank,
                              keyBoardType: TextInputType.text,
                              textController: TextEditingController(
                                text: widget.passenger['dietary'],
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                      ],
                    ),
                  );
  }
}