part of 'wavier_list_screen.dart';

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
      'special': 'None',
    },
    {
      'name': 'Kathleen Whalen',
      'dietary': '',
      'medical': '',
      'special': 'None',
    },
    {
      'name': 'Janice Alt',
      'dietary': '',
      'medical': '',
      'special': 'None',
    },
    {
      'name': 'Connie Koenigkann',
      'dietary': '',
      'medical': '',
      'special': 'None',
    },
  ];

  final List<String> specialRequests = [
    'None',
    'Birthday',
    'Anniversary',
    'Honeymoon',
    'Engagement',
    'Graduation',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.backActionCenterTitleAppBar(
        title: "Kiki Fam Trip x 5 - SJKD-040725",
      ),
      bottomNavigationBar: BottomNavButton(
                text: AppString.save,
                onPressed: () {
                  navigateToPage(WaiverFormScreen());
                },
                bgColor: ColorConst.primaryColor,
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
                        child: CommonTextField(
                          title: AppString.fullName.endWithColon(),
                          textController: TextEditingController(
                            text: passenger['name'],
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
                              items: specialRequests,
                              currentValue: passenger['special'],
                              onTap: (selectedItem) {
                                setState(() {
                                  passenger['special'] = selectedItem!;
                                });
                              },
                            );
                          },
                          child: CommonTextField(
                            title: AppString.specialRequest,
                            textController: TextEditingController(
                              text: passenger['special'],
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
                            text: passenger['dietary'],
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      const SizedBox(width: 16),

                      Expanded(
                        child: CommonTextField(
                          title: AppString.medicalCondition.endWithColon(),
                          textController: TextEditingController(
                            text: passenger['medical'],
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
          },
        ),
      ),
    );
  }
}
