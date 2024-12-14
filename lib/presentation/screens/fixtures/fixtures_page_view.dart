import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../_package_info/app_info.dart';
import '../../../_utils/utils.dart';
import '../../../constants/bet_smart_icons.dart';
import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../constants/strings.dart';
import '../../../extensions/extensions.dart';
import '../../../features/ads/applovin/applovin_manager.dart';
import 'fixtures_page.dart';

class FixturesPageView extends StatefulWidget {
  const FixturesPageView({super.key});

  @override
  State<FixturesPageView> createState() => _FixturesPageViewState();
}

class _FixturesPageViewState extends State<FixturesPageView> {
  late final PageController _globalPageController;
  late final PageController _pageController;
  late DateTime _selectedDate;
  final int pagesCount = 7;
  late int _initialPage;
  bool live = false;

  late List<FixturesPage> _pages;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _initialPage = pagesCount ~/ 2;
    _pages = List.generate(
      pagesCount,
      (index) => FixturesPage(date: DateTime.now().add(Duration(days: index - _initialPage))),
    );
    _globalPageController = PageController(initialPage: 0);
    _pageController = PageController(initialPage: _initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _globalPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _selectedDate.isSameDay(DateTime.now())
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _jumpToToday(),
              shape: const StadiumBorder(),
              label: const Text(Strings.today),
            ),
      appBar: AppBar(
        title: Text(AppInfo.name),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                context.read<ApplovinManager>().showInterstitialAd();
                live = !live;
              });
              if (live) {
                _globalPageController.jumpToPage(2);
              } else {
                if (_isOutRange()) {
                  _globalPageController.jumpToPage(1);
                } else {
                  final pageIndex = _selectedDate.daysFromToday() + _initialPage;

                  _globalPageController.jumpToPage(0);
                  _pageController.jumpToPage(pageIndex);
                }
              }
            },
            child: Icon(
              soccer24Icons.live,
              size: 24.r,
              color: live ? AppColors.redColor : null,
            ),
          ),
          badges.Badge(
            onTap: () async => await _onDateSelected(context),
            badgeAnimation: const badges.BadgeAnimation.scale(),
            position: badges.BadgePosition.custom(bottom: 6.r, start: 0, end: 0),
            badgeContent: Text(
              '${_selectedDate.day}'.padLeft(2,'0'),
              textAlign: TextAlign.center,
              style: context.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            badgeStyle: const badges.BadgeStyle(
              badgeColor: AppColors.transparent,
              shape: badges.BadgeShape.square,
            ),
            child: IconButton(
              onPressed: () async => await _onDateSelected(context),
              icon: Icon(
                soccer24Icons.calendar,
                color: context.colorScheme.primary,
                size: 24.r,
              ),
            ),
          ),
        ],
      ),
      body: PageView(
        controller: _globalPageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          if (index == 1) {
            _showDateSnackBar(context);
          }
        },
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedDate = _pages[index].date!;
              });
              _showDateSnackBar(context);
            },
            children: _pages,
          ),
          FixturesPage(date: _selectedDate),
          const FixturesPage(live: 'all'),
        ],
      ),
    );
  }

  bool _isOutRange() {
    final now = DateTime.now().toMidnight();
    return _selectedDate.isAfter(now.add(Duration(days: _initialPage))) ||
        _selectedDate.isBefore(now.subtract(Duration(days: _initialPage)));
  }

  Future<void> _onDateSelected(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: Constants.firstFixtureDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
        live = false;
      });
      if (_isOutRange()) {
        _globalPageController.jumpToPage(1);
      } else {
        final pageIndex = _selectedDate.daysFromToday() + _initialPage;

        _globalPageController.jumpToPage(0);
        _pageController.jumpToPage(pageIndex);
      }
    }
  }

  void _jumpToToday() {
    setState(() {
      _selectedDate = DateTime.now();
      live = false;
    });
    _globalPageController.jumpToPage(0);
    _pageController.jumpToPage(_initialPage);
  }

  void _showDateSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          width: .3.sw,
          backgroundColor: context.colorScheme.secondaryContainer,
          shape: const StadiumBorder(),
          content: Text(
            Utils.formatDateTime(_selectedDate),
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold, color: context.colorScheme.onSecondaryContainer),
          ),
        ),
      );
  }
}
