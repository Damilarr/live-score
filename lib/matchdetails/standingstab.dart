import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:live_score/services/api_client.dart';

class StandingsTab extends StatefulWidget {
  final int leagueId;

  const StandingsTab({super.key, required this.leagueId});

  @override
  State<StandingsTab> createState() => _StandingsTabState();
}

class _StandingsTabState extends State<StandingsTab> {
  final _apiClient = ApiClient();
  bool isLoading = true;
  List<dynamic> standings = [];
  String leagueName = '';

  @override
  void initState() {
    super.initState();
    fetchStandings();
  }

  Future<void> fetchStandings() async {
    setState(() {
      isLoading = true;
    });

    try {
      print('league id in standings ${widget.leagueId}');
      final url = Uri.parse(
        'https://free-api-live-football-data.p.rapidapi.com/football-get-standing-all',
      ).replace(queryParameters: {"leagueid": widget.leagueId.toString()});

      final response = await _apiClient.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          print('got data, now setting');
          setState(() {
            standings = data['response']['standing'];
            // leagueName = data['response']['leagueName'];
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching standings: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : standings.isEmpty
        ? Center(child: Text('No standings available'))
        : RefreshIndicator(
          onRefresh: fetchStandings,
          child: Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: Text(
              //     // leagueName,
              //     'league name',
              //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: StandingsHeader(),
              ),
              Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: standings.length,
                  itemBuilder: (context, index) {
                    final team = standings[index];
                    return StandingsRow(team: team, position: index + 1);
                  },
                ),
              ),
            ],
          ),
        );
  }
}

class StandingsHeader extends StatelessWidget {
  const StandingsHeader({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 30, child: Text('#')),
        Expanded(flex: 3, child: Text('Team')),
        SizedBox(width: 30, child: Text('P')),
        SizedBox(width: 30, child: Text('W')),
        SizedBox(width: 30, child: Text('D')),
        SizedBox(width: 30, child: Text('L')),
        SizedBox(width: 30, child: Text('GD')),
        SizedBox(width: 30, child: Text('Pts')),
      ],
    );
  }
}

class StandingsRow extends StatelessWidget {
  final dynamic team;
  final int position;

  const StandingsRow({super.key, required this.team, required this.position});

  @override
  Widget build(BuildContext context) {
    Color? qualColor;
    if (team['qualColor'] != null) {
      final colorString = team['qualColor'].toString().replaceAll('#', '');
      final colorValue = int.tryParse('0xff$colorString');
      if (colorValue != null) {
        qualColor = Color(colorValue);
      }
    }

    return Container(
      color: qualColor?.withAlpha((0.1 * 255).round()),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(
              position.toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Image.network(
                  'https://images.fotmob.com/image_resources/logo/teamlogo/${team["id"]}_small.png',
                  height: 20,
                  width: 20,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          Icon(Icons.sports_soccer, size: 20),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(team['name'], overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
          SizedBox(width: 30, child: Text(team['played'].toString())),
          SizedBox(width: 30, child: Text(team['wins'].toString())),
          SizedBox(width: 30, child: Text(team['draws'].toString())),
          SizedBox(width: 30, child: Text(team['losses'].toString())),
          SizedBox(width: 30, child: Text(team['goalConDiff'].toString())),
          SizedBox(
            width: 30,
            child: Text(
              team['pts'].toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
