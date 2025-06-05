import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:live_score/datamodel.dart';
import 'package:live_score/matchdetails/matchdetailscreen.dart';
import 'package:live_score/services/api_client.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  void initState() {
    super.initState();
    getLeagueFixturesForDate();
  }

  DateTime selectedDate = DateTime.now();
  final _apiClient = ApiClient();
  List<LeagueFixturesByDate>? leagueFixtures;
  bool isLoading = true;
  List<bool> expandedStates = [];

  final List<DateTime> nextFiveDays = List.generate(
    5,
    (index) => DateTime.now().add(Duration(days: index)),
  );

  Future<void> getLeagueFixturesForDate() async {
    setState(() {
      isLoading = true;
    });

    String formattedDate = DateFormat('yyyyMMdd').format(selectedDate);
    print('Fetching fixtures for date: $formattedDate'); // Add logging

    try {
      final url = Uri.parse(
        "https://free-api-live-football-data.p.rapidapi.com/football-get-matches-by-date-and-league",
      ).replace(queryParameters: {"date": formattedDate});

      final response = await _apiClient.get(url);
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);

        setState(() {
          if (decodedResponse['response'] == null) {
            print('respp');
            print(decodedResponse);
            leagueFixtures = [];
            expandedStates = [];
          } else if (decodedResponse['response'] is List) {
            leagueFixtures =
                (decodedResponse['response'] as List)
                    .map((fixture) => LeagueFixturesByDate.fromJson(fixture))
                    .toList();
            // Initialize expansion states
            expandedStates = List.filled(leagueFixtures!.length, false);
          } else {
            print('Unexpected response format: ${decodedResponse['response']}');
            leagueFixtures = [];
            expandedStates = [];
          }
          isLoading = false;
        });
      } else {
        print('API request failed with status: ${response.statusCode}');
        setState(() {
          leagueFixtures = [];
          expandedStates = [];
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error in API call: $e');
      setState(() {
        leagueFixtures = [];
        expandedStates = [];
        isLoading = false;
      });
    }
  }

  void updateSelectedDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    getLeagueFixturesForDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Schedule"),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // Add filter functionality if needed
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Upcoming Matches",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            // Date selector
            SizedBox(
              height: 100,
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: nextFiveDays.length,
                      itemBuilder: (context, index) {
                        final date = nextFiveDays[index];
                        final isSelected =
                            selectedDate.day == date.day &&
                            selectedDate.month == date.month &&
                            selectedDate.year == date.year;

                        return GestureDetector(
                          onTap: () {
                            updateSelectedDate(
                              date,
                            ); // Use the method that fetches new data
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? Colors.blue
                                      : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  DateFormat.E().format(date),
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                                Text(
                                  DateFormat.d().format(date),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        updateSelectedDate(
                          pickedDate,
                        ); // Use the method that fetches new data
                      }
                    },
                    icon: Icon(Icons.calendar_today),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Matches for ${DateFormat.yMMMd().format(selectedDate)}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child:
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : leagueFixtures == null || leagueFixtures!.isEmpty
                      ? Center(
                        child: Text("No matches scheduled for this date"),
                      )
                      : SingleChildScrollView(
                        child: ExpansionPanelList(
                          expansionCallback: (panelIndex, isExpanded) {
                            setState(() {
                              expandedStates[panelIndex] = isExpanded;
                            });
                          },
                          children:
                              leagueFixtures!.asMap().entries.map((entry) {
                                final index = entry.key;
                                final leagueFixture = entry.value;
                                return ExpansionPanel(
                                  headerBuilder: (context, isExpanded) {
                                    return ListTile(
                                      title: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.network(
                                            'https://images.fotmob.com/image_resources/logo/leaguelogo/${leagueFixture.primaryId}_large.png',
                                            height: 30,
                                            width: 30,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Icon(Icons.sports_soccer),
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  leagueFixture.name,
                                                  style: TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  maxLines: 1,
                                                ),
                                                Text(leagueFixture.ccode),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  body: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: leagueFixture.matches.length,
                                    itemBuilder: (context, fixtureIndex) {
                                      final fixture =
                                          leagueFixture.matches[fixtureIndex];
                                      return ListTile(
                                        title: FixtureSchedule(
                                          fixture: fixture,
                                        ),
                                      );
                                    },
                                  ),
                                  isExpanded: expandedStates[index],
                                );
                              }).toList(),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

class FixtureSchedule extends StatelessWidget {
  final fixture;
  const FixtureSchedule({super.key, required this.fixture});

  @override
  Widget build(BuildContext context) {
    final bool matchStarted =
        fixture['status'] != null && fixture['status']['started'] == true;

    String matchTime = "";
    if (fixture['time'] != null) {
      matchTime = fixture['time'];
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => Matchdetailscreen(
                  leagueId: fixture['leagueId'],
                  matchId: fixture['id'],
                  homeTeamName: fixture['home']['name'],
                  awayTeamName: fixture['away']['name'],
                  homeScore:
                      fixture['home']['score'].toString(), // Convert to String
                  awayScore:
                      fixture['away']['score'].toString(), // Convert to String
                  matchTime: matchTime,
                  isFinished: fixture['status']['finished'],
                  awayTeamId: fixture['away']['id'],
                  homeTeamId: fixture['home']['id'],
                ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Column(
          children: [
            // Home team row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.network(
                        'https://images.fotmob.com/image_resources/logo/teamlogo/${fixture['home']['id']}_large.png',
                        height: 30,
                        width: 30,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                Icon(Icons.sports_soccer_rounded, size: 30),
                      ),
                      SizedBox(width: 12),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          fixture['home']['name'],
                          style: TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                matchStarted
                    ? Text(
                      fixture['home']['score'].toString(),
                      style: TextStyle(fontSize: 16),
                    )
                    : Container(),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.network(
                        'https://images.fotmob.com/image_resources/logo/teamlogo/${fixture['away']['id']}_large.png',
                        height: 30,
                        width: 30,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                Icon(Icons.sports_soccer_rounded, size: 30),
                      ),
                      SizedBox(width: 12),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          fixture['away']['name'],
                          style: TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                matchStarted
                    ? Text(
                      fixture['away']['score'].toString(),
                      style: TextStyle(fontSize: 16),
                    )
                    : Container(),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                matchTime,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Divider(height: 1, color: Colors.black12),
          ],
        ),
      ),
    );
  }
}
