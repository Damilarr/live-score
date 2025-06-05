import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:live_score/services/api_client.dart';

class LineupTab extends StatefulWidget {
  final int matchId;

  const LineupTab({super.key, required this.matchId});

  @override
  State<LineupTab> createState() => _LineupTabState();
}

class _LineupTabState extends State<LineupTab> with TickerProviderStateMixin {
  final _apiClient = ApiClient();
  bool isLoadingHome = true;
  bool isLoadingAway = true;
  dynamic homeLineup;
  dynamic awayLineup;
  late TabController _formationTabController;

  @override
  void initState() {
    super.initState();
    _formationTabController = TabController(length: 2, vsync: this);
    fetchHomeLineup();
    fetchAwayLineup();
  }

  @override
  void dispose() {
    _formationTabController.dispose();
    super.dispose();
  }

  Future<void> fetchHomeLineup() async {
    setState(() {
      isLoadingHome = true;
    });

    try {
      print('match id ${widget.matchId}');
      final url = Uri.parse(
        'https://free-api-live-football-data.p.rapidapi.com/football-get-hometeam-lineup',
      ).replace(queryParameters: {"eventid": widget.matchId.toString()});

      final response = await _apiClient.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            homeLineup = data['response']['lineup'];
            isLoadingHome = false;
          });
        } else {
          setState(() {
            isLoadingHome = false;
          });
        }
      } else {
        setState(() {
          isLoadingHome = false;
        });
      }
    } catch (e) {
      print('Error fetching home lineup: $e');
      setState(() {
        isLoadingHome = false;
      });
    }
  }

  Future<void> fetchAwayLineup() async {
    setState(() {
      isLoadingAway = true;
    });

    try {
      final url = Uri.parse(
        'https://free-api-live-football-data.p.rapidapi.com/football-get-awayteam-lineup',
      ).replace(queryParameters: {"eventid": widget.matchId.toString()});

      final response = await _apiClient.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            awayLineup = data['response']['lineup'];
            isLoadingAway = false;
          });
        } else {
          setState(() {
            isLoadingAway = false;
          });
        }
      } else {
        setState(() {
          isLoadingAway = false;
        });
      }
    } catch (e) {
      print('Error fetching away lineup: $e');
      setState(() {
        isLoadingAway = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _formationTabController,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: const [Tab(text: 'Home Team'), Tab(text: 'Away Team')],
        ),
        Expanded(
          child: TabBarView(
            controller: _formationTabController,
            children: [
              isLoadingHome
                  ? Center(child: CircularProgressIndicator())
                  : homeLineup == null
                  ? Center(child: Text('No lineup available'))
                  : TeamFormation(lineup: homeLineup),
              isLoadingAway
                  ? Center(child: CircularProgressIndicator())
                  : awayLineup == null
                  ? Center(child: Text('No lineup available'))
                  : TeamFormation(lineup: awayLineup),
            ],
          ),
        ),
      ],
    );
  }
}

class TeamFormation extends StatelessWidget {
  final dynamic lineup;

  const TeamFormation({super.key, required this.lineup});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${lineup['name']} - ${lineup['formation']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Rating: ${lineup['rating']}',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          // Field section with fixed height
          Container(
            height:
                MediaQuery.of(context).size.height *
                0.55, // 55% of screen height
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.green.shade700, Colors.green.shade800],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final fieldSize = Size(
                  constraints.maxWidth,
                  constraints.maxHeight,
                );
                return ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      // Field markings
                      CustomPaint(
                        size: fieldSize,
                        painter: SoccerFieldPainter(),
                      ),
                      // Players
                      ...buildFormationPositions(lineup['starters'], fieldSize),
                      // Coach
                      Positioned(
                        bottom: 12,
                        left: 8,
                        right: 8,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: Text(
                              'Coach: ${lineup['coach']['name']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Substitutes section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Substitutes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(lineup['subs'].length, (index) {
                    final sub = lineup['subs'][index];
                    return Chip(
                      avatar: CircleAvatar(
                        backgroundColor: Colors.grey.shade200,
                        child: Text(sub['shirtNumber'] ?? ''),
                      ),
                      label: Text(sub['name']),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildFormationPositions(List<dynamic> players, Size fieldSize) {
    final List<Widget> playerWidgets = [];

    for (final player in players) {
      if (player == null || player['horizontalLayout'] == null) {
        continue;
      }

      final horizontalLayout = player['horizontalLayout'];
      final double? x = (horizontalLayout['x'] as num?)?.toDouble();
      final double? y = (horizontalLayout['y'] as num?)?.toDouble();

      if (x == null || y == null) {
        continue;
      }

      // Fixed player widget size that works well
      final double playerWidgetWidth = 70.0;
      final double playerWidgetHeight = 85.0;
      final double avatarRadius = 18.0;

      // Calculate actual screen positions with bounds checking
      final double left = ((x * fieldSize.width) - (playerWidgetWidth / 2))
          .clamp(5.0, fieldSize.width - playerWidgetWidth - 5);
      final double top = ((y * fieldSize.height) - (playerWidgetHeight / 2))
          .clamp(5.0, fieldSize.height - playerWidgetHeight - 5);

      Color positionColor = _getPositionColor(
        player['positionId'] as int? ?? 0,
      );
      String shirtNumber = player['shirtNumber']?.toString() ?? '';
      String playerName = player['name'] ?? 'Unknown';
      bool isCaptain = player['isCaptain'] == true;

      // Get first name only to save space
      String displayName = playerName.split(' ').first;

      double? rating;
      if (player['performance'] != null &&
          player['performance']['rating'] != null) {
        rating = (player['performance']['rating'] as num?)?.toDouble();
      }

      playerWidgets.add(
        Positioned(
          left: left,
          top: top,
          child: SizedBox(
            width: playerWidgetWidth,
            height: playerWidgetHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: avatarRadius,
                      backgroundColor: positionColor.withOpacity(0.9),
                    ),
                    CircleAvatar(
                      radius: avatarRadius - 3,
                      backgroundColor: Colors.white,
                      child: Text(
                        shirtNumber,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    if (isCaptain)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            'C',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 8,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    displayName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (rating != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getRatingColor(rating),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        rating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }
    return playerWidgets;
  }

  Color _getPositionColor(int positionId) {
    // Position IDs from sample data:
    // Goalkeeper: around 11
    // Defenders: 30-39
    // Midfielders: 70-79
    // Forwards: 100+

    if (positionId < 20) return Colors.yellow; // Goalkeeper
    if (positionId < 40) return Colors.blue; // Defender
    if (positionId < 80) return Colors.green; // Midfielder
    return Colors.red; // Forward
  }

  Color _getRatingColor(dynamic rating) {
    double numRating = double.tryParse(rating.toString()) ?? 5.0;
    if (numRating >= 8.0) return Colors.green.shade700;
    if (numRating >= 7.0) return Colors.green.shade500;
    if (numRating >= 6.0) return Colors.amber.shade700;
    return Colors.red.shade400;
  }
}

// Soccer field painter for custom field markings
class SoccerFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.7)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;

    // Center circle
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.15,
      paint,
    );

    // Center line
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );

    // Penalty areas
    final penaltyAreaWidth = size.width * 0.6;
    final penaltyAreaHeight = size.height * 0.2;

    // Top penalty area
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width / 2, penaltyAreaHeight / 2),
        width: penaltyAreaWidth,
        height: penaltyAreaHeight,
      ),
      paint,
    );

    // Bottom penalty area
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height - penaltyAreaHeight / 2),
        width: penaltyAreaWidth,
        height: penaltyAreaHeight,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
