import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:live_score/datamodel.dart';
import 'package:live_score/home/leaguecard.dart';
import 'package:live_score/home/scorecards.dart';
import 'package:live_score/services/api_client.dart';
import 'package:live_score/schedule/schedule_screen.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [HomeScreen(), ScheduleScreen()];

    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 1.0),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          backgroundColor: Colors.white,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_sharp),
              label: "Schedule",
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> leagues = [];
  List<LiveMatch> liveMatches = [];
  List<LiveMatch> finishedMatches = [];
  final _apiClient = ApiClient();
  bool isLoading = true;
  bool isLoadingLiveMatches = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchLeagues();
    fetchLiveMatches();
    _timer = Timer.periodic(Duration(seconds: 360), (timer) {
      fetchLiveMatches();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchLeagues() async {
    final response = Uri.parse(
      'https://free-api-live-football-data.p.rapidapi.com/football-get-all-leagues',
    );
    final res = await _apiClient.get(response);
    if (res.statusCode == 200) {
      setState(() {
        final decodedResponse = jsonDecode(res.body);
        leagues = decodedResponse['response']['leagues'];
        isLoading = false;
      });
    }
  }

  Future<void> fetchLiveMatches() async {
    setState(() {
      isLoadingLiveMatches = true;
    });
    final url = Uri.parse(
      "https://free-api-live-football-data.p.rapidapi.com/football-current-live",
    );
    try {
      final res = await _apiClient.get(url);
      if (res.statusCode == 200) {
        final decodedResponse = jsonDecode(res.body);
        if (decodedResponse['status'] == "success") {
          final liveData = decodedResponse['response']['live'] as List;
          List<LiveMatch> allMatches =
              liveData.map((match) => LiveMatch.fromJson(match)).toList();
          setState(() {
            liveMatches =
                allMatches
                    .where(
                      (match) => match.status.ongoing && !match.status.finished,
                    )
                    .toList();
            finishedMatches =
                allMatches.where((match) => match.status.finished).toList();
            isLoadingLiveMatches = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching live matches: $e ');
      setState(() {
        isLoadingLiveMatches = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Home"),
        actions: [
          GestureDetector(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.notifications_active, size: 24),
                ),
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Center(
                      child: Text(
                        "10",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: HomepageBody(
        leagues: leagues,
        isLoading: isLoading,
        liveMatches: liveMatches,
        finishedMatches: finishedMatches,
        isLoadingLiveMatches: isLoadingLiveMatches,
        onRefresh: fetchLiveMatches,
      ),
    );
  }
}

class HomepageBody extends StatelessWidget {
  final List<dynamic> leagues;
  final bool isLoading;
  final List<LiveMatch> liveMatches;
  final List<LiveMatch> finishedMatches;
  final bool isLoadingLiveMatches;
  final Function onRefresh;

  const HomepageBody({
    super.key,
    required this.leagues,
    required this.isLoading,
    required this.finishedMatches,
    required this.isLoadingLiveMatches,
    required this.liveMatches,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: RefreshIndicator(
        onRefresh: () async {
          await onRefresh();
        },
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Text(
              "What's on your mind?",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Search matches players clubs and news",
                fillColor: Colors.black38,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "League",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            SizedBox(
              height: 120,
              child:
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: leagues.length,
                        itemBuilder: (context, index) {
                          final league = leagues[index];
                          return Padding(
                            padding: EdgeInsets.all(8),
                            child: LeagueCard(
                              id: league['id'],
                              title: league['name'],
                              leagueUrlLogo: league['logo'],
                            ),
                          );
                        },
                      ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Live Now",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                if (isLoadingLiveMatches)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    isLoadingLiveMatches && liveMatches.isEmpty
                        ? [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ]
                        : liveMatches.isEmpty
                        ? [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text("No live matches at the moment"),
                          ),
                        ]
                        : liveMatches
                            .map(
                              (match) => ScoreCard(
                                homeClubName: match.home.name,
                                awayClubName: match.away.name,
                                homeClubLogoUrl:
                                    "https://images.fotmob.com/image_resources/logo/teamlogo/${match.home.id}_large.png",
                                awayClubLogoUrl:
                                    "https://images.fotmob.com/image_resources/logo/teamlogo/${match.away.id}_large.png",
                                leaugeLogoUrl:
                                    "https://images.fotmob.com/image_resources/logo/leaguelogo/${match.leagueId}_large.png",
                                currentTime: match.status.liveTime.short,
                                homeScore: match.home.score.toString(),
                                awayScore: match.away.score.toString(),
                                isFinished: false,
                                awayTeamId: match.away.id,
                                homeTeamId: match.home.id,
                                leagueId: match.leagueId,
                                matchId: match.id,
                              ),
                            )
                            .toList(),
              ),
            ),
            SizedBox(height: 32),
            Text(
              "Just Finished",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    finishedMatches.isEmpty
                        ? [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text("No recently finished matches"),
                          ),
                        ]
                        : finishedMatches
                            .map(
                              (match) => ScoreCard(
                                homeClubName: match.home.name,
                                awayClubName: match.away.name,
                                homeClubLogoUrl:
                                    "https://images.fotmob.com/image_resources/logo/teamlogo/${match.home.id}_large.png",
                                awayClubLogoUrl:
                                    "https://images.fotmob.com/image_resources/logo/teamlogo/${match.away.id}_large.png",
                                leaugeLogoUrl:
                                    "https://images.fotmob.com/image_resources/logo/leaguelogo/${match.leagueId}_large.png",
                                currentTime: match.status.liveTime.short,
                                homeScore: match.home.score.toString(),
                                awayScore: match.away.score.toString(),
                                awayTeamId: match.away.id,
                                homeTeamId: match.home.id,
                                leagueId: match.leagueId,
                                matchId: match.id,
                                isFinished: match.status.finished,
                              ),
                            )
                            .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
