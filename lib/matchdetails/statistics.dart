import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:live_score/services/api_client.dart';

class StatisticsTab extends StatefulWidget {
  final int matchId;
  const StatisticsTab({super.key, required this.matchId});

  @override
  State<StatisticsTab> createState() => _StatisticsTabState();
}

class _StatisticsTabState extends State<StatisticsTab> {
  final _apiClient = ApiClient();
  bool isLoading = true;
  List<dynamic> statCategories = [];
  String homeTeamName = '';
  String awayTeamName = '';
  @override
  void initState() {
    fetchStatistics();
    super.initState();
  }

  Future<void> fetchStatistics() async {
    setState(() {
      isLoading = true;
    });
    try {
      final url = Uri.parse(
        "https://free-api-live-football-data.p.rapidapi.com/football-get-match-event-all-stats",
      ).replace(queryParameters: {"eventid": widget.matchId.toString()});
      final response = await _apiClient.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            statCategories = data['response']['stats'];
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            statCategories = [];
          });
        }
      } else {
        setState(() {
          isLoading = false;
          statCategories = [];
        });
      }
    } catch (e) {
      print('Error fetching statistics: $e');
      setState(() {
        isLoading = false;
        statCategories = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : statCategories.isEmpty
        ? Center(child: Text("No Statistics available"))
        : RefreshIndicator(
          onRefresh: fetchStatistics,
          child: ListView.builder(
            itemCount: statCategories.length,
            itemBuilder: (context, index) {
              final category = statCategories[index];
              return StatisticsCategory(category: category);
            },
          ),
        );
  }
}

class StatisticsCategory extends StatelessWidget {
  final dynamic category;
  const StatisticsCategory({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            category["title"],
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...List.generate(category['stats'].length, (index) {
          final stat = category['stats'][index];
          if (stat['type'] == 'title') return SizedBox.shrink();
          return StatItem(stat: stat);
        }),
        Divider(thickness: 8, color: Colors.grey.shade200),
      ],
    );
  }
}

class StatItem extends StatelessWidget {
  final dynamic stat;

  const StatItem({super.key, required this.stat});

  @override
  Widget build(BuildContext context) {
    final homeValue = stat['stats'][0];
    final awayValue = stat['stats'][1];
    final String highlighted = stat['highlighted'] ?? 'equal';

    Color homeColor = Colors.grey;
    Color awayColor = Colors.grey;

    if (highlighted == 'home') {
      homeColor = Colors.green;
    } else if (highlighted == 'away') {
      awayColor = Colors.green;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$homeValue',
                style: TextStyle(fontWeight: FontWeight.bold, color: homeColor),
              ),
              Text(
                stat['title'],
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
              Text(
                '$awayValue',
                style: TextStyle(fontWeight: FontWeight.bold, color: awayColor),
              ),
            ],
          ),
          SizedBox(height: 4),
          if (stat['type'] == 'graph')
            LinearProgressIndicator(
              value:
                  double.parse(homeValue.toString()) /
                  (double.parse(homeValue.toString()) +
                      double.parse(awayValue.toString())),
              backgroundColor: Colors.grey.shade300,
              color: Colors.blue,
            ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
