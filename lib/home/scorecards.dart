import 'package:flutter/material.dart';
import 'package:live_score/matchdetails/matchdetailscreen.dart';

class ScoreCard extends StatelessWidget {
  final String homeClubName,
      homeClubLogoUrl,
      awayClubLogoUrl,
      leaugeLogoUrl,
      currentTime,
      awayClubName,
      homeScore,
      awayScore;
  final int leagueId, matchId, awayTeamId, homeTeamId;
  final bool isFinished;
  const ScoreCard({
    super.key,
    required this.homeClubName,
    required this.awayClubName,
    required this.homeClubLogoUrl,
    required this.awayClubLogoUrl,
    required this.leaugeLogoUrl,
    required this.currentTime,
    required this.homeScore,
    required this.awayScore,
    required this.awayTeamId,
    required this.homeTeamId,
    required this.isFinished,
    required this.leagueId,
    required this.matchId,
  });

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
                  matchId: matchId,
                  homeTeamName: homeClubName,
                  awayTeamName: awayClubName,
                  homeScore: homeScore,
                  awayScore: awayScore,
                  matchTime: currentTime,
                  isFinished: isFinished,
                  awayTeamId: awayTeamId,
                  homeTeamId: homeTeamId,
                ),
          ),
        );
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Card(
          color: Colors.white,
          elevation: 4,
          shadowColor: Colors.white70,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 16,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.network(
                      leaugeLogoUrl,
                      height: 30,
                      width: 30,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              Icon(Icons.sports_soccer_rounded),
                    ),
                    Text(
                      currentTime,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          homeClubLogoUrl,
                          height: 50,
                          width: 50,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  Icon(Icons.sports_soccer),
                        ),
                        Text(homeClubName, style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    Wrap(
                      spacing: 5,
                      children: [
                        Text(
                          homeScore,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "-",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          awayScore,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          awayClubLogoUrl,
                          height: 50,
                          width: 50,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  Icon(Icons.sports_soccer_rounded),
                        ),
                        Text(awayClubName, style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
