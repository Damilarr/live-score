// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datamodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeagueDetail _$LeagueDetailFromJson(Map<String, dynamic> json) => LeagueDetail(
  id: (json['id'] as num).toInt(),
  type: json['type'] as String,
  name: json['name'] as String,
  country: json['country'] as String,
  selectedSeason: json['selectedSeason'] as String,
  latestSeason: json['latestSeason'] as String,
  leagueColor: json['leagueColor'] as String,
  shortName: json['shortName'] as String,
);

Map<String, dynamic> _$LeagueDetailToJson(LeagueDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'selectedSeason': instance.selectedSeason,
      'latestSeason': instance.latestSeason,
      'shortName': instance.shortName,
      'country': instance.country,
      'leagueColor': instance.leagueColor,
    };

LeagueFixture _$LeagueFixtureFromJson(Map<String, dynamic> json) =>
    LeagueFixture(
      id: json['id'] as String,
      opponent: json['opponent'] as Map<String, dynamic>,
      home: json['home'] as Map<String, dynamic>,
      away: json['away'] as Map<String, dynamic>,
      notStarted: json['notStarted'] as bool,
      status: json['status'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$LeagueFixtureToJson(LeagueFixture instance) =>
    <String, dynamic>{
      'id': instance.id,
      'opponent': instance.opponent,
      'home': instance.home,
      'away': instance.away,
      'notStarted': instance.notStarted,
      'status': instance.status,
    };

LeagueStanding _$LeagueStandingFromJson(Map<String, dynamic> json) =>
    LeagueStanding(
      deduction: (json['deduction'] as num?)?.toInt(),
      draws: (json['draws'] as num?)?.toInt(),
      goalConDiff: (json['goalConDiff'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      idx: (json['idx'] as num?)?.toInt(),
      losses: (json['losses'] as num?)?.toInt(),
      name: json['name'] as String?,
      ongoing: json['ongoing'] as bool?,
      pageUrl: json['pageUrl'] as String?,
      played: (json['played'] as num?)?.toInt(),
      pts: (json['pts'] as num?)?.toInt(),
      qualColor: json['qualColor'] as String?,
      scoresStr: json['scoresStr'] as String?,
      shortName: json['shortName'] as String?,
      wins: (json['wins'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LeagueStandingToJson(LeagueStanding instance) =>
    <String, dynamic>{
      'name': instance.name,
      'shortName': instance.shortName,
      'pageUrl': instance.pageUrl,
      'scoresStr': instance.scoresStr,
      'qualColor': instance.qualColor,
      'id': instance.id,
      'played': instance.played,
      'wins': instance.wins,
      'draws': instance.draws,
      'losses': instance.losses,
      'goalConDiff': instance.goalConDiff,
      'pts': instance.pts,
      'idx': instance.idx,
      'deduction': instance.deduction,
      'ongoing': instance.ongoing,
    };

LeagueFixturesByDate _$LeagueFixturesByDateFromJson(
  Map<String, dynamic> json,
) => LeagueFixturesByDate(
  ccode: json['ccode'] as String,
  name: json['name'] as String,
  id: (json['id'] as num).toInt(),
  primaryId: (json['primaryId'] as num).toInt(),
  matches: json['matches'] as List<dynamic>,
);

Map<String, dynamic> _$LeagueFixturesByDateToJson(
  LeagueFixturesByDate instance,
) => <String, dynamic>{
  'ccode': instance.ccode,
  'name': instance.name,
  'id': instance.id,
  'primaryId': instance.primaryId,
  'matches': instance.matches,
};

LiveMatch _$LiveMatchFromJson(Map<String, dynamic> json) => LiveMatch(
  id: (json['id'] as num).toInt(),
  leagueId: (json['leagueId'] as num).toInt(),
  home: TeamData.fromJson(json['home'] as Map<String, dynamic>),
  away: TeamData.fromJson(json['away'] as Map<String, dynamic>),
  tournamentStage: json['tournamentStage'] as String,
  status: MatchStatus.fromJson(json['status'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LiveMatchToJson(LiveMatch instance) => <String, dynamic>{
  'id': instance.id,
  'leagueId': instance.leagueId,
  'home': instance.home,
  'away': instance.away,
  'tournamentStage': instance.tournamentStage,
  'status': instance.status,
};

TeamData _$TeamDataFromJson(Map<String, dynamic> json) => TeamData(
  id: (json['id'] as num).toInt(),
  score: (json['score'] as num).toInt(),
  name: json['name'] as String,
  longName: json['longName'] as String,
);

Map<String, dynamic> _$TeamDataToJson(TeamData instance) => <String, dynamic>{
  'id': instance.id,
  'score': instance.score,
  'name': instance.name,
  'longName': instance.longName,
};

MatchStatus _$MatchStatusFromJson(Map<String, dynamic> json) => MatchStatus(
  scoreStr: json['scoreStr'] as String,
  liveTime: LiveTime.fromJson(json['liveTime'] as Map<String, dynamic>),
  ongoing: json['ongoing'] as bool,
  finished: json['finished'] as bool,
);

Map<String, dynamic> _$MatchStatusToJson(MatchStatus instance) =>
    <String, dynamic>{
      'scoreStr': instance.scoreStr,
      'liveTime': instance.liveTime,
      'ongoing': instance.ongoing,
      'finished': instance.finished,
    };

LiveTime _$LiveTimeFromJson(Map<String, dynamic> json) => LiveTime(
  short: json['short'] as String,
  long: json['long'] as String,
  maxTime: (json['maxTime'] as num).toInt(),
  addedTime: (json['addedTime'] as num).toInt(),
);

Map<String, dynamic> _$LiveTimeToJson(LiveTime instance) => <String, dynamic>{
  'short': instance.short,
  'long': instance.long,
  'maxTime': instance.maxTime,
  'addedTime': instance.addedTime,
};
