import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:live_score/datamodel.dart';
import 'package:live_score/matchdetails/matchdetailscreen.dart';
import 'package:live_score/services/api_client.dart';

class Overviewscreen extends StatefulWidget {
  final int leagueId;
  const Overviewscreen({super.key, required this.leagueId});

  @override
  State<Overviewscreen> createState() => _OverviewscreenState();
}

class _OverviewscreenState extends State<Overviewscreen> {
  final _apiClient = ApiClient();
  List<LeagueFixture>? fixtures;
  @override
  void initState() {
    super.initState();
    getFixtures();
  }

  Future<void> getFixtures() async {
    final response = Uri.parse(
      "https://free-api-live-football-data.p.rapidapi.com/football-get-all-matches-by-league",
    ).replace(queryParameters: {"leagueid": widget.leagueId.toString()});
    final res = await _apiClient.get(response);
    if (res.statusCode == 200) {
      final decodedResponse = jsonDecode(res.body);
      setState(() {
        fixtures =
            (decodedResponse['response']['matches'] as List)
                .map((match) => LeagueFixture.fromJson(match))
                .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return fixtures == null
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
          itemCount: fixtures?.length,
          itemBuilder: (context, index) {
            return Fixture(
              fixture: fixtures![index],
              leagueId: widget.leagueId,
            );
          },
        );
  }
}

class Fixture extends StatelessWidget {
  final LeagueFixture fixture;
  final int leagueId;
  const Fixture({super.key, required this.fixture, required this.leagueId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => Matchdetailscreen(
                  leagueId: leagueId,
                  matchId: int.parse(fixture.id),
                  homeTeamName: fixture.home['name'],
                  awayTeamName: fixture.away['name'],
                  homeScore: fixture.home['score'].toString(),
                  awayScore: fixture.away['score'].toString(),
                  matchTime: fixture.status['utcTime'],
                  isFinished: fixture.status['finished'],
                  awayTeamId: int.parse(fixture.away['id']),
                  homeTeamId: int.parse(fixture.home['id']),
                ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    spacing: 12,
                    children: [
                      Image.network(
                        'https://images.fotmob.com/image_resources/logo/teamlogo/${fixture.home['id']}_large.png',
                        height: 30,
                        width: 30,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                Icon(Icons.sports_soccer_rounded, size: 30),
                      ),
                      Text(
                        fixture.home['name'],
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Text(
                  fixture.home['score'].toString(),
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    spacing: 12,
                    children: [
                      Image.network(
                        'https://images.fotmob.com/image_resources/logo/teamlogo/${fixture.away['id']}_large.png',
                        height: 30,
                        width: 30,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                Icon(Icons.sports_soccer_rounded, size: 30),
                      ),
                      Text(
                        fixture.away['name'],
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Text(
                  fixture.away['score'].toString(),
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            Divider(height: 1, color: Colors.black12),
          ],
        ),
      ),
    );
  }
}
