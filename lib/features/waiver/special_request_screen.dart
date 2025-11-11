import 'package:flutter/material.dart';
import 'package:miracle_experience_mobile_app/core/basic_features.dart';

class SpecialRequestScreen extends StatefulWidget {
  const SpecialRequestScreen({super.key});

  @override
  State<SpecialRequestScreen> createState() => _SpecialRequestScreenState();
}

class _SpecialRequestScreenState extends State<SpecialRequestScreen> {
  final List<Map<String, dynamic>> passengers = [
    {
      'name': 'Denise Burcksen',
      'dietary': 'No kiwi or goat cheese',
      'medical': '',
      'special': 'Special Request',
    },
    {
      'name': 'Kathleen Whalen',
      'dietary': '',
      'medical': '',
      'special': 'Special Request',
    },
    {
      'name': 'Janice Alt',
      'dietary': '',
      'medical': '',
      'special': 'Special Request',
    },
    {
      'name': 'Connie Koenigkann',
      'dietary': '',
      'medical': '',
      'special': 'Special Request',
    },
  ];

  final List<String> specialRequests = [
    'Special request',
    'Birthday',
    'Anniversary',
    'Honeymoon',
    'Engagement',
    'Graduation',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConst.whiteColor,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: ColorConst.textColor,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text("Kiki Fam Trip x 5 - SJKD-040725", style: fontStyleBold18),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: ListView.separated(
          itemCount: passengers.length,
          separatorBuilder: (context, index) =>
              Divider(height: 30, thickness: 0.5, color: Colors.grey.shade300),
          itemBuilder: (context, index) {
            final passenger = passengers[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Full Name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppString.fullName.endWithColon(),
                              style: fontStyleSemiBold14,
                            ),
                            const SizedBox(height: 5),
                            CommonTextField(
                              textController: TextEditingController(
                                text: passenger['name'],
                              ),
                              readOnly: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Special Request
                      Expanded(
                        child: Column(
                          children: [
                            Text('', style: fontStyleSemiBold14),
                            const SizedBox(height: 5),
                            GestureDetector(
                              onTap: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                final selected = await CustomBottomSheet.instance.modalBottomSheet(
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
                                            AppString.specialRequest,
                                            style: fontStyleSemiBold18,
                                          ),
                                        ),
                                        const SizedBox(height: 25),
                                        Flexible(
                                          child: ListView.builder(
                                            primary: false,
                                            shrinkWrap: true,
                                            padding: EdgeInsets.zero,
                                            itemCount: specialRequests.length,
                                            itemBuilder: (context, int index) {
                                              return Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 5,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      ColorConst.dividerColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: ListTile(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  title: Center(
                                                    child: Text(
                                                      specialRequests[index],
                                                      style:
                                                          fontStyleSemiBold16,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  trailing:
                                                      specialRequests[index] ==
                                                          passenger['special']
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
                                                      specialRequests[index],
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
                                  setState(() {
                                    passenger['special'] = selected!;
                                  });
                                  // helper.selectedArea.value = selected;
                                }
                              },
                              child:
                                  CommonTextField(
                                    textController: TextEditingController(
                                      text: passenger['special'],
                                    ),
                                    readOnly: true,
                                    textStyle: fontStyleMedium16,
                                    suffixIcon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: ColorConst.arrowColor,
                                      size: 25,
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Dietary Restriction + Medical Condition
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppString.dietaryRestriction.endWithColon(),
                              style: fontStyleSemiBold14,
                            ),
                            const SizedBox(height: 6),
                            CommonTextField(
                              hintText: AppString.ifNothingLeaveBlank,
                              keyBoardType: TextInputType.text,
                              textController: TextEditingController(
                                text: passenger['dietary'],
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppString.medicalCondition.endWithColon(),
                              style: fontStyleSemiBold14,
                            ),
                            const SizedBox(height: 6),
                            CommonTextField(
                              textController: TextEditingController(
                                text: passenger['medical'],
                              ),
                              hintText: AppString.ifNothingLeaveBlank,
                              keyBoardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
