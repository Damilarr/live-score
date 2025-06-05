import 'package:json_annotation/json_annotation.dart';

part 'datamodel.g.dart';

@JsonSerializable()
class LeagueDetail {
  final int id;
  final String type,
      name,
      selectedSeason,
      latestSeason,
      shortName,
      country,
      leagueColor;
  LeagueDetail({
    required this.id,
    required this.type,
    required this.name,
    required this.country,
    required this.selectedSeason,
    required this.latestSeason,
    required this.leagueColor,
    required this.shortName,
  });
  factory LeagueDetail.fromJson(Map<String, dynamic> json) =>
      _$LeagueDetailFromJson(json);
  Map<String, dynamic> toJson() => _$LeagueDetailToJson(this);
}

@JsonSerializable()
class LeagueFixture {
  final String id;
  final Map<String, dynamic> opponent;
  final Map<String, dynamic> home;
  final Map<String, dynamic> away;
  final bool notStarted;
  final Map<String, dynamic> status;
  LeagueFixture({
    required this.id,
    required this.opponent,
    required this.home,
    required this.away,
    required this.notStarted,
    required this.status,
  });
  factory LeagueFixture.fromJson(Map<String, dynamic> json) =>
      _$LeagueFixtureFromJson(json);
  Map<String, dynamic> toJson() => _$LeagueFixtureToJson(this);
}

@JsonSerializable()
class LeagueStanding {
  final String? name, shortName, pageUrl, scoresStr, qualColor;
  final int? id, played, wins, draws, losses, goalConDiff, pts, idx;
  final int? deduction;
  final bool? ongoing;
  LeagueStanding({
    required this.deduction,
    required this.draws,
    required this.goalConDiff,
    required this.id,
    required this.idx,
    required this.losses,
    required this.name,
    required this.ongoing,
    required this.pageUrl,
    required this.played,
    required this.pts,
    required this.qualColor,
    required this.scoresStr,
    required this.shortName,
    required this.wins,
  });
  factory LeagueStanding.fromJson(Map<String, dynamic> json) =>
      _$LeagueStandingFromJson(json);
  Map<String, dynamic> toJson() => _$LeagueStandingToJson(this);
}

@JsonSerializable()
class LeagueFixturesByDate {
  final String ccode, name;
  final int id, primaryId;
  final List matches;
  LeagueFixturesByDate({
    required this.ccode,
    required this.name,
    required this.id,
    required this.primaryId,
    required this.matches,
  });
  factory LeagueFixturesByDate.fromJson(Map<String, dynamic> json) =>
      _$LeagueFixturesByDateFromJson(json);
  Map<String, dynamic> toJson() => _$LeagueFixturesByDateToJson(this);
}

@JsonSerializable()
class LiveMatch {
  final int id;
  final int leagueId;
  final TeamData home;
  final TeamData away;
  final String tournamentStage;
  final MatchStatus status;

  LiveMatch({
    required this.id,
    required this.leagueId,
    required this.home,
    required this.away,
    required this.tournamentStage,
    required this.status,
  });

  factory LiveMatch.fromJson(Map<String, dynamic> json) =>
      _$LiveMatchFromJson(json);
  Map<String, dynamic> toJson() => _$LiveMatchToJson(this);
}

@JsonSerializable()
class TeamData {
  final int id;
  final int score;
  final String name;
  final String longName;

  TeamData({
    required this.id,
    required this.score,
    required this.name,
    required this.longName,
  });

  factory TeamData.fromJson(Map<String, dynamic> json) =>
      _$TeamDataFromJson(json);
  Map<String, dynamic> toJson() => _$TeamDataToJson(this);
}

@JsonSerializable()
class MatchStatus {
  final String scoreStr;
  final LiveTime liveTime;
  final bool ongoing;
  final bool finished;

  MatchStatus({
    required this.scoreStr,
    required this.liveTime,
    required this.ongoing,
    required this.finished,
  });

  factory MatchStatus.fromJson(Map<String, dynamic> json) =>
      _$MatchStatusFromJson(json);
  Map<String, dynamic> toJson() => _$MatchStatusToJson(this);
}

@JsonSerializable()
class LiveTime {
  final String short;
  final String long;
  final int maxTime;
  final int addedTime;

  LiveTime({
    required this.short,
    required this.long,
    required this.maxTime,
    required this.addedTime,
  });

  factory LiveTime.fromJson(Map<String, dynamic> json) =>
      _$LiveTimeFromJson(json);
  Map<String, dynamic> toJson() => _$LiveTimeToJson(this);
}
