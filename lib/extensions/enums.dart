import '../constants/strings.dart';

enum MessageReason {
  bugReport(Strings.bugReport),
  featureRequest(Strings.featureRequest),
  wrongData(Strings.wrongData),
  partnership(Strings.partnership),
  other(Strings.other);

  final String asString;

  const MessageReason(this.asString);
}

////////////////////////////
enum FixtureEventType {
  goal('Card', 'Card'),
  card('Goal', 'Goal'),
  subst('subst', 'Substitution'),
  vidAR('Var', 'Var');

  final String asString;
  final String fullName;

  const FixtureEventType(this.asString, this.fullName);
}

FixtureEventType? fixtureEventTypeFromString(String? type) {
  switch (type) {
    case 'Card':
      return FixtureEventType.card;
    case 'Goal':
      return FixtureEventType.goal;
    case 'subst':
      return FixtureEventType.subst;
    case 'Var':
      return FixtureEventType.vidAR;
    default:
      return null;
  }
}

////////////////////////////
enum FixtureEventDetail {
  normalGoal('Normal Goal'),
  yellowCard('Yellow Card'),
  substitution1('Substitution 1'),
  substitution2('Substitution 2'),
  substitution3('Substitution 3'),
  substitution4('Substitution 4'),
  substitution5('Substitution 5'),
  substitution6('Substitution 6'),
  substitution7('Substitution 7'),
  substitution8('Substitution 8'),
  substitution9('Substitution 9'),
  substitution10('Substitution 10'),
  redCard('Red Card'),
  penalty('Penalty'),
  missedPenalty('Missed Penalty'),
  ownGoal('Own Goal');

  final String asString;

  const FixtureEventDetail(this.asString);
}

FixtureEventDetail? eventDetailFromString(String? detail) {
  switch (detail) {
    case 'Normal Goal':
      return FixtureEventDetail.normalGoal;
    case 'Yellow Card':
      return FixtureEventDetail.yellowCard;
    case 'Substitution 1':
      return FixtureEventDetail.substitution1;
    case 'Substitution 2':
      return FixtureEventDetail.substitution2;
    case 'Substitution 3':
      return FixtureEventDetail.substitution3;
    case 'Substitution 4':
      return FixtureEventDetail.substitution4;
    case 'Substitution 5':
      return FixtureEventDetail.substitution5;
    case 'Substitution 6':
      return FixtureEventDetail.substitution6;
    case 'Substitution 7':
      return FixtureEventDetail.substitution7;
    case 'Substitution 8':
      return FixtureEventDetail.substitution8;
    case 'Substitution 9':
      return FixtureEventDetail.substitution9;
    case 'Substitution 10':
      return FixtureEventDetail.substitution10;
    case 'Red Card':
      return FixtureEventDetail.redCard;
    case 'Penalty':
      return FixtureEventDetail.penalty;
    case 'Missed Penalty':
      return FixtureEventDetail.missedPenalty;
    case 'Own Goal':
      return FixtureEventDetail.ownGoal;
    default:
      return null;
  }
}

////////////////////////////
enum FixtureStatusLong {
  timeToBeDefined('Time to be Defined', 'Scheduled but date and time are not known'),
  notStarted('Not Started', 'Match not started yet'),
  firstHalfKickOff('First Half', 'First half in play'),
  halftime('Halftime', 'Halftime break'),
  secondHalf2NdHalf('Second Half', 'Second half in play'),
  extraTime('Extra Time', 'Extra time in play'),
  breakTime('Break Time', 'Break during extra time'),
  penaltyInProgress('Penalty In Progress', 'Penalty played after extra time'),
  matchSuspended(
      'Match Suspended', 'Suspended by referee\'s decision, may be rescheduled another day'),
  matchInterrupted(
      'Match Interrupted', 'Interrupted by referee\'s decision, should resume in a few minutes'),
  matchFinished('Match Finished', 'Match finished in the regular time'),
  matchFinishedAfterExtraTime('Match Finished After Extra Time',
      'Match finished after extra time without going to the penalty shootout'),
  matchFinishedAfterPenalty(
      'Match Finished After Penalty', 'Match finished after the penalty shootout'),
  matchPostponed('Match Postponed',
      'Postponed to another day, once the new date and time is known the status will change to Not Started'),
  matchCancelled('Match Cancelled', 'Cancelled, match will not be played'),
  matchAbandoned('Match Abandoned',
      'Abandoned for various reasons (Bad Weather, Safety, Floodlights, Playing Staff Or Referees), Can be rescheduled or not, it depends on the competition'),
  technicalLoss('Technical Loss', 'Technical loss'),
  walkOver('WalkOver', 'Victory by forfeit or absence of competitor'),
  inProgress('In Progress',
      'Match in progress but the data indicating the half-time or elapsed time are not available');

  final String asString;
  final String description;

  const FixtureStatusLong(this.asString, this.description);
}

