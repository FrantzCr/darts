// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get appTitle => 'Dart';

  @override
  String get homeTitle => 'Kroen';

  @override
  String get homeSubtitle => 'Velkommen';

  @override
  String get newGame => 'Nyt spil';

  @override
  String get history => 'Historik';

  @override
  String get stats => 'Statistik';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'Indstillinger';

  @override
  String get players => 'Spillere';

  @override
  String get addPlayer => 'Tilføj spiller';

  @override
  String get searchPlayer => 'Søg spiller…';

  @override
  String get createPlayer => 'Opret spiller';

  @override
  String get createNewPlayer => 'Opret en ny spiller';

  @override
  String get create => 'Opret';

  @override
  String get playerName => 'Spillernavn';

  @override
  String get handLeft => 'Venstre';

  @override
  String get handRight => 'Højre';

  @override
  String get startGame => 'Start spil';

  @override
  String get round => 'Runde';

  @override
  String roundLabel(int round) {
    return 'Runde $round';
  }

  @override
  String get bust => 'FOR MEGET!';

  @override
  String get win => 'SEJR!';

  @override
  String get validate => 'Godkend';

  @override
  String get undo => 'Fortryd';

  @override
  String get miss => 'Forbi';

  @override
  String get checkout => 'Afslutning';

  @override
  String get score => 'Score';

  @override
  String get remaining => 'Tilbage';

  @override
  String remainingPoints(int score) {
    return '$score tilbage';
  }

  @override
  String get darts => 'Pile';

  @override
  String get doubleOut => 'Dobbelt ud';

  @override
  String get mode301 => '301';

  @override
  String get mode501 => '501';

  @override
  String get modeCricket => 'Cricket';

  @override
  String get locked => 'Kommer snart';

  @override
  String get winnerIs => 'Vinder';

  @override
  String get finishedOn => 'Afsluttede med';

  @override
  String get rematch => 'Revanche';

  @override
  String get newGameBtn => 'Nyt spil';

  @override
  String get homeBtn => 'Hjem';

  @override
  String get viewResults => 'Se resultater';

  @override
  String get noCurrentGame => 'Intet spil i gang';

  @override
  String get atLeastTwoPlayers => 'Tilføj mindst 2 spillere';

  @override
  String get gameDesc301 => 'Vælg din spiltype';

  @override
  String get winRate => 'Vinderprocent';

  @override
  String get ppd => 'PPD';

  @override
  String get bestTurn => 'Bedste tur';

  @override
  String get avgFinish => 'Gns. afslutning';

  @override
  String get roundsPerGame => 'Runder/spil';

  @override
  String get doubleRate => 'Dobbeltprocent';

  @override
  String get scores100plus => 'Scores 100+';

  @override
  String get tons180 => 'Tons 180';

  @override
  String get currentStreak => 'Aktuel serie';

  @override
  String get totalGames => 'Spil';

  @override
  String get totalWins => 'Sejre';

  @override
  String get duration => 'Varighed';

  @override
  String get all => 'Alle';

  @override
  String get today => 'I dag';

  @override
  String get yesterday => 'I går';

  @override
  String get thisWeek => 'Denne uge';

  @override
  String get noGames => 'Ingen spil spillet';

  @override
  String get noPlayers => 'Ingen spillere oprettet';

  @override
  String get themePub => 'Pubrum';

  @override
  String get themeBull => 'Bullseye';

  @override
  String get themeClassic => 'Klassisk';

  @override
  String get themeMin => 'Skive';

  @override
  String get turn => 'Tur';

  @override
  String get seasonLeaderboard => 'Sæsonrangliste';

  @override
  String get lastGame => 'Sidste spil';

  @override
  String get rank => 'Placering';

  @override
  String get name => 'Navn';

  @override
  String get victories => 'S';

  @override
  String get vs => 'vs';

  @override
  String get cancel => 'Annuller';

  @override
  String get save => 'Gem';

  @override
  String get delete => 'Slet';

  @override
  String get confirmDelete => 'Slet denne spiller?';

  @override
  String get irreversibleAction => 'Denne handling kan ikke fortrydes.';

  @override
  String get colorPicker => 'Farve';

  @override
  String get initials => 'Initialer';

  @override
  String get hand => 'Hånd';

  @override
  String get recentGames => 'Seneste spil';

  @override
  String get winBadge => 'S';

  @override
  String get lossBadge => 'T';

  @override
  String get dartsThrown => 'Pile kastet';

  @override
  String get lastDart => 'Sidste pil';

  @override
  String get ppdTooltip => 'Point pr. pil';

  @override
  String get bestTurnTooltip => 'Højeste score i én tur';

  @override
  String get doubleRateTooltip => 'Dobler ramt / forsøgt';

  @override
  String get totalWinsTooltip => 'Sejre i alt';

  @override
  String get totalGamesTooltip => 'Spil i alt';

  @override
  String get scores100plusTooltip => 'Ture med 100+ point';

  @override
  String get tons180Tooltip => 'Perfekte 180-scores';

  @override
  String get currentStreakTooltip => 'Sejre i træk';

  @override
  String get activeGamesTitle => 'Aktive spil';

  @override
  String get notSignedInBroadcast => 'Ikke logget ind — spil vises ikke live';

  @override
  String get joinByCode => 'Tilmeld med kode';

  @override
  String get codeBtnLabel => 'Kode';

  @override
  String codeNotFound(String code) {
    return 'Kode ikke fundet: $code';
  }

  @override
  String get join => 'Tilmeld';

  @override
  String get connectionError => 'Forbindelsesfejl';

  @override
  String get startGameToAppear => 'Start et spil for at det vises her';

  @override
  String get signInToStream => 'Log ind og start et spil for at streame det';

  @override
  String byHost(String host) {
    return 'Af $host';
  }

  @override
  String get rematchOrderTitle => 'Spillerrækkefølge';

  @override
  String get dragToReorder => 'Træk for at omplacere';

  @override
  String get gagesSection => 'Bøder';

  @override
  String get wheelEnabled => 'Hjul med bøder';

  @override
  String get wheelMode => 'Tilstand';

  @override
  String get wheelModeFamily => 'Alle aldre';

  @override
  String get wheelModeAdult => '18+';

  @override
  String get manageGages => 'Administrer bøder';

  @override
  String get addGage => 'Tilføj bøde';

  @override
  String get editGage => 'Rediger bøde';

  @override
  String get gageHint => 'Beskriv bøden…';

  @override
  String get adultGage => '18+ bøde';

  @override
  String get noGagesConfigured => 'Ingen bøder — tryk + for at tilføje';

  @override
  String get spinInstruction => 'Stryg for at dreje';

  @override
  String get yourForfeit => 'Din bøde!';

  @override
  String get continueGame => 'Afsted!';

  @override
  String get accountSection => 'Konto';

  @override
  String get languageSection => 'Sprog';

  @override
  String get appearanceSection => 'Udseende';

  @override
  String get signInWithGoogle => 'Log ind med Google';

  @override
  String get signOut => 'Log ud';

  @override
  String get defaultUsername => 'Bruger';

  @override
  String get finishOnDouble => 'Afslut på en dobbelt';
}
