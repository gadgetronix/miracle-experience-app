part of 'wavier_list_screen.dart';

class SignWaiverScreen extends StatefulWidget {
  const SignWaiverScreen({super.key});

  @override
  State<SignWaiverScreen> createState() => _SignWaiverScreenState();
}

class _SignWaiverScreenState extends State<SignWaiverScreen> {
  final List<Map<String, dynamic>> passengers = [
    {
      'firstName': 'Liam',
      'lastName': 'Harper',
      'gender': 'Male',
      'age': 32,
      'weight': '185',
      'weightType': 'lbs',
      'country': 'Canada',
      'special': 'Special Request',
      'dietary': 'Low-carb, no dairy',
    },
    {
      'firstName': 'Sofia',
      'lastName': 'Chen',
      'gender': 'Female',
      'age': 25,
      'weight': '135',
      'weightType': 'lbs',
      'country': 'Singapore',
      'special': 'Birthday',
      'dietary': 'Vegetarian',
    },
    {
      'firstName': 'Aarav',
      'lastName': 'Singh',
      'gender': 'Male',
      'age': 45,
      'weight': '205',
      'weightType': 'KG',
      'country': 'India',
      'special': 'Anniversary',
      'dietary': 'High-protein, no nuts',
    },
    {
      'firstName': 'Chloe',
      'lastName': 'Dubois',
      'gender': 'Female',
      'age': 19,
      'weight': '115',
      'weightType': 'KG',
      'country': 'France',
      'special': 'Graduation',
      'dietary': 'Vegan, Gluten-free',
    },
    {
      'firstName': 'Javier',
      'lastName': 'Gomez',
      'gender': 'Male',
      'age': 58,
      'weight': '160',
      'weightType': 'lbs',
      'country': 'Spain',
      'special': 'Honeymoon',
      'dietary': 'Diabetic-friendly, Low-sodium',
    },
  ];

  final List<String> specialRequests = [
    'Special Request',
    'Birthday',
    'Anniversary',
    'Honeymoon',
    'Engagement',
    'Graduation',
  ];

  final List<String> gender = ['Male', 'Female', 'Others'];

  final List<String> weightType = ['KG', 'lbs'];

  final List<String> country = [
    'United States',
    'Canada',
    'United Kingdom',
    'India',
    'France',
    'Spain',
    'Germany',
    'Australia',
    'Italy',
    'Brazil',
    'Singapore',
    'Japan',
    'China',
    'Mexico',
    'South Africa',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.backActionCenterTitleAppBar(
        title: "Kiki Fam Trip x 5 - SJKD-040725",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: passengers.length,
                separatorBuilder: (context, index) => Divider(
                  height: 30,
                  thickness: 0.5,
                  color: Colors.grey.shade300,
                ),
                itemBuilder: (context, index) {
                  final passenger = passengers[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // First Name
                            Expanded(
                              child: CommonTextField(
                                title: AppString.firstName.endWithColon(),
                                textController: TextEditingController(
                                  text: passenger['firstName'],
                                ),
                                keyBoardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                hintText: AppString.firstName,
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Last Name
                            Expanded(
                              child: CommonTextField(
                                title: AppString.lastName.endWithColon(),
                                textController: TextEditingController(
                                  text: passenger['lastName'],
                                ),
                                keyBoardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                hintText: AppString.lastName,
                              ),
                            ),
                            const SizedBox(width: 16),

                            //Gender
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  FocusManager.instance.primaryFocus?.unfocus();

                                  ListBottomSheet.buildSheet(
                                    context: context,
                                    title: AppString.gender,
                                    items: gender,
                                    currentValue: passenger['gender'],
                                    onTap: (String selectedItem) {
                                      setState(() {
                                        passenger['gender'] = selectedItem;
                                      });
                                    },
                                  );
                                },
                                child: CommonTextField(
                                  title: '',
                                  textController: TextEditingController(
                                    text: passenger['gender'],
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
                            ),
                            SizedBox(width: 16),

                            // Age
                            Expanded(
                              child: CommonTextField(
                                title: AppString.age.endWithColon(),
                                textController: TextEditingController(
                                  text: passenger['age'].toString(),
                                ),
                                keyBoardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                hintText: AppString.age,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            //weight
                            Expanded(
                              flex: 1,
                              child: CommonTextField(
                                title: AppString.weight.endWithColon(),
                                hintText: AppString.weight,
                                keyBoardType: TextInputType.number,
                                textController: TextEditingController(
                                  text: passenger['weight'],
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d{0,2}'),
                                  ),
                                ],
                                textInputAction: TextInputAction.done,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                              ),
                            ),

                            SizedBox(width: 3.0),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () async {
                                  FocusManager.instance.primaryFocus?.unfocus();

                                  ListBottomSheet.buildSheet(
                                    context: context,
                                    title: AppString.weight,
                                    items: weightType,
                                    currentValue: passenger['weightType'],
                                    onTap: (String selectedItem) {
                                      setState(() {
                                        passenger['weightType'] = selectedItem;
                                      });
                                    },
                                  );
                                },
                                child: CommonTextField(
                                  title: '',
                                  textController: TextEditingController(
                                    text: passenger['weightType'],
                                  ),
                                  readOnly: true,
                                  textStyle: fontStyleMedium16,
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
                            ),

                            const SizedBox(width: 16),

                            //country
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () async {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  ListBottomSheet.buildSheet(
                                    context: context,
                                    title: AppString.country,
                                    items: country,
                                    currentValue: passenger['country'],
                                    onTap: (String selectedItem) {
                                      setState(() {
                                        passenger['country'] = selectedItem;
                                      });
                                    },
                                  );
                                },
                                child: CommonTextField(
                                  title: '',
                                  textController: TextEditingController(
                                    text: passenger['country'],
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
                            ),

                            const SizedBox(width: 16),
                            // Special Request
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () async {
                                  FocusManager.instance.primaryFocus?.unfocus();

                                  ListBottomSheet.buildSheet(
                                    context: context,
                                    title: AppString.specialRequest,
                                    items: specialRequests,
                                    currentValue: passenger['special'],
                                    onTap: (String selectedItem) {
                                      setState(() {
                                        passenger['special'] = selectedItem;
                                      });
                                    },
                                  );
                                },
                                child: CommonTextField(
                                  title: '',
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
                            ),
                            const SizedBox(width: 16),
                            // Dietary Restriction
                            Expanded(
                              flex: 4,
                              child: CommonTextField(
                                title: AppString.dietaryRestriction
                                    .endWithColon(),
                                hintText: AppString.ifNothingLeaveBlank,
                                keyBoardType: TextInputType.text,
                                textController: TextEditingController(
                                  text: passenger['dietary'],
                                ),
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

              Padding(
                padding: const EdgeInsets.all(25),
                child: RoundedRectangleButton.textButton(
                  text: AppString.save,
                  onPressed: () {},
                  btnBgColor: ColorConst.primaryColor,
                  textStyle: fontStyleSemiBold18.apply(
                    color: ColorConst.whiteColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
