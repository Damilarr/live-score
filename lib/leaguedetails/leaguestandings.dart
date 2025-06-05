import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:live_score/datamodel.dart';
import 'package:live_score/services/api_client.dart';

class Leaguestandings extends StatefulWidget {
  final int leagueId;
  const Leaguestandings({super.key, required this.leagueId});

  @override
  State<Leaguestandings> createState() => _LeagueStandingsState();
}

class _LeagueStandingsState extends State<Leaguestandings> {
  final _apiClient = ApiClient();
  List<LeagueStanding>? leagueStandings;
  @override
  void initState() {
    super.initState();
    getStandings();
  }

  Future<void> getStandings() async {
    final url = Uri.parse(
      'https://free-api-live-football-data.p.rapidapi.com/football-get-standing-all',
    ).replace(queryParameters: {"leagueid": widget.leagueId.toString()});
    final res = await _apiClient.get(url);
    if (res.statusCode == 200) {
      final decodedResponse = jsonDecode(res.body);
      setState(() {
        leagueStandings =
            (decodedResponse['response']['standing'] as List)
                .map((standing) => LeagueStanding.fromJson(standing))
                .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return leagueStandings == null
        ? Center(child: CircularProgressIndicator())
        : Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "#",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        "Team",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "M",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "W",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "D",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "L",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "G",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "PTS",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Divider(color: Colors.black12),
                ...leagueStandings!.asMap().entries.map((entry) {
                  final index = entry.key + 1;
                  final standing = entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(index.toString())),
                            Expanded(
                              flex: 4,
                              child: Row(
                                spacing: 8,
                                children: [
                                  Image.network(
                                    'https://images.fotmob.com/image_resources/logo/teamlogo/${standing.id}_large.png',
                                    height: 30,
                                    width: 30,
                                    errorBuilder:
                                        (context, error, stackTrace) => Icon(
                                          Icons.sports_soccer_rounded,
                                          size: 30,
                                        ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      standing.shortName ?? '',
                                      overflow: TextOverflow.fade,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Text(standing.played?.toString() ?? '0'),
                            ),
                            Expanded(
                              child: Text(standing.wins?.toString() ?? '0'),
                            ),
                            Expanded(
                              child: Text(standing.draws?.toString() ?? '0'),
                            ),
                            Expanded(
                              child: Text(standing.losses?.toString() ?? '0'),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(standing.scoresStr ?? '0'),
                            ),
                            Expanded(
                              child: Text(standing.pts?.toString() ?? '0'),
                            ),
                          ],
                        ),
                        Divider(color: Colors.black12),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        );
  }
}
