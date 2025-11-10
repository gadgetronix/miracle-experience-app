part of '../../wavier_list_screen.dart';

class TabletWaiverListView extends StatelessWidget {
  final List<ModelResponseWaiverListEntity> waivers;
  final WaiverListHelper helper;

  const TabletWaiverListView({
    super.key,
    required this.waivers,
    required this.helper,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WaiverFilterWidget(helper: helper),
        SizedBox(height: 10),
        _buildHeaderRow(),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: waivers.length,
            itemBuilder: (context, index) {
              final waiver = waivers[index];
              return _buildRow(waiver, index: index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      padding: const EdgeInsets.only(right: 10, left: 25, top: 12, bottom: 12),

      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(AppString.booking, style: tabletWaiverHeaderTextStyle),
          ),
          SizedBox(width: 5),

          Expanded(
            flex: 3,
            child: Text(
              AppString.pickupLocation,
              style: tabletWaiverHeaderTextStyle,
            ),
          ),
          SizedBox(width: 5),

          Expanded(
            flex: 2,
            child: Text(
              AppString.bookingBy,
              style: tabletWaiverHeaderTextStyle,
            ),
          ),
          SizedBox(width: 5),

          Expanded(
            flex: 1,
            child: Text(AppString.pax, style: tabletWaiverHeaderTextStyle),
          ),
          Expanded(
            flex: 2,
            child: Text(
              AppString.checkedIn,
              style: tabletWaiverHeaderTextStyle,
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            flex: 2,
            child: Text(AppString.action, style: tabletWaiverHeaderTextStyle),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(ModelResponseWaiverListEntity waiver, {required int index}) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(
            right: 10,
            left: 25,
            top: 12,
            bottom: 12,
          ),

          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: ColorConst.dividerColor,
                width: index != waivers.length - 1 ? 2 : 0,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      waiver.customerName ?? '-',
                      style: tabletWaiverInfoTextStyle,
                    ),
                    SizedBox(height: 5),
                    Text(
                      waiver.bookingCode ?? '-',
                      style: tabletWaiverInfoTextStyle,
                    ),
                  ],
                ),
              ),
          SizedBox(width: 5),

              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      waiver.pickupLocation ?? '-',
                      style: tabletWaiverInfoTextStyle,
                    ),
                    SizedBox(height: 5),
                    Text(waiver.area ?? '-', style: tabletWaiverInfoTextStyle),
                  ],
                ),
              ),
          SizedBox(width: 5),

              Expanded(
                flex: 2,
                child: Text(
                  waiver.bookingBy ?? '-',
                  style: tabletWaiverInfoTextStyle,
                ),
              ),
          SizedBox(width: 5),

              Expanded(
                flex: 1,
                child: Text(
                  waiver.pax.toString(),
                  style: tabletWaiverInfoTextStyle,
                ),
              ),
              Expanded(
                flex: 2,
                child: waiver.checkIn.isNullOrEmpty() ?  Align(
                  alignment: Alignment.centerLeft,
                  child: TabletWaiverListButton(
                            onTap: () {},
                            text: AppString.checkIn,
                            backgroundColor: ColorConst.blueColor,
                            textColor: ColorConst.whiteColor,
                          ),
                ): Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      waiver.checkIn ?? '-',
                      style: tabletWaiverInfoTextStyle,
                    ),
                    SizedBox(height: 8,),
                    TabletWaiverListButton(
                          onTap: () {},
                          text: AppString.viewCheckIn,
                          backgroundColor: ColorConst.whiteColor,
                          textColor: ColorConst.textColor,
                          showBorder: true,
                        ),
                  ],
                ),
              ),
              SizedBox(width: 5),

              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(waiver.isWaiverSigned == false)
                        _buildSignWaiverButton()

                      else
                      ...[
                        TabletWaiverListButton(
                          onTap: () {},
                          text: AppString.viewWaiver,
                          backgroundColor: ColorConst.whiteColor,
                          textColor: ColorConst.textColor,
                          showBorder: true,
                        ),
                        SizedBox(height: 8),
                        TabletWaiverListButton(
                          onTap: () {},
                          text: AppString.addPermit,
                          backgroundColor: ColorConst.blueColor,
                          textColor: ColorConst.whiteColor,
                        ),
                        SizedBox(height: 8),
                        TabletWaiverListButton(
                          onTap: () {},
                          text: AppString.specialRequest,
                          backgroundColor: ColorConst.greyColor,
                          textColor: ColorConst.textColor,
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          child: Container(
            width: 5,
            decoration: BoxDecoration(
              color: waiver.isWaiverSigned == false
                  ? ColorConst.primaryColor
                  : (waiver.isWaiverSigned == true &&
                        waiver.checkIn.isNotNullOrEmpty())
                  ? ColorConst.successColor
                  : ColorConst.blueColor,
              borderRadius: BorderRadius.only(
                topRight: index == 0
                    ? Radius.elliptical((5.0), (15.0))
                    : Radius.zero,
                bottomRight: index == waivers.length - 1
                    ? Radius.elliptical((5.0), (15.0))
                    : Radius.zero,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildSignWaiverButton(){
    return TabletWaiverListButton(
                        onTap: () {},
                        text: AppString.signWaiver,
                        backgroundColor: ColorConst.primaryColor,
                        textColor: ColorConst.whiteColor,
                      );
  }
}

class TabletWaiverListButton extends StatelessWidget {
  const TabletWaiverListButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.backgroundColor,
    required this.textColor, this.borderColor, this.showBorder = false,
  });

  final VoidCallback onTap;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final bool showBorder;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        constraints: BoxConstraints.tightForFinite(),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: showBorder
              ? Border.all(color: borderColor ?? ColorConst.dividerColor, width: 2)
              : null,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          text,
          style: tabletWaiverInfoTextStyle.copyWith(color: textColor),
        ),
      ),
    );
  }
}
