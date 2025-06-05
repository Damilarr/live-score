import 'package:flutter/material.dart';
import 'package:live_score/leaguedetails/leaguedetails.dart';

class LeagueCard extends StatelessWidget {
  final String title, leagueUrlLogo;
  final int id;

  const LeagueCard({
    super.key,
    required this.id,
    required this.title,
    required this.leagueUrlLogo,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Leaguedetails(leagueId: id)),
        );
      },
      child: Container(
        width: 100,
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 50,
              width: 50,
              child: Image.network(
                leagueUrlLogo,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.sports_soccer, size: 40);
                },
              ),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
