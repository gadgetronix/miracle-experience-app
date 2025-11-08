import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../basic_features.dart';

import '../utils/date_formats.dart';


Future<DateTime?> openMaterialCalender(BuildContext context,
    {DateTime? initialDate, DateTime? lastDate, DateTime? firstDate}) async {
  return await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2010, 1),
      lastDate: lastDate ?? DateTime(3000),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme:
                  const ColorScheme.light(primary: ColorConst.primaryColor),
            ),
            child: child!);
      },
      initialDatePickerMode: DatePickerMode.day);
}

Future<DateTime?> openCupertinoCalender(
    {required DateTime initialDate,
    DateTime? minDate,
    DateTime? maxDate,
    required Function onSelect}) {
  FocusScope.of(GlobalVariable.appContext).requestFocus(FocusNode());
  DateTime selectDate = initialDate;

  return showModalBottomSheet(
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: ColorConst.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10))),
      context: (GlobalVariable.appContext),
      enableDrag: true,
      isDismissible: true,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              color: ColorConst.transparent,
              alignment: Alignment.center,
              child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(
                    backgroundColor:
                        ColorConst.whiteColor,
                    radius: 22,
                    child: Icon(
                      Icons.close_rounded,
                      color: ColorConst.blackColor,
                    ),
                  )),
            ),
            Container(
              decoration: BoxDecoration(
                  color: ColorConst.whiteColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Column(
                children: [
                  // SizedBox(
                  //   height: Dimensions.h35,
                  // ),
                  // Text(
                  //   "AppString.selectPickupDate",
                  //   // style: fontStyleBold18,
                  // ),
                  Container(
                    padding: EdgeInsets.all(16),
                    height: 216,
                    child: CupertinoTheme(
                      data: CupertinoThemeData(
                        textTheme: CupertinoTextThemeData(
                            dateTimePickerTextStyle: fontStyleMedium16),
                      ),
                      child: CupertinoDatePicker(
                        onDateTimeChanged: (v) {
                          selectDate = v;
                        },
                        minimumDate: minDate,
                        maximumDate: maxDate,
                        initialDateTime: initialDate,
                        mode: CupertinoDatePickerMode.date,
                      ),
                    ),
                  ),
                  BottomNavButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onSelect(selectDate);
                      },
                      text: AppString.done)
                ],
              ),
            ),
          ],
        );
      });
}

Future<DateTime?> openCalendar(
  {
    required BuildContext context, 
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  String? outputDateFormat,
}) async {
  initialDate ??= DateTime.now();
  firstDate ??= DateTime(1900, 1);
  lastDate ??= DateTime(3000);
  if (Platform.isAndroid) {
    FocusScope.of(context).requestFocus(FocusNode());
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                colorScheme:
                    const ColorScheme.light(primary: ColorConst.primaryColor),
              ),
              child: child!);
        },
        initialDatePickerMode: DatePickerMode.day);


      return date;
  } else {
    DateTime? selectedDateTime;
    await openCupertinoCalender(
        initialDate: initialDate,
        onSelect: (DateTime selectedDate) {
          selectedDateTime = selectedDate;
        },
        maxDate: lastDate);
    if (selectedDateTime != null) {
      return selectedDateTime;
    }
  }
  return null;
}

Widget _buildBottomPicker(Widget picker) {
  return Container(
    height: 216.0,
    padding: const EdgeInsets.only(top: 6.0),
    color: CupertinoColors.white,
    child: GestureDetector(
      // Blocks taps from propagating to the modal sheet and popping.
      onTap: () {},
      child: SafeArea(
        top: false,
        child: picker,
      ),
    ),
  );
}

Future<String?> openDateAndTimePicker(BuildContext context) async {
  var selectedDateAndTime = '';
  await showCupertinoModalPopup<DateTime>(
    context: context,
    builder: (BuildContext context) {
      return _buildBottomPicker(
        CupertinoDatePicker(
          mode: CupertinoDatePickerMode.dateAndTime,
          initialDateTime: DateTime.now(),
          onDateTimeChanged: (DateTime newDateTime) {
            selectedDateAndTime = newDateTime.toString();
          },
        ),
      );
    },
  );
  return changeDateFormat(
          selectedDateAndTime.toString(),
          AppDateFormats.dateFormatToday,
          "${AppDateFormats.dateFormatDDMMYYY} - ${AppDateFormats.dateFormatHHMMA}")
      .toLowerCase();
}

Future<String?> openTimePicker(BuildContext context) async {
  var selectedDateAndTime = '';
  await showCupertinoModalPopup<DateTime>(
    context: context,
    builder: (BuildContext context) {
      return _buildBottomPicker(
        //  AlertDialog(
        //  alignment: Alignment.center,
        //  backgroundColor: Colors.white,
        //  contentPadding: EdgeInsets.zero,
        // content: Container(
        //   height: Dimensions.h220,
        //   width: Dimensions.w200,
        // decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(Dimensions.h13))),
        CupertinoDatePicker(
          mode: CupertinoDatePickerMode.time,
          initialDateTime: DateTime.now(),
          onDateTimeChanged: (DateTime newDateTime) {
            selectedDateAndTime = newDateTime.toString();
          },
        ),
      );
    },
  );
  return changeDateFormat(selectedDateAndTime.toString(),
          AppDateFormats.dateFormatToday, AppDateFormats.dateFormatHHMM)
      .toLowerCase();
}

// Future<void> openTimePickerBottomSheet(BuildContext context) async {
//   var selectedDateAndTime = '';
//   await CustomBottomSheet.instance.modalBottomSheet(
//       bottomButtonName: AppString.save,
//       bottomButtonColor: ColorConst.primaryColor,
//       context: context,
//       child: CupertinoDatePicker(
//         mode: CupertinoDatePickerMode.time,
//         initialDateTime: DateTime.now(),
//         onDateTimeChanged: (DateTime newDateTime) {
//           selectedDateAndTime = newDateTime.toString();
//         },
//       ),
//       onBottomPressed: () {
//         changeDateFormat(selectedDateAndTime.toString(),
//                 AppDateFormats.dateFormatToday, AppDateFormats.dateFormatHHMM)
//             .toLowerCase();
//       },
//       onCancelPressed: () {
//         Navigator.pop(context);
//       });
// }
