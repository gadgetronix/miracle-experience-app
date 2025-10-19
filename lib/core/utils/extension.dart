import 'dart:io';

import 'package:intl/intl.dart';

import 'date_formats.dart';

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}

extension FileExtention on FileSystemEntity {
  String get name {
    return path.split("/").last;
  }
}

extension BoolExtention on bool? {
  int toConvertInt() {
    if (this == null) return 0;
    return this == true ? 1 : 0;
  }
}

extension IntExtention on int? {
  bool toBool() {
    if (this == null) return false;
    return this == 1 ? true : false;
  }

  String toDoubleDigit() {
    if (this == null) return '0';
    if (this! < 10) {
      return '0$this';
    } else {
      return '$this';
    }
  }

  int removeLastSixDigits() {
    if (this == null) return 0;
    return (this! ~/ 1000000);
  }
}

extension ListFilter<T> on List<T>? {
  T? firstOrNull(bool Function(T element) test) {
    if (this == null) return null;
    return this?.firstOrNull(test);
  }

  bool isNullOrEmpty() {
    return this == null || this!.isEmpty;
  }

  bool isNotNullOrEmpty() {
    return !isNullOrEmpty();
  }

  bool hasAll(List<T> anotherList) {
    if (isNullOrEmpty()) return false;
    bool containsAllElement = true;
    for (var i = 0; i < this!.length; i++) {
      containsAllElement = anotherList.contains(this![i]);
      if (!containsAllElement) break;
    }
    return containsAllElement;
  }
}

extension EmailValidator on String? {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this!);
  }
}

extension TimeValidator on DateTime? {
  String toTimeFormat() {
    DateTime inputDate = DateTime.now();
    if (toString().isNotNullOrEmpty()) {
      inputDate = DateFormat(AppDateFormats.dateFormatToday).parse(toString());
    }
    return DateFormat(AppDateFormats.dateFormatHHMM).format(inputDate);
  }

  DateTime toStartDateWithValidation() {
    if (this == null) {
      return DateTime.now();
    }
    if (this!.isAfter(DateTime.now())) {
      return DateTime.now();
    }
    return this!;
  }
}

extension StringNullablity on String? {
  bool isNullOrEmpty() {
    return this == null || this!.trim().isEmpty;
  }

  bool isNotNullOrEmpty() {
    return !isNullOrEmpty();
  }

  String orEmpty() {
    if (isNullOrEmpty()) return "";
    return this!;
  }

  bool isNotNullAndEmpty() {
    return this != null && this!.isNotEmpty;
  }

}

bool notNull(String? data) {
  return data.isNotNullOrEmpty();
}

String orEmpty(String? data) {
  return data.orEmpty();
}