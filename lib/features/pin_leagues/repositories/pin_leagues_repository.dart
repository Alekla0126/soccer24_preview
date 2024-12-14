import '../../../constants/constants.dart';
import '../models/pinned_league.dart';
import 'package:hive/hive.dart';


class PinLeaguesRepository {
  final Box<PinnedLeague> _box = Hive.box<PinnedLeague>(Constants.pinnedLeaguesBox);

  Box<PinnedLeague> get box => _box;

  Stream<BoxEvent> get pinnedLeaguesStream {
    return _box.watch();
  }

  Future savePinnedLeague(PinnedLeague league) async {
    await _box.put(league.id, league);
  }

  Future deletePinnedLeague(int id) async {
    await _box.delete(id);
  }

  Future deleteAllPinnedLeagues(List<PinnedLeague> leagues) async {
    await _box.deleteAll(leagues.map((e) => e.id));
  }

  List<PinnedLeague> getPinnedLeagues() {
    return _box.values.toList(growable: false).cast<PinnedLeague>();
  }

  Future clearisPinnedLeagues() async {
    await _box.clear();
  }

  isPinned(int leagueId) {
    return _box.containsKey(leagueId);
  }
}