part of 'wavier_list_screen.dart';

class SpecialRequestScreen extends StatefulWidget {
  const SpecialRequestScreen({super.key, required this.waiverListHelper});
  final WaiverListHelper waiverListHelper;

  @override
  State<SpecialRequestScreen> createState() => _SpecialRequestScreenState();
}

class _SpecialRequestScreenState extends State<SpecialRequestScreen> {
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
        child: ListView.separated(
          itemCount: widget.waiverListHelper.passengers.length,
          separatorBuilder: (context, index) =>
              Divider(height: 30, thickness: 0.5, color: Colors.grey.shade300),
          itemBuilder: (context, index) {
            final passenger = widget.waiverListHelper.passengers[index];
            return Const.isTablet
                ? TabletSpecialRequestItem(
                    passenger: passenger,
                    waiverListHelper: widget.waiverListHelper,
                  )
                : MobileSpecialRequestItem(
                    passenger: passenger,
                    waiverListHelper: widget.waiverListHelper,
                  );
          },
        ),
      ),
    );
  }
}
