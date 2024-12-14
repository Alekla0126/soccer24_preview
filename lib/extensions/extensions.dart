import 'package:flutter/material.dart';

import '../features/ads/ads_manager.dart';

extension DateCompare on DateTime {
  int daysFromToday() {
    final now = DateTime.now().toMidnight();
    if (isSameDay(now)) return 0;
    return difference(now).inDays.truncate();
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  DateTime toMidnight() => DateTime(year, month, day);
}

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  Color get primaryColor => theme.primaryColor;

  Color get cardColor => theme.cardColor;

  ColorScheme get colorScheme => theme.colorScheme;

  DefaultTextStyle get defaultTextStyle => DefaultTextStyle.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  NavigatorState get navigator => Navigator.of(this);

  void goTo(Widget destination, [showAd = true]) {
    if (showAd) AdsManager.instance.showInterstitialAd();
    Navigator.of(this).push(
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  FocusScopeNode get focusScope => FocusScope.of(this);

  ScaffoldState get scaffold => Scaffold.of(this);

  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);
}

extension EString on String {
  String lastChars(int n) {
    if (n >= length) return this;
    return substring(length - n);
  }
}
