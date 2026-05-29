// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Darts';

  @override
  String get homeTitle => 'The Tavern';

  @override
  String get homeSubtitle => 'Welcome';

  @override
  String get newGame => 'New game';

  @override
  String get history => 'History';

  @override
  String get stats => 'Statistics';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get players => 'Players';

  @override
  String get addPlayer => 'Add player';

  @override
  String get searchPlayer => 'Search player…';

  @override
  String get createPlayer => 'Create player';

  @override
  String get createNewPlayer => 'Create a new player';

  @override
  String get create => 'Create';

  @override
  String get playerName => 'Player name';

  @override
  String get handLeft => 'Left';

  @override
  String get handRight => 'Right';

  @override
  String get startGame => 'Start game';

  @override
  String get round => 'Round';

  @override
  String roundLabel(int round) {
    return 'Round $round';
  }

  @override
  String get bust => 'BUST!';

  @override
  String get win => 'WIN!';

  @override
  String get validate => 'Validate';

  @override
  String get undo => 'Undo';

  @override
  String get miss => 'Miss';

  @override
  String get checkout => 'Checkout';

  @override
  String get score => 'Score';

  @override
  String get remaining => 'Remaining';

  @override
  String remainingPoints(int score) {
    return '$score remaining';
  }

  @override
  String get darts => 'Darts';

  @override
  String get doubleOut => 'Double out';

  @override
  String get mode301 => '301';

  @override
  String get mode501 => '501';

  @override
  String get modeCricket => 'Cricket';

  @override
  String get locked => 'Coming soon';

  @override
  String get winnerIs => 'Winner';

  @override
  String get finishedOn => 'Finished on';

  @override
  String get rematch => 'Rematch';

  @override
  String get newGameBtn => 'New game';

  @override
  String get homeBtn => 'Home';

  @override
  String get viewResults => 'View results';

  @override
  String get noCurrentGame => 'No game in progress';

  @override
  String get atLeastTwoPlayers => 'Add at least 2 players';

  @override
  String get gameDesc301 => '301 · double out';

  @override
  String get winRate => 'Win rate';

  @override
  String get ppd => 'PPD';

  @override
  String get bestTurn => 'Best turn';

  @override
  String get avgFinish => 'Avg finish';

  @override
  String get roundsPerGame => 'Rounds/game';

  @override
  String get doubleRate => 'Double rate';

  @override
  String get scores100plus => 'Scores 100+';

  @override
  String get tons180 => 'Tons 180';

  @override
  String get currentStreak => 'Current streak';

  @override
  String get totalGames => 'Games';

  @override
  String get totalWins => 'Wins';

  @override
  String get duration => 'Duration';

  @override
  String get all => 'All';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get thisWeek => 'This week';

  @override
  String get noGames => 'No games played';

  @override
  String get noPlayers => 'No players created';

  @override
  String get themePub => 'Pub room';

  @override
  String get themeBull => 'Bullseye';

  @override
  String get themeClassic => 'Classic';

  @override
  String get themeMin => 'Target';

  @override
  String get turn => 'Turn';

  @override
  String get seasonLeaderboard => 'Season leaderboard';

  @override
  String get lastGame => 'Last game';

  @override
  String get rank => 'Rank';

  @override
  String get name => 'Name';

  @override
  String get victories => 'W';

  @override
  String get vs => 'vs';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get confirmDelete => 'Delete this player?';

  @override
  String get irreversibleAction => 'This action is irreversible.';

  @override
  String get colorPicker => 'Color';

  @override
  String get hand => 'Hand';

  @override
  String get recentGames => 'Recent games';

  @override
  String get winBadge => 'W';

  @override
  String get lossBadge => 'L';

  @override
  String get dartsThrown => 'Darts thrown';

  @override
  String get lastDart => 'Last dart';

  @override
  String get ppdTooltip => 'Points per dart';

  @override
  String get bestTurnTooltip => 'Highest score in one turn';

  @override
  String get doubleRateTooltip => 'Doubles hit / attempted';

  @override
  String get totalWinsTooltip => 'Total wins';

  @override
  String get totalGamesTooltip => 'Total games played';

  @override
  String get scores100plusTooltip => 'Turns with 100+ points';

  @override
  String get tons180Tooltip => 'Perfect 180 scores';

  @override
  String get currentStreakTooltip => 'Consecutive wins';
}