FixtureStatusLong fixtureStatusLongFromString(String? status) {
  switch (status) {
    case 'Time to be defined':
      return FixtureStatusLong.timeToBeDefined;
    case 'Not Started':
      return FixtureStatusLong.notStarted;
    case 'First Half':
      return FixtureStatusLong.firstHalfKickOff;
    case 'Halftime':
      return FixtureStatusLong.halftime;
    case 'Second Half':
      return FixtureStatusLong.secondHalf2NdHalf;
    case 'Extra Time':
      return FixtureStatusLong.extraTime;
    case 'Break Time':
      return FixtureStatusLong.breakTime;
    case 'Penalty In Progress':
      return FixtureStatusLong.penaltyInProgress;
    case 'Match Suspended':
      return FixtureStatusLong.matchSuspended;
    case 'Match Interrupted':
      return FixtureStatusLong.matchInterrupted;
    case 'Match Finished':
      return FixtureStatusLong.matchFinished;
    case 'Match Finished After Extra Time':
      return FixtureStatusLong.matchFinishedAfterExtraTime;
    case 'Match Finished After Penalty':
      return FixtureStatusLong.matchFinishedAfterPenalty;
    case 'Match Postponed':
      return FixtureStatusLong.matchPostponed;
    case 'Match Cancelled':
      return FixtureStatusLong.matchCancelled;
    case 'Match Abandoned':
      return FixtureStatusLong.matchAbandoned;
    case 'Technical loss':
      return FixtureStatusLong.technicalLoss;
    case 'WalkOver':
      return FixtureStatusLong.walkOver;
    case 'In Progress':
      return FixtureStatusLong.inProgress;
    default:
      return FixtureStatusLong.notStarted;
  }
}

/*
TBD		Time To Be Defined		            Scheduled		Scheduled but date and time are not known
NS		Not Started		                    Scheduled
1H		First Half, Kick Off		          In Play		  First half in play
HT		Halftime		                      In Play		  Finished in the regular time
2H		Second Half, 2nd Half             Started		  In Play		Second half in play
ET		Extra Time		                    In Play		  Extra time in play
BT		Break Time		                    In Play		  Break during extra time
P		  Penalty In Progress		            In Play		  Penaly played after extra time
SUSP	Match Suspended		                In Play		  Suspended by referee's decision, may be rescheduled another day
INT		Match Interrupted		              In Play		  Interrupted by referee's decision, should resume in a few minutes
FT		Match Finished		                Finished		Finished in the regular time
AET		Match Finished After Extra Time		Finished		Finished after extra time without going to the penalty shootout
PEN		Match Finished After Penalty		  Finished		Finished after the penalty shootout
PST		Match Postponed		                Postponed		Postponed to another day, once the new date and time is known the status will change to Not Started
CANC	Match Cancelled		                Cancelled		Cancelled, match will not be played
ABD		Match Abandoned		                Abandoned		Abandoned for various reasons (Bad Weather, Safety, Floodlights, Playing Staff Or Referees), Can be rescheduled or not, it depends on the competition
AWD		Technical Loss		                Not Played
WO		WalkOver		                      Not Played	Victory by forfeit or absence of competitor
LIVE	In Progress		                    In Play		  Used in very rare cases. It indicates a fixture in progress but the data indicating the half-time or elapsed time are not available
* */

////////////////////////////
enum FixtureStatusShort {
  tbd('TBD'),
  ns('NS'),
  oneH('1H'),
  ht('HT'),
  twoH('2H'),
  et('ET'),
  bt('BT'),
  P('P'),
  susp('SUSP'),
  int('INT'),
  ft('FT'),
  aet('AET'),
  pen('PEN'),
  pst('PST'),
  canc('CANC'),
  abd('ABD'),
  awd('AWD'),
  wo('WO'),
  live('LIVE');

  final String asString;

  const FixtureStatusShort(this.asString);
}

FixtureStatusShort fixtureStatusShortFromString(String? status) {
  switch (status) {
    case 'TBD':
      return FixtureStatusShort.tbd;
    case 'NS':
      return FixtureStatusShort.ns;
    case '1H':
      return FixtureStatusShort.oneH;
    case 'HT':
      return FixtureStatusShort.ht;
    case '2H':
      return FixtureStatusShort.twoH;
    case 'ET':
      return FixtureStatusShort.et;
    case 'BT':
      return FixtureStatusShort.bt;
    case 'P':
      return FixtureStatusShort.P;
    case 'SUSP':
      return FixtureStatusShort.susp;
    case 'INT':
      return FixtureStatusShort.int;
    case 'FT':
      return FixtureStatusShort.ft;
    case 'AET':
      return FixtureStatusShort.aet;
    case 'PEN':
      return FixtureStatusShort.pen;
    case 'PST':
      return FixtureStatusShort.pst;
    case 'CANC':
      return FixtureStatusShort.canc;
    case 'ABD':
      return FixtureStatusShort.abd;
    case 'AWD':
      return FixtureStatusShort.awd;
    case 'WO':
      return FixtureStatusShort.wo;
    case 'LIVE':
      return FixtureStatusShort.live;
    default:
      return FixtureStatusShort.ns;
  }
}

////////////////////////////
enum PlayerPosition {
  G('G', 'Goal Keeper'),
  D('D', 'Defender'),
  M('M', 'Midfielder'),
  F('F', 'Attacker');

  final String shortName;
  final String longName;

  const PlayerPosition(this.shortName, this.longName);
}

PlayerPosition? playerPositionShortFromString(String? position) {
  switch (position) {
    case 'D':
      return PlayerPosition.D;
    case 'F':
      return PlayerPosition.F;
    case 'G':
      return PlayerPosition.G;
    case 'M':
      return PlayerPosition.M;
    default:
      return null;
  }
}

////////////////////////////
enum ExpandableTextEvent { nonExpandable, expanded, collapsed }

////////////////////////////
enum StandingStatsType { all, home, away }

enum StandingTableType { full, short, form }

////////////////////////////
enum AuthenticationStatus { guest, authenticated, unauthenticated }
