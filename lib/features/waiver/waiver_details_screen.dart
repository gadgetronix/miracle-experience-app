import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miracle_experience_mobile_app/features/waiver/wavier_list_screen.dart';

import '../../core/basic_features.dart';
part 'widgets/tablet_view/tablet_waiver_detail_item.dart';
part 'widgets/mobile_view/mobile_waiver_detail_item.dart';

class WaiverDetailsScreen extends StatefulWidget {
  const WaiverDetailsScreen({super.key});

  @override
  State<WaiverDetailsScreen> createState() => _WaiverDetailsScreenState();
}

class _WaiverDetailsScreenState extends State<WaiverDetailsScreen> {
  final List<Map<String, dynamic>> passengers = [
    {
      'firstName': 'Liam',
      'lastName': 'Harper',
      'gender': 'Male',
      'age': 32,
      'weight': '185',
      'weightType': 'lbs',
      'country': 'Canada',
      'special': 'None',
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
    'None',
    'Birthday',
    'Anniversary',
    'Honeymoon',
    'Engagement',
    'Graduation',
  ];

  final List<String> gender = ['Male', 'Female', 'Other'];

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
      bottomNavigationBar: BottomNavButton(
        text: AppString.save,
        onPressed: () {
          navigateToPage(WaiverFormScreen());
        },
        bgColor: ColorConst.primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: Const.isTablet ? 25 : 16),
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
                  return Const.isTablet ? TabletWaiverDetailItem(
                    passenger: passenger,
                    gender: gender,
                    weightType: weightType,
                    country: country,
                    specialRequests: specialRequests,
                  ) : MobileWaiverDetailItem(
                    passenger: passenger,
                    gender: gender,
                    weightType: weightType,
                    country: country,
                    specialRequests: specialRequests,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
