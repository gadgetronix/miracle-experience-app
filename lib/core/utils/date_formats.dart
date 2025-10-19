import '../basic_features.dart';
import 'package:intl/intl.dart';

import 'extension.dart';

class AppDateFormats {
  static const String dateFormatServer = "yyyy-MM-DDTHH:mm:ss.SSSSSSZ";
  static const String dateFormatToday = "yyyy-MM-DD HH:mm:ss.SSSSSS";
  static const String dateFormatYYYYMMSSHHMMSS = "yyyy-MM-dd HH:mm:ss";
  static const String dateFormatDDMMMMEEEE = "dd MMMM, EEEE";

  static const String dateFormatDDMMYYY = "dd/MM/yyyy";
  static const String dateFormatDDMMYYYHHMMA = "dd/MM/yyyy hh:mma";
  static const String dateFormatMDYYY = "M/dd/yyyy";
  static const String dateFormatDDMMYYYYDes = "dd-MM-yyyy";
  static const String dateFormatDDMYYYY = "dd/M/yyyy";
  static const String dateFormatYYYYMDD = "yyyy-MM-dd";
  static const String dateFormatMMMMYYYY = "MMMM yyyy";
  static const String dateFormatMMYYYY = "MM/yyyy";
  static const String dateFormatDDMMM = "dd MMM";
  static const String dateFormatMMMY = "MMM y";
  static const String dateFormatMMMMY = "MMMM y";
  static const String dateFormatDD = "dd";
  static const String dateFormatMMM = "MMM";
  static const String dateFormatHHMMA = "hh:mma";
  static const String dateFormatAMPM = "hh:mm a";
  static const String dateFormatHHMMSS = "HH:mm:ss";
  static const String dateFormatHHMM = "HH:mm";
  static const String dateFormatEE = "EE";
  static const dateFormatWithDay = "dd MMM, yyyy";
  static const dateFormatWithDayName = "dd MMM, EEEE";
}

// String dateToAgoFormat(String dateTime, String inputFormat) {
//   DateTime tempDate = DateTime.now();
//   if (dateTime.isNotEmpty) {
//     tempDate = DateFormat(inputFormat).parse(dateTime);
//   }
//   return timeago.format(tempDate);
// }

String formatDate(DateTime inputDate, String outputFormat) {
  return DateFormat(outputFormat).format(inputDate);
}

String getCurrentDate() {
  return DateFormat(AppDateFormats.dateFormatDDMMYYY).format(DateTime.now());
}


String convertToUTC(String? dateTime) {
  return changeDateFormat(DateTime.parse("$dateTime").toLocal().toString(),
      AppDateFormats.dateFormatToday, AppDateFormats.dateFormatHHMMA);
}

String changeDateFormat(
    String? dateTime, String inputFormat, String outputFormat) {
  DateTime inputDate = DateTime.now();
  if (dateTime.isNotNullOrEmpty()) {
    inputDate = DateFormat(inputFormat).parse(dateTime!);
  }
  return DateFormat(outputFormat).format(inputDate);
}

bool dateCompare(val, val2) {
  var utc = changeDateFormat(
    val,
    AppDateFormats.dateFormatServer,
    AppDateFormats.dateFormatDDMMYYY,
  );
  var utc2 = changeDateFormat(
    val2,
    AppDateFormats.dateFormatServer,
    AppDateFormats.dateFormatDDMMYYY,
  );
  return utc != utc2;
}

bool showTimer(val) {
  return DateTime.now()
          .compareTo(DateFormat(AppDateFormats.dateFormatDDMMYYY).parse(val)) ==
      -1;
}

bool checkCurrentDate(val) {
  return DateTime.now()
          .compareTo(DateFormat(AppDateFormats.dateFormatDDMMYYY).parse(val)) >
      0;
}

String hhMM(val) {
  if (val != null) {
    var inputFormat = DateFormat(AppDateFormats.dateFormatHHMMSS);
    var invoiceDates = inputFormat.parse(val);
    var outputFormat = DateFormat(AppDateFormats.dateFormatHHMMA);
    return outputFormat.format(invoiceDates);
  }
  return "";
}

/// Returns the suffix for the given number, such as 'st' for 1 or 'th' for 11.
String getSuffix(int number) {
  if (number % 100 >= 11 && number % 100 <= 13) {
    return 'th';
  } else {
    switch (number % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
