import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../constants/bet_smart_icons.dart';
import '../../../constants/constants.dart';
import '../../../constants/default_values.dart';
import '../../../constants/strings.dart';
import '../../../extensions/extensions.dart';
import '../../../features/football_api/models/fixture/league.dart';
import '../../../features/football_api/models/odds/bet.dart';
import '../../../features/tips/models/tip_model.dart';
import '../../../features/tips/repositories/tips_repository.dart';
import '../../widgets/leagues_selection.dart';
import '../../widgets/shadowless_card.dart';
import 'tips_list.dart';

class TipsPage extends StatefulWidget {
  const TipsPage({super.key});

  @override
  State<TipsPage> createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  final ExpansionTileController _expansionTileController = ExpansionTileController();
  late Query<Tip> _query;
  bool _isExpanded = false;
  bool _hideEnded = false;

  final DateTime _today = DateTime.now();
  late DateTime _selectedDate;
  League? _league;
  Bet? _bet;

  BuildContext? dialogContext;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _selectedDate = _today;
    _applyFilter();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.tips),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            _isExpanded ? context.colorScheme.primary : context.colorScheme.secondaryContainer,
        onPressed: () => _switchExpansion(),
        child: Icon(
          soccer24Icons.filter,
          color: _isExpanded
              ? context.colorScheme.onPrimary
              : context.colorScheme.onSecondaryContainer,
        ),
      ),
      body: Column(
        children: [
          ShadowlessCard(
            child: Theme(
              data: context.theme.copyWith(
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                dividerColor: Colors.transparent,
              ),
              child: ExpansionTile(
                controller: _expansionTileController,
                onExpansionChanged: (isExpanded) {
                  setState(() {
                    _isExpanded = isExpanded;
                  });
                },
                leading: const Icon(soccer24Icons.filter),
                title: const Text(Strings.filter),
                children: [
                  _datesButtons(),
                  const Divider(height: 0),
                  if (_selectedDate.compareTo(_today) == 0) ...[
                    _hideGameSwitch(),
                    const Divider(height: 0),
                  ],
                  _selectLeagueWidget(),
                  const Divider(height: 0),
                  _betTypes(),
                  const Divider(height: 0),
                  _filterButtons(),
                ],
              ),
            ),
          ),
          Expanded(
            child: TipsList(query: _query),
          ),
        ],
      ),
    );
  }

  Widget _hideGameSwitch() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: DefaultValues.padding / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(Strings.hideStartedGames),
          Gap(DefaultValues.spacing / 2),
          Switch(
            value: _hideEnded,
            onChanged: (value) {
              setState(
                () {
                  _hideEnded = value;
                  if (_hideEnded) {
                    _query = context.read<TipsRepository>().getTips(
                          from: DateTime.now().millisecondsSinceEpoch ~/ 1000,
                          to: _selectedDate.toMidnight().millisecondsSinceEpoch ~/ 1000 +
                              24 * 60 * 60,
                          leagueId: _league?.id,
                          betId: _bet?.id,
                          descending: false,
                        );
                  } else {
                    _query = context.read<TipsRepository>().getTips(
                          from: _selectedDate.toMidnight().millisecondsSinceEpoch ~/ 1000,
                          to: _selectedDate.toMidnight().millisecondsSinceEpoch ~/ 1000 +
                              24 * 60 * 60,
                          leagueId: _league?.id,
                          betId: _bet?.id,
                          descending: false,
                        );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _betTypes() {
    return Padding(
      padding: EdgeInsets.all(DefaultValues.padding / 2),
      child: Row(
        children: [
          Text(
            Strings.betType,
            style: context.textTheme.bodyLarge,
          ),
          Gap(DefaultValues.spacing),
          Expanded(
            child: SizedBox(
              height: 40.h,
              child: DropdownButtonFormField<Bet>(
                isExpanded: true,
                value: _bet,
                alignment: Alignment.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: context.colorScheme.primary),
                    borderRadius: BorderRadius.circular(DefaultValues.radius),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: context.colorScheme.primary),
                    borderRadius: BorderRadius.circular(DefaultValues.radius),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: context.colorScheme.primary),
                    borderRadius: BorderRadius.circular(DefaultValues.radius),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: DefaultValues.spacing / 2),
                ),
                items: List<DropdownMenuItem<Bet>>.generate(
                  DefaultValues.availableTipsBets.length + 1,
                  (index) {
                    if (index == 0) {
                      return const DropdownMenuItem<Bet>(
                        value: null,
                        child: Text(Strings.allAvailableTypes),
                      );
                    }
                    return DropdownMenuItem<Bet>(
                      value: DefaultValues.availableTipsBets[index - 1],
                      child: Text(DefaultValues.availableTipsBets[index - 1].name),
                    );
                  },
                ).toList(growable: false),
                onChanged: (Bet? bet) {
                  setState(() {
                    _bet = bet;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _datesButtons() {
    return Container(
      height: 65.h,
      padding: EdgeInsets.all(DefaultValues.padding / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _selectDateButton(),
          Gap(DefaultValues.spacing / 8),
          _dateButton(_today.subtract(const Duration(days: 1))),
          Gap(DefaultValues.spacing / 8),
          _dateButton(_today),
          Gap(DefaultValues.spacing / 8),
          _dateButton(_today.add(const Duration(days: 1))),
          Gap(DefaultValues.spacing / 8),
          _dateButton(_today.add(const Duration(days: 2))),
        ],
      ),
    );
  }

  Widget _filterButtons() {
    return Padding(
      padding: EdgeInsets.all(DefaultValues.padding / 2),
      child: Row(
        children: [
          OutlinedButton(
            onPressed: () {
              setState(() {
                _resetFilter();
              });
            },
            child: const Text(Strings.resetFilter),
          ),
          Gap(DefaultValues.spacing / 2),
          Expanded(
            child: FilledButton(
              onPressed: () {
                setState(() {
                  _applyFilter();
                });
              },
              child: const Text(Strings.applyFilter),
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectDateButton() {
    final bool isSelected = _selectedDate.compareTo(_today.subtract(const Duration(days: 1))) == -1;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        final DateTime? date = await showDatePicker(
          context: context,
          firstDate: Constants.firstTipDate,
          lastDate: _today.subtract(const Duration(days: 2)),
          currentDate: _today.subtract(const Duration(days: 2)),
        );

        if (date != null) {
          setState(() => _selectedDate = date);
        }
      },
      child: Container(
        width: (1.sw - 3 * DefaultValues.padding) / 5,
        height: double.infinity,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          vertical: DefaultValues.padding / 4,
          horizontal: DefaultValues.padding / 4,
        ),
        decoration: BoxDecoration(
          color: context.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(DefaultValues.radius / 4),
          border: isSelected
              ? Border.all(
                  color: context.colorScheme.primary,
                  strokeAlign: BorderSide.strokeAlignCenter,
                )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isSelected ? DateFormat.E().format(_selectedDate) : Strings.select,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : null,
              ),
              maxLines: 1,
            ),
            Gap(DefaultValues.spacing / 4),
            Text(
              isSelected ? DateFormat.Md().format(_selectedDate) : Strings.date,
              style: context.textTheme.bodySmall?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : null,
              ),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateButton(DateTime date) {
    final isSelected = _selectedDate.compareTo(date) == 0;
    Color textColor;
    if (date.day == _today.day) {
      textColor = context.colorScheme.primary;
    } else {
      textColor = context.colorScheme.onSecondaryContainer;
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() => _selectedDate = date);
      },
      child: Container(
        width: (1.sw - 3 * DefaultValues.padding) / 5,
        height: double.infinity,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          vertical: DefaultValues.padding / 4,
          horizontal: DefaultValues.padding / 4,
        ),
        decoration: BoxDecoration(
          color: context.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(DefaultValues.radius / 4),
          border: isSelected
              ? Border.all(
                  color: context.colorScheme.primary,
                  strokeAlign: BorderSide.strokeAlignCenter,
                )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              date.day == _today.day ? Strings.today : DateFormat.E().format(date),
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: date.day == _selectedDate.day ? FontWeight.bold : null,
                color: textColor,
              ),
              maxLines: 1,
            ),
            Gap(DefaultValues.spacing / 4),
            Text(
              DateFormat.Md().format(date),
              style: context.textTheme.bodySmall?.copyWith(
                color: textColor,
                fontWeight: date.day == _selectedDate.day ? FontWeight.bold : null,
              ),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectLeagueWidget() {
    return Padding(
      padding: EdgeInsets.all(DefaultValues.padding / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            '${Strings.league}:',
            style: context.textTheme.bodyLarge,
          ),
          Gap(DefaultValues.spacing / 2),
          if (_league != null) ...[
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                setState(() {
                  _league = null;
                });
              },
              child: Icon(
                soccer24Icons.clear,
                color: context.colorScheme.error,
                size: 16.r,
              ),
            ),
            Gap(DefaultValues.spacing / 4),
          ],
          Expanded(
            child: Text(
              _league == null ? Strings.allLeague : _league!.name,
              style: context.textTheme.bodyLarge,
            ),
          ),
          Gap(DefaultValues.spacing / 2),
          OutlinedButton(
            onPressed: () {
              showModalBottomSheet(
                useSafeArea: true,
                clipBehavior: Clip.hardEdge,
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return LeaguesSelection(
                    onLeagueSelected: (league) => setState(() => _league = league),
                  );
                },
              );
            },
            child: const Text(Strings.change),
          ),
        ],
      ),
    );
  }

  void _resetFilter() {
    _selectedDate = _today;
    _league = null;
    _bet = null;
    _applyFilter();
  }

  void _applyFilter() {
    _query = context.read<TipsRepository>().getTips(
          from: _selectedDate.toMidnight().millisecondsSinceEpoch ~/ 1000,
          to: _selectedDate.toMidnight().millisecondsSinceEpoch ~/ 1000 + 24 * 60 * 60,
          leagueId: _league?.id,
          betId: _bet?.id,
          descending: false,
        );
  }

  void _switchExpansion() {
    _expansionTileController.isExpanded
        ? _expansionTileController.collapse()
        : _expansionTileController.expand();
    setState(() {
      _isExpanded = _expansionTileController.isExpanded;
    });
  }
}




