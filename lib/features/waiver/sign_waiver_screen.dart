part of 'wavier_list_screen.dart';

class WaiverFormScreen extends StatefulWidget {
  const WaiverFormScreen({super.key});

  @override
  State<WaiverFormScreen> createState() => _WaiverFormScreenState();
}

class _WaiverFormScreenState extends State<WaiverFormScreen> {
  // State variables for the interactive elements
  bool electronicConsent = false;
  bool socialMediaConsent = true; // True = Yes, I agree
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final SignatureController controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  final Map<String, String> bookingDetails = {
    "Booking Id": "TPRL-090725",
    "Booking Name": "Ali test (TPRL-090725)",
    "Pickup Location": "AFRICAN KONGONI SERENGETI SAFARI CAMP",
    "Flight Date": "01 Dec 2025",
  };

  // Mock Guest Data (as seen in the video)
  List<Map<String, dynamic>> passengers = [
    {
      '#': 3,
      'Name': 'Jafar Sunni',
      'Gender': 'Male',
      'Age': 30,
      'Weight': '79 kg',
      'Country': 'Spain',
      'selected': true,
    },
  ];
  final List<int> _flexFactors = const [1, 3, 2, 1, 2, 3];

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Widget _buildBookingDetailsTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Table using Column and Row for structure
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: ColorConst.dividerColor, width: 1.0),
          ),
          child: Column(
            children: bookingDetails.entries.map((entry) {
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Label Column (Brown/Orange Background)
                    Container(
                      color: ColorConst.dividerColor,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 12.0,
                      ),
                      width:
                          150, // Fixed width for the label column to match the image style
                      alignment: Alignment.centerLeft,
                      child: Text(
                        entry.key.endWithColon(),
                        style: fontStyleBold16.copyWith(
                          color: ColorConst.textColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Vertical Separator
                    Container(width: 1.0, color: ColorConst.dividerColor),
                    // Value Column (White Background)
                    Expanded(
                      child: Container(
                        color: ColorConst.whiteColor,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 12.0,
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(entry.value, style: fontStyleRegular16),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // Helper function to build the Social Media radio options
  Widget _buildRadioOption(String label, bool value) {
    return InkWell(
      onTap: () {
        setState(() {
          socialMediaConsent = value;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          children: [
            Radio<bool>(
              value: value,
              groupValue: socialMediaConsent,
              onChanged: (val) {
                setState(() {
                  socialMediaConsent = val!;
                });
              },
              activeColor: ColorConst.primaryColor,
            ),
            Text(label, style: fontStyleRegular16),
          ],
        ),
      ),
    );
  }

  // Helper function to build the Guest List Table/Grid
  Widget _buildGuestListTable() {
    const List<String> headers = [
      '#',
      AppString.fullName,
      AppString.gender,
      AppString.age,
      AppString.weight,
      AppString.country,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Table Header Row
        Container(
          color: ColorConst.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Row(
            children: [
              const SizedBox(width: 50), // Checkbox spacing
              ...headers.map(
                (header) => Expanded(
                  flex: _flexFactors[headers.indexOf(header)],
                  child: Text(
                    header,
                    style: fontStyleBold14.apply(color: ColorConst.whiteColor),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Table Data Row(s)
        ...passengers.map((passenger) {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: ColorConst.dividerColor),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Row(
              children: [
                // Checkbox column
                SizedBox(
                  width: 50,
                  child: Checkbox(
                    value: passenger['selected'],
                    onChanged: (val) {
                      setState(() {
                        passenger['selected'] = val;
                      });
                    },
                    activeColor: ColorConst.primaryColor,
                  ),
                ),
                // Data columns
                Expanded(
                  flex: 1,
                  child: Text(
                    passenger['#'].toString(),
                    style: fontStyleRegular16,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    passenger['Name'].toString(),
                    style: fontStyleRegular16,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    passenger['Gender'].toString(),
                    style: fontStyleRegular16,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    passenger['Age'].toString(),
                    style: fontStyleRegular16,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    passenger['Weight'].toString(),
                    style: fontStyleRegular16,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    passenger['Country'].toString(),
                    style: fontStyleRegular16,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.backActionCenterTitleAppBar(
        title: AppString.balloonSafariWaiver,
        showLeading: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(Const.isTablet ? 25 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Const.isTablet ?
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo/Contact Info
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Image.asset(
                            ImageAsset.icSplash,
                            height: Dimensions.screenHeight() * 0.17,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(flex: 3, child: _buildBookingDetailsTable()),
                    ],
                  ) :

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: AlignmentGeometry.center,
                        child: Image.asset(
                                  ImageAsset.icLogoLandscape,
                                  height: Dimensions.screenHeight() * 0.17,
                                ),
                      ),
                          const SizedBox(height: 20),
                      _buildBookingDetailsTable(),
                    ],
                  ),
            
                  SizedBox(height: 30),
                  SignWaiverFormContent(),
            
                  _buildGuestListTable(),
            
                  const SizedBox(height: 15),
                  Text(AppString.bySigningOnBehalfDesc, style: fontStyleRegular16),
                  const SizedBox(height: 20),
            
                  // --- 4. ELECTRONIC SIGNATURE CONSENT ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: electronicConsent,
                        onChanged: (val) {
                          setState(() {
                            electronicConsent = val ?? false;
                          });
                        },
                        activeColor: ColorConst.primaryColor,
                      ),
                      Text(
                        AppString.electronicSignatureConsent,
                        style: fontStyleBold16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    AppString.electronicSignatureConsentDesc,
                    style: fontStyleRegular16,
                  ),
                  const SizedBox(height: 15),
                  Text(AppString.ensureEmailAddress, style: fontStyleRegular16),
            
                  const SizedBox(height: 30),
            
                  // --- 5. SOCIAL MEDIA CONSENT (Radio Buttons) ---
                  Text(AppString.allowPhotosOnSocialMedia, style: fontStyleBold16),
                  Row(
                    children: [
                      _buildRadioOption(AppString.yesIAgree, true),
                      SizedBox(width: 10,),
                      _buildRadioOption(AppString.noIdontAgree, false),
                    ],
                  ),
            
                  const SizedBox(height: 20),
            
                  // --- 6. SIGNATURE BLOCK ---
                  CommonTextField(
                    textController: nameController,
                    hintText: AppString.enterFullName,
                    title: AppString.name.endWithColon(),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
            
                  CommonTextField(
                    textController: emailController,
                    hintText: AppString.enterEmail,
                    keyBoardType: TextInputType.emailAddress,
                    title: AppString.emailAddressToRecieveWaiver.endWithColon(),
                  ),
                  const SizedBox(height: 16),
            
                  Text(
                    AppString.pleaseSignBelow.endWithColon(),
                    style: fontStyleMedium14,
                  ),
                  SizedBox(height: 6),
                  // Signature Pad Placeholder
                  Signature(
                    controller: controller,
                    height: 300,
                    backgroundColor: ColorConst.dividerColor,
                  ),
                  SizedBox(height: 16),
                  // Clear button alignment
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => controller.clear(),
                      child: Text(
                        AppString.clear,
                        style: fontStyleSemiBold18.apply(
                          color: ColorConst.primaryColor,
                        ),
                      ),
                    ),
                  ),
            
                  const SizedBox(height: 30),
            
                  // --- 7. FOOTER AND SUBMIT BUTTON ---
                  Text(
                    AppString.thankYouForChoosingMiracleExperience,
                    style: fontStyleBold16,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    AppString.thankYouForChoosingMiracleExperienceDesc,
                    style: fontStyleRegular16,
                  ),
                  const SizedBox(height: 20),
                  
                ],
              ),
            ),
            BottomNavButton(
                text: AppString.submit,
                onPressed: () {},
                bgColor: ColorConst.primaryColor,
                textStyle: fontStyleBold14.apply(
                  color: ColorConst.whiteColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
