part of '../wavier_list_screen.dart';

class SignWaiverFormContent extends StatelessWidget {
  const SignWaiverFormContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppString.mainTitle, style: fontStyleBold18),
                  const SizedBox(height: 15),
                  // Placeholder for the extensive waiver text
                  Text(AppString.part1, style: fontStyleRegular16),
                  const SizedBox(height: 20),
                  Text(AppString.indemnityClause, style: fontStyleBold18),
                  const SizedBox(height: 15),
                  Text(AppString.indemnityClauseDesc, style: fontStyleRegular16),
                  const SizedBox(height: 20),
                  Text(
                    AppString.mediaConductSafetyPolicies,
                    style: fontStyleBold18,
                  ),
                  const SizedBox(height: 15),
                  BulletText(text: AppString.complianceWithSafetyProtocols),
                  const SizedBox(height: 15),
                  BulletText(text: AppString.digitalContentSocialMediaUse),
                  const SizedBox(height: 15),
                  BulletText(text: AppString.defamationMisuse),
                  const SizedBox(height: 15),
                  BulletText(text: AppString.privacyOfOthers),
                  const SizedBox(height: 15),
                  BulletText(text: AppString.incidentDocumentationConfidentiality),
                  const SizedBox(height: 20),
                  Text(AppString.insurance, style: fontStyleBold18),
                  const SizedBox(height: 15),
                  Text(AppString.insuranceDesc, style: fontStyleRegular16),
                  const SizedBox(height: 15),
                  BulletText(text: AppString.insurancePoint1),
                  const SizedBox(height: 15),
                  BulletText(text: AppString.insurancePoint2),
                  const SizedBox(height: 15),
                  BulletText(text: AppString.insurancePoint3),
                  const SizedBox(height: 15),
                  Text(AppString.bySigningInsurance, style: fontStyleRegular16),
                  const SizedBox(height: 20),
                  Text(AppString.cancellationPolicy, style: fontStyleBold18),
                  const SizedBox(height: 15),
                  BulletText(text: AppString.noRefund),
                  const SizedBox(height: 15),
                  BulletText(text: AppString.fullRefundOrReschedule),
                  const SizedBox(height: 20),
                  Text(AppString.additionalLegalClauses, style: fontStyleBold18),
                  const SizedBox(height: 15),
                  BulletText(text: AppString.governingLawAndJurisdiction),
                  const SizedBox(height: 15),
                  BulletText(text: AppString.severability),
                  const SizedBox(height: 15),
                  BulletText(text: AppString.provisionForMinors),
                  const SizedBox(height: 15),
                  BulletText(text: AppString.inherentRisksAndAcknowledgement),
                  const SizedBox(height: 20),
            
                  Text(
                    AppString.securityScreeningAndProhibitedItemsAcknowledgment,
                    style: fontStyleBold18,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    AppString.securityScreeningAndProhibitedItemsAcknowledgmentDesc,
                    style: fontStyleRegular16,
                  ),
                  const SizedBox(height: 20),
            
                  Text(AppString.prohibitedItems, style: fontStyleBold18),
                  const SizedBox(height: 15),
                  Text(AppString.prohibitedItemsDesc, style: fontStyleRegular16),
                  const SizedBox(height: 15),
                  BulletText(text: AppString.weapons),
                  const SizedBox(height: 15),
                  BulletText(text: AppString.explosivesFlammables),
                  const SizedBox(height: 15),
                  BulletText(text: AppString.impairingSubstances),
                  const SizedBox(height: 15),
                  BulletText(text: AppString.obstructiveItems),
                  const SizedBox(height: 15),
                  Text(AppString.prohibitedItemsDesc2, style: fontStyleRegular16),
                  const SizedBox(height: 20),
                  Text(
                    AppString.passengerConductAndDiscipline,
                    style: fontStyleBold18,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    AppString.passengerConductAndDisciplineDesc,
                    style: fontStyleRegular16,
                  ),
                  const SizedBox(height: 15),
                  BulletText(text: AppString.passengerConductAndDiscipline1),
                  const SizedBox(height: 15),
                  BulletText(text: AppString.passengerConductAndDiscipline2),
                  const SizedBox(height: 15),
                  BulletText(text: AppString.passengerConductAndDiscipline3),
                  const SizedBox(height: 20),
            
                  Text(AppString.unrulyConduct, style: fontStyleBold18),
                  const SizedBox(height: 15),
                  Text(AppString.unrulyConductDesc, style: fontStyleRegular16),
                  const SizedBox(height: 20),
            
                  // --- 3. GUEST SELECTION TABLE ---
                  Text(AppString.selectGuest, style: fontStyleBold18),
                  const SizedBox(height: 15),
      ],
    );
  }
}