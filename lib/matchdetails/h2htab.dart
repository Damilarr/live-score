import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:live_score/services/api_client.dart';

class H2HTab extends StatefulWidget {
  final int matchId;

  const H2HTab({super.key, required this.matchId});

  @override
  State<H2HTab> createState() => _H2HTabState();
}

class _H2HTabState extends State<H2HTab> {
  final _apiClient = ApiClient();
  bool isLoading = true;
  List<dynamic> h2hMatches = [];
  List<int> summary = [0, 0, 0]; // [home wins, draws, away wins]

  @override
  void initState() {
    super.initState();
    fetchH2HData();
  }

  Future<void> fetchH2HData() async {
    setState(() {
      isLoading = true;
    });

    try {
      print("match id${widget.matchId}");
      final url = Uri.parse(
        'https://free-api-live-football-data.p.rapidapi.com/football-get-head-to-head',
      ).replace(queryParameters: {"eventid": widget.matchId.toString()});

      final response = await _apiClient.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            h2hMatches = data['response']['lineup']['matches'];
            summary = List<int>.from(data['response']['lineup']['summary']);
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
      print('Error fetching H2H data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : h2hMatches.isEmpty
        ? Center(child: Text('No head-to-head matches available'))
        : RefreshIndicator(
          onRefresh: fetchH2HData,
          child: Column(
            children: [
              H2HSummary(summary: summary),
              Expanded(
                child: ListView.builder(
                  itemCount: h2hMatches.length,
                  itemBuilder: (context, index) {
                    final match = h2hMatches[index];
                    return H2HMatchCard(match: match);
                  },
                ),
              ),
            ],
          ),
        );
  }
}

class H2HSummary extends StatelessWidget {
  final List<int> summary;

  const H2HSummary({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                summary[0].toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Text('Home Wins'),
            ],
          ),
          Column(
            children: [
              Text(
                summary[1].toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Text('Draws'),
            ],
          ),
          Column(
            children: [
              Text(
                summary[2].toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              Text('Away Wins'),
            ],
          ),
        ],
      ),
    );
  }
}

class H2HMatchCard extends StatelessWidget {
  final dynamic match;

  const H2HMatchCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${match['league']['name']} - ${match['status']?['reason']?['long'] ?? ''}',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    match['home']['name'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  "${match['status']?['started'] == true && match['status']['finished'] == true ? match['status']['scoreStr'] : DateFormat('MMM d, yyyy').format(DateTime.parse(match['status']['utcTime']).toLocal())}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Expanded(
                  child: Text(
                    match['away']['name'],
                    textAlign: TextAlign.right,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
