import 'package:flutter/material.dart';
import 'package:live_score/matchdetails/lineuptab.dart';
import 'package:live_score/matchdetails/standingstab.dart';
import 'package:live_score/matchdetails/statistics.dart';

class Matchtab extends StatefulWidget {
  final int matchId;
  final int leagueId;
  const Matchtab({super.key, required this.matchId, required this.leagueId});

  @override
  State<Matchtab> createState() => _MatchtabState();
}

class _MatchtabState extends State<Matchtab> with TickerProviderStateMixin {
  late TabController _nestedTabController;
  @override
  void initState() {
    super.initState();
    _nestedTabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _nestedTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _nestedTabController,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).primaryColor,
          tabs: [
            Tab(text: 'Summary'),
            Tab(text: "LineUp"),
            Tab(text: 'Statistics'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _nestedTabController,
            children: [
              StandingsTab(leagueId: widget.leagueId),
              LineupTab(matchId: widget.matchId),
              StatisticsTab(matchId: widget.matchId),
            ],
          ),
        ),
      ],
    );
  }
}
