import 'package:flutter/material.dart';
import 'package:live_score/matchdetails/h2htab.dart';
import 'package:live_score/matchdetails/matchtab.dart';
import 'package:live_score/matchdetails/standingstab.dart';

class Matchdetailscreen extends StatefulWidget {
  final int matchId;
  final int leagueId;
  final String homeTeamName;
  final String awayTeamName;
  final String homeScore;
  final String awayScore;
  final String matchTime;
  final bool isFinished;
  final int awayTeamId;
  final int homeTeamId;
  const Matchdetailscreen({
    super.key,
    required this.matchId,
    required this.homeTeamName,
    required this.awayTeamName,
    required this.homeScore,
    required this.awayScore,
    required this.matchTime,
    required this.isFinished,
    required this.leagueId,
    required this.awayTeamId,
    required this.homeTeamId,
  });

  @override
  State<Matchdetailscreen> createState() => _MatchdetailscreenState();
}

class _MatchdetailscreenState extends State<Matchdetailscreen>
    with TickerProviderStateMixin {
  late TabController _mainTabController;
  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Match Details"),
        centerTitle: true,
        bottom: TabBar(
          controller: _mainTabController,
          tabs: [Tab(text: "Match"), Tab(text: "H2H"), Tab(text: "Standings")],
        ),
      ),
      body: Column(
        children: [
          //header containing scores
          MatchHeader(
            homeTeamName: widget.homeTeamName,
            awayTeamName: widget.awayTeamName,
            homeScore: widget.homeScore,
            awayScore: widget.awayScore,
            matchTime: widget.matchTime,
            isFinished: widget.isFinished,
            awayTeamId: widget.awayTeamId,
            homeTeamId: widget.homeTeamId,
            leagueId: widget.leagueId,
          ),
          Expanded(
            child: TabBarView(
              controller: _mainTabController,
              children: [
                Matchtab(matchId: widget.matchId, leagueId: widget.leagueId),
                H2HTab(matchId: widget.matchId),
                StandingsTab(leagueId: widget.leagueId),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MatchHeader extends StatelessWidget {
  final String homeTeamName;
  final int homeTeamId;
  final int awayTeamId;
  final int leagueId;
  final String awayTeamName;
  final String homeScore;
  final String awayScore;
  final String matchTime;
  final bool isFinished;
  const MatchHeader({
    super.key,
    required this.leagueId,
    required this.homeScore,
    required this.awayScore,
    required this.awayTeamName,
    required this.homeTeamName,
    required this.isFinished,
    required this.matchTime,
    required this.awayTeamId,
    required this.homeTeamId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Column(
              children: [
                Image.network(
                  "https://images.fotmob.com/image_resources/logo/teamlogo/${homeTeamId}_large.png",
                  height: 50,
                  errorBuilder:
                      (context, error, stackTrace) => Icon(Icons.sports_soccer),
                ),
                SizedBox(height: 8),
                Text(
                  homeTeamName,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  Text(
                    homeScore,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(' - ', style: TextStyle(fontSize: 24)),
                  Text(
                    awayScore,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                isFinished ? "FT" : matchTime,
                style: TextStyle(
                  color: isFinished ? Colors.grey : Colors.green,
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              children: [
                Image.network(
                  "https://images.fotmob.com/image_resources/logo/teamlogo/${awayTeamId}_large.png",
                  height: 50,
                  errorBuilder:
                      (context, error, stackTrace) => Icon(Icons.sports_soccer),
                ),
                SizedBox(height: 8),
                Text(
                  awayTeamName,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
