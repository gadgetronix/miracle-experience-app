import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/basic_features.dart';
import '../../core/widgets/common_date_picker.dart';
import '../network_helper/models/response_model/model_response_waiver_list_entity.dart';
import 'sign_waiver_screen.dart';

part 'waiver_list_helper.dart';
part 'widgets/mobile_view/mobile_waiver_list_view.dart';
part 'widgets/tablet_view/tablet_waiver_list_view.dart';
part 'widgets/waiver_list_app_bar.dart';
part 'widgets/list_bottom_sheet.dart';
part 'waiver_details_screen.dart';
part 'special_request_screen.dart';

class WaiverListScreen extends StatefulWidget {
  const WaiverListScreen({super.key});

  @override
  State<WaiverListScreen> createState() => _WaiverListScreenState();
}

class _WaiverListScreenState extends State<WaiverListScreen> {
  late final WaiverListHelper helper;

  @override
  void initState() {
    super.initState();
    helper = WaiverListHelper();
    helper.loadWaiverList();
  }

  @override
  void dispose() {
    helper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WaiverListAppBar(
    onSearchChanged: (query) {
      // Filter your waiver list or trigger helper method
      print("Searching for $query");
    },
  ),
      body: RefreshIndicator(
        onRefresh: helper.loadWaiverList,
        child: 
        Const.isTablet ?  TabletWaiverListView(waivers: helper.waiverList.value, helper: helper)
        : MobileWaiverListView(waivers: helper.waiverList.value, helper: helper)
               
      ),
    );
  }
}
