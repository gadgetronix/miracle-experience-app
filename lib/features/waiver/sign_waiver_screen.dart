import 'package:flutter/material.dart';
import 'package:miracle_experience_mobile_app/core/widgets/custom_rich_text_widget.dart';
import 'package:signature/signature.dart';

import '../../core/basic_features.dart';

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
  final String flightTitle = "Balloon Flight SERONERA";
  final Map<String, String> bookingDetails = {
    "Booking ID": "TPRL-090725",
    "Booking Name": "Ali test",
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
  final List<int> _flexFactors = const [1, 3, 2, 1, 1, 3];

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
        // Bold Header
        Text(flightTitle, style: fontStyleBold18),
        const SizedBox(height: 10),

        // Table using Column and Row for structure
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: ColorConst.dividerColor, width: 1.0),
          ),
          child: Column(
            children: bookingDetails.entries.map((entry) {
              final isLast = entry.key == bookingDetails.keys.last;
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Label Column (Brown/Orange Background)
                    Container(
                      color: ColorConst.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                      width: 150, // Fixed width for the label column to match the image style
                      alignment: Alignment.centerLeft,
                      child: Text(
                        entry.key.endWithColon(),
                        style: fontStyleBold16.copyWith(color: ColorConst.whiteColor),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Vertical Separator
                    Container(
                      width: 1.0,
                      color: ColorConst.dividerColor,
                    ),
                    // Value Column (White Background)
                    Expanded(
                      child: Container(
                        color: ColorConst.whiteColor,
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          entry.value,
                          style: fontStyleRegular16,
                        ),
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
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
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
                  flex: 1,
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
        title: 'Agreement',
        showLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. HEADER (Logo and Booking Details) ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo/Contact Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          ImageAsset.icLogoLandscape,
                          height: Dimensions.screenHeight() * 0.2,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Tel: +255 789 300 009 / +255 788 300 005",
                          style: fontStyleRegular12,
                        ),
                        Text(
                          "Email: balloon@miracleexperience.co.tz",
                          style: fontStyleRegular12,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Booking Details
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     _buildDetailRow("Booking ID", "TPRL-090725"),
                  //     _buildDetailRow("Booking Name", "ALI TEST"),
                  //     _buildDetailRow("Flight Date", "01 Dec 2025"),
                  //     _buildDetailRow(
                  //       "Pickup Location",
                  //       "AFRICAN SERENGETI SAFARI CAMP",
                  //     ),
                  //   ],
                  // ),
                  Expanded(
                    child: _buildBookingDetailsTable(),
                  ),
                ],
              ),

              Divider(height: 30, thickness: 1, color: Colors.grey.shade300),

              // --- 2. LEGAL DISCLOSURE (Waiver Text) ---
              Text(AppString.mainTitle, style: fontStyleBold18),
              const SizedBox(height: 10),
              // Placeholder for the extensive waiver text
              Text(AppString.part1, style: fontStyleRegular16),
              const SizedBox(height: 10),
              Text(AppString.indemnityClause, style: fontStyleBold18),
              const SizedBox(height: 5),
              Text(AppString.indemnityClauseDesc, style: fontStyleRegular16),
              const SizedBox(height: 10),
              Text(
                AppString.mediaConductSafetyPolicies,
                style: fontStyleBold18,
              ),
              const SizedBox(height: 5),
              CustomRichTextWidget.getDualText(
                firstText: AppString.complianceWithSafetyProtocols
                    .endWithColonSpace(),
                secondText: AppString.complianceWithSafetyProtocolsDesc,
                firstTextStyle: fontStyleBold16,
                secondTextStyle: fontStyleRegular16,
              ),
              const SizedBox(height: 5),
              CustomRichTextWidget.getDualText(
                firstText: AppString.digitalContentSocialMediaUse
                    .endWithColonSpace(),
                secondText: AppString.digitalContentSocialMediaUseDesc,
                firstTextStyle: fontStyleBold16,
                secondTextStyle: fontStyleRegular16,
              ),
              const SizedBox(height: 5),
              CustomRichTextWidget.getDualText(
                firstText: AppString.defamationMisuse.endWithColonSpace(),
                secondText: AppString.defamationMisuseDesc,
                firstTextStyle: fontStyleBold16,
                secondTextStyle: fontStyleRegular16,
              ),
              const SizedBox(height: 5),
              CustomRichTextWidget.getDualText(
                firstText: AppString.privacyOfOthers.endWithColonSpace(),
                secondText: AppString.privacyOfOthersDesc,
                firstTextStyle: fontStyleBold16,
                secondTextStyle: fontStyleRegular16,
              ),
              const SizedBox(height: 5),
              CustomRichTextWidget.getDualText(
                firstText: AppString.incidentDocumentationConfidentiality
                    .endWithColonSpace(),
                secondText: AppString.incidentDocumentationConfidentialityDesc,
                firstTextStyle: fontStyleBold16,
                secondTextStyle: fontStyleRegular16,
              ),
              const SizedBox(height: 10),
              Text(AppString.insurance, style: fontStyleBold18),
              const SizedBox(height: 5),
              Text(AppString.insuranceDesc, style: fontStyleRegular16),
              const SizedBox(height: 10),
              Text(AppString.cancellationPolicy, style: fontStyleBold18),
              const SizedBox(height: 5),
              CustomRichTextWidget.getDualText(
                firstText: AppString.noRefund.endWithColonSpace(),
                secondText: AppString.noRefundDesc,
                firstTextStyle: fontStyleBold16,
                secondTextStyle: fontStyleRegular16,
              ),
              const SizedBox(height: 5),
              CustomRichTextWidget.getDualText(
                firstText: AppString.fullRefundOrReschedule.endWithColonSpace(),
                secondText: AppString.fullRefundOrRescheduleDesc,
                firstTextStyle: fontStyleBold16,
                secondTextStyle: fontStyleRegular16,
              ),
              const SizedBox(height: 10),

              Text(AppString.additionalLegalClauses, style: fontStyleBold18),
              const SizedBox(height: 5),
              CustomRichTextWidget.getDualText(
                firstText: AppString.governingLawAndJurisdiction
                    .endWithColonSpace(),
                secondText: AppString.governingLawAndJurisdictionDesc,
                firstTextStyle: fontStyleBold16,
                secondTextStyle: fontStyleRegular16,
              ),
              const SizedBox(height: 5),
              CustomRichTextWidget.getDualText(
                firstText: AppString.severability.endWithColonSpace(),
                secondText: AppString.severabilityDesc,
                firstTextStyle: fontStyleBold16,
                secondTextStyle: fontStyleRegular16,
              ),
              const SizedBox(height: 5),
              CustomRichTextWidget.getDualText(
                firstText: AppString.provisionForMinors.endWithColonSpace(),
                secondText: AppString.provisionForMinorsDesc,
                firstTextStyle: fontStyleBold16,
                secondTextStyle: fontStyleRegular16,
              ),
              const SizedBox(height: 5),
              CustomRichTextWidget.getDualText(
                firstText: AppString.inherentRisksAndAcknowledgement
                    .endWithColonSpace(),
                secondText: AppString.inherentRisksAndAcknowledgementDesc,
                firstTextStyle: fontStyleBold16,
                secondTextStyle: fontStyleRegular16,
              ),
              const SizedBox(height: 10),

              Text(
                AppString.securityScreeningAndProhibitedItemsAcknowledgment,
                style: fontStyleBold18,
              ),
              const SizedBox(height: 5),
              Text(
                AppString.securityScreeningAndProhibitedItemsAcknowledgmentDesc,
                style: fontStyleRegular16,
              ),
              const SizedBox(height: 10),

              Text(AppString.prohibitedItems, style: fontStyleBold18),
              const SizedBox(height: 5),
              Text(AppString.prohibitedItemsDesc, style: fontStyleRegular16),
              const SizedBox(height: 10),

              Text(
                AppString.passengerConductAndDiscipline,
                style: fontStyleBold18,
              ),
              const SizedBox(height: 5),
              Text(
                AppString.passengerConductAndDisciplineDesc,
                style: fontStyleRegular16,
              ),
              const SizedBox(height: 10),

              Text(AppString.unrulyConduct, style: fontStyleBold18),
              const SizedBox(height: 5),
              Text(AppString.unrulyConductDesc, style: fontStyleRegular16),
              const SizedBox(height: 20),

              // --- 3. GUEST SELECTION TABLE ---
              Text(AppString.selectGuest, style: fontStyleBold18),
              const SizedBox(height: 10),

              _buildGuestListTable(),

              const SizedBox(height: 10),
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
              const SizedBox(height: 5),
              CustomRichTextWidget.getDualText(
                firstText: AppString.electronicSignatureConsentDesc,
                secondText: AppString.beforeTheFlight,
                firstTextStyle: fontStyleRegular16,
                secondTextStyle: fontStyleBold16,
              ),
              const SizedBox(height: 10),
              Text(AppString.ensureEmailAddress, style: fontStyleRegular16),

              const SizedBox(height: 30),

              // --- 5. SOCIAL MEDIA CONSENT (Radio Buttons) ---
              Text(AppString.allowPhotosOnSocialMedia, style: fontStyleBold16),
              _buildRadioOption(AppString.yesIAgree, true),
              _buildRadioOption(AppString.noIdontAgree, false),

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
                style: fontStyleSemiBold14,
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
                child: RoundedRectangleButton.textButton(
                  text: AppString.clear,
                  onPressed: () {
                    controller.clear();
                  },
                  miniWidth: 0,
                  btnBgColor: ColorConst.primaryColor,
                  textStyle: fontStyleSemiBold18.apply(
                    color: ColorConst.whiteColor,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // --- 7. FOOTER AND SUBMIT BUTTON ---
              Text(
                AppString.thankYouForChoosingMiracleExperience,
                style: fontStyleBold16,
              ),
              const SizedBox(height: 5),
              Text(
                AppString.thankYouForChoosingMiracleExperienceDesc,
                style: fontStyleRegular16,
              ),
              const SizedBox(height: 20),
              RoundedRectangleButton.textButton(
                text: AppString.submit,
                onPressed: () {},
                btnBgColor: ColorConst.primaryColor,
                textStyle: fontStyleSemiBold18.apply(
                  color: ColorConst.whiteColor,
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
