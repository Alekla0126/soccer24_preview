import 'dart:convert';

import 'package:soccer24/business_logic/models/fixtures_query.dart';
import 'package:soccer24/business_logic/models/league_query.dart';
import 'package:soccer24/business_logic/models/standings_query.dart';
import 'package:soccer24/services/web_api/web_api.dart';
import 'package:http/http.dart' as http;

class WebApiImpl implements WebApi {

  final String _baseUrl = "api-football-beta.p.rapidapi.com";
  final Map<String, String> _headers = {
    "content-type": "application/json",
    "x-rapidapi-host": "api-football-beta.p.rapidapi.com",
    "x-rapidapi-key": 'f60fb43273msh5455818c9fbac8ep1c8ac0jsn7149158c8677',
  };

  @override
  Future<LeagueQuery> getALlLeagues() async {
    const String endpoint = '/leagues';

    final loadedData = await getData(endpoint: endpoint, query: null);
    LeagueQuery decodedData = LeagueQuery.fromJson(jsonDecode(loadedData));
    return decodedData;
  }

  @override
  Future<FixturesQuery> getAllFixtures({required String date}) async {
    String endpoint = '/fixtures';
    final query = {"date": date};

    final jsonString = await getData(endpoint: endpoint, query: query);

    FixturesQuery decodedData = FixturesQuery.fromJson(jsonDecode(jsonString));
    return decodedData;
  }

  @override
  Future<StandingsQuery> getAllStandings({
    required int leagueId,
    required int year,
  }) async {
    const String endpoint = '/standings';
    var query = {'league': '$leagueId', 'season': '$year'};

    final jsonString = await getData(endpoint: endpoint, query: query);
    StandingsQuery decodedData = StandingsQuery.fromJson(jsonDecode(jsonString));
    return decodedData;
  }

  // helper method for actually getting the data
  Future<dynamic> getData(
      {required String endpoint, required Map<String, String>? query}) async {
    Uri uri = Uri.https(_baseUrl, endpoint, query);

    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      print(response.statusCode);
      return;
    }
  }
}
