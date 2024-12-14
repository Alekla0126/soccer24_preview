import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../_utils/utils.dart';
import '../../../constants/bet_smart_icons.dart';
import '../../../constants/default_values.dart';
import '../../../constants/strings.dart';
import '../../../extensions/extensions.dart';
import '../../widgets/exit_dialog.dart';
import '../league/leagues_page.dart';
import '../fixtures/fixtures_page_view.dart';
import '../profile/profile_page.dart';
import '../tips/tips_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Utils.showRateDialog(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: _onPopInvoked,
      canPop: false,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          unselectedLabelStyle: context.textTheme.labelSmall,
          selectedLabelStyle: context.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          type: BottomNavigationBarType.fixed,
          backgroundColor: context.colorScheme.secondaryContainer,
          selectedItemColor: context.colorScheme.primary,
          unselectedItemColor: context.colorScheme.onSecondaryContainer,
          currentIndex: _selectedPageIndex,
          items: _bottomNavigationBarItems,
          onTap: (index) => setState(() => _selectedPageIndex = index),
        ),
        body: SafeArea(
          child: _pages[_selectedPageIndex],
        ),
      ),
    );
  }

  final List<Widget> _pages = [
    const FixturesPageView(),
    const TipsPage(),
    const LeaguesPage(),
    const ProfilePage(),
  ];

  List<BottomNavigationBarItem> get _bottomNavigationBarItems {
    return [
      BottomNavigationBarItem(
        label: Strings.matches,
        icon: Padding(
          padding: EdgeInsets.only(bottom: DefaultValues.padding / 4),
          child: const Icon(soccer24Icons.matches),
        ),
      ),
      BottomNavigationBarItem(
        label: Strings.tips,
        icon: Padding(
          padding: EdgeInsets.only(bottom: DefaultValues.padding / 4),
          child: const Icon(soccer24Icons.tips),
        ),
      ),
      BottomNavigationBarItem(
        label: Strings.leagues,
        icon: Padding(
          padding: EdgeInsets.only(bottom: DefaultValues.padding / 4),
          child: const Icon(soccer24Icons.league),
        ),
      ),
      BottomNavigationBarItem(
        label: Strings.profile,
        icon: Padding(
          padding: EdgeInsets.only(bottom: DefaultValues.padding / 4),
          child: const Icon(soccer24Icons.profile),
        ),
      ),
    ];
  }

  Future _onPopInvoked(didPop) async {
    if (didPop) return;
    if (_selectedPageIndex != 0) {
      setState(() {
        _selectedPageIndex = 0;
      });
    } else {
      bool pop = false;
      await showDialog<bool>(
        context: context,
        builder: (context) => ExitDialog(onExit: () => pop = true),
      );
      if (mounted && pop) SystemNavigator.pop();
    }
  }
}
