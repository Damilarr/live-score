import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:live_score/datamodel.dart';
import 'package:live_score/leaguedetails/leaguestandings.dart';
import 'package:live_score/leaguedetails/overviewscreen.dart';
import 'package:live_score/services/api_client.dart';

class Leaguedetails extends StatefulWidget {
  final int leagueId;
  const Leaguedetails({super.key, required this.leagueId});

  @override
  State<Leaguedetails> createState() => _LeaguedetailsState();
}

class _LeaguedetailsState extends State<Leaguedetails> {
  final _apiClient = ApiClient();
  LeagueDetail? leagueDetail;
  String leagueLogoUrl = '';
  @override
  void initState() {
    super.initState();
    fetchLeagueLogo();
    fetchLeagueDetails();
  }

  Future<void> fetchLeagueLogo() async {
    final response = Uri.parse(
      'https://free-api-live-football-data.p.rapidapi.com/football-get-league-logo',
    ).replace(queryParameters: {'leagueid': widget.leagueId.toString()});
    final resp = await _apiClient.get(response);
    if (resp.statusCode == 200) {
      setState(() {
        final decodedResponse = jsonDecode(resp.body);
        leagueLogoUrl = decodedResponse['response']['url'];
      });
    }
  }

  Future<void> fetchLeagueDetails() async {
    final response = Uri.parse(
      'https://free-api-live-football-data.p.rapidapi.com/football-get-league-detail',
    ).replace(queryParameters: {'leagueid': widget.leagueId.toString()});
    final res = await _apiClient.get(response);
    if (res.statusCode == 200) {
      setState(() {
        final decodedResponse = jsonDecode(res.body);
        leagueDetail = LeagueDetail.fromJson(
          decodedResponse['response']['leagues'],
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                leagueLogoUrl,
                width: 30,
                height: 30,
                errorBuilder:
                    (context, error, stackTrace) => Icon(Icons.sports_soccer),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      leagueDetail?.shortName ?? " ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                    ),
                    Text(
                      leagueDetail?.latestSeason ?? "",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottom: TabBar(tabs: [Tab(text: "Overview"), Tab(text: "Standings")]),
        ),
        body: TabBarView(
          children: [
            Overviewscreen(leagueId: widget.leagueId),
            Leaguestandings(leagueId: widget.leagueId),
          ],
        ),
      ),
    );
  }
}
