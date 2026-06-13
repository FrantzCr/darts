// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Fléchettes';

  @override
  String get homeTitle => 'La Taverne';

  @override
  String get homeSubtitle => 'Bienvenue';

  @override
  String get newGame => 'Nouvelle partie';

  @override
  String get history => 'Historique';

  @override
  String get stats => 'Statistiques';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'Paramètres';

  @override
  String get players => 'Joueurs';

  @override
  String get addPlayer => 'Ajouter un joueur';

  @override
  String get searchPlayer => 'Rechercher un joueur…';

  @override
  String get createPlayer => 'Créer un joueur';

  @override
  String get createNewPlayer => 'Créer un nouveau joueur';

  @override
  String get create => 'Créer';

  @override
  String get playerName => 'Nom du joueur';

  @override
  String get handLeft => 'Gauche';

  @override
  String get handRight => 'Droite';

  @override
  String get startGame => 'Lancer la partie';

  @override
  String get round => 'Manche';

  @override
  String roundLabel(int round) {
    return 'Manche $round';
  }

  @override
  String get bust => 'RATÉ !';

  @override
  String get win => 'VICTOIRE !';

  @override
  String get validate => 'Valider';

  @override
  String get undo => 'Annuler';

  @override
  String get miss => 'Manqué';

  @override
  String get checkout => 'Finition';

  @override
  String get score => 'Score';

  @override
  String get remaining => 'Restant';

  @override
  String remainingPoints(int score) {
    return '$score restant';
  }

  @override
  String get darts => 'Fléchettes';

  @override
  String get doubleOut => 'Double sortie';

  @override
  String get mode301 => '301';

  @override
  String get mode501 => '501';

  @override
  String get modeCricket => 'Cricket';

  @override
  String get locked => 'Bientôt';

  @override
  String get winnerIs => 'Vainqueur';

  @override
  String get finishedOn => 'Finit sur';

  @override
  String get rematch => 'Revanche';

  @override
  String get newGameBtn => 'Nouvelle partie';

  @override
  String get homeBtn => 'Accueil';

  @override
  String get viewResults => 'Voir les résultats';

  @override
  String get noCurrentGame => 'Aucune partie en cours';

  @override
  String get atLeastTwoPlayers => 'Ajoutez au moins 2 joueurs';

  @override
  String get gameDesc301 => 'Choisir son mode de jeu';

  @override
  String get winRate => 'Taux de victoire';

  @override
  String get ppd => 'PPD';

  @override
  String get bestTurn => 'Meilleur tour';

  @override
  String get avgFinish => 'Finition moy.';

  @override
  String get roundsPerGame => 'Tours / partie';

  @override
  String get doubleRate => 'Taux doubles';

  @override
  String get scores100plus => 'Scores 100+';

  @override
  String get tons180 => 'Tons 180';

  @override
  String get currentStreak => 'Série en cours';

  @override
  String get totalGames => 'Parties';

  @override
  String get totalWins => 'Victoires';

  @override
  String get duration => 'Durée';

  @override
  String get all => 'Tout';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get thisWeek => 'Cette semaine';

  @override
  String get noGames => 'Aucune partie jouée';

  @override
  String get noPlayers => 'Aucun joueur créé';

  @override
  String get themePub => 'Salle de pub';

  @override
  String get themeBull => 'Bullseye';

  @override
  String get themeClassic => 'Classique';

  @override
  String get themeMin => 'Cible';

  @override
  String get turn => 'Tour';

  @override
  String get seasonLeaderboard => 'Classement de la saison';

  @override
  String get lastGame => 'Dernière partie';

  @override
  String get rank => 'Rang';

  @override
  String get name => 'Nom';

  @override
  String get victories => 'V';

  @override
  String get vs => 'vs';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get delete => 'Supprimer';

  @override
  String get confirmDelete => 'Supprimer ce joueur ?';

  @override
  String get irreversibleAction => 'Cette action est irréversible.';

  @override
  String get colorPicker => 'Couleur';

  @override
  String get initials => 'Initiales';

  @override
  String get hand => 'Main';

  @override
  String get recentGames => 'Parties récentes';

  @override
  String get winBadge => 'V';

  @override
  String get lossBadge => 'D';

  @override
  String get dartsThrown => 'Fléchettes lancées';

  @override
  String get lastDart => 'Dernière fléchette';

  @override
  String get ppdTooltip => 'Points par fléchette';

  @override
  String get bestTurnTooltip => 'Score le plus haut en un tour';

  @override
  String get doubleRateTooltip => 'Doubles réussis / tentés';

  @override
  String get totalWinsTooltip => 'Total victoires';

  @override
  String get totalGamesTooltip => 'Total parties jouées';

  @override
  String get scores100plusTooltip => 'Tours avec 100+ points';

  @override
  String get tons180Tooltip => 'Scores parfaits 180';

  @override
  String get currentStreakTooltip => 'Victoires consécutives';

  @override
  String get activeGamesTitle => 'Parties en cours';

  @override
  String get notSignedInBroadcast =>
      'Non connecté — les parties ne seront pas diffusées';

  @override
  String get joinByCode => 'Rejoindre avec un code';

  @override
  String get codeBtnLabel => 'Code';

  @override
  String codeNotFound(String code) {
    return 'Code introuvable : $code';
  }

  @override
  String get join => 'Rejoindre';

  @override
  String get connectionError => 'Erreur de connexion';

  @override
  String get startGameToAppear =>
      'Lance une partie pour qu\'elle apparaisse ici';

  @override
  String get signInToStream =>
      'Connectez-vous et lancez une partie pour la diffuser';

  @override
  String byHost(String host) {
    return 'Par $host';
  }

  @override
  String get rematchOrderTitle => 'Ordre de jeu';

  @override
  String get dragToReorder => 'Faites glisser pour réorganiser';

  @override
  String get gagesSection => 'Gages';

  @override
  String get wheelEnabled => 'Roue des gages';

  @override
  String get wheelMode => 'Mode';

  @override
  String get wheelModeFamily => 'Tout public';

  @override
  String get wheelModeAdult => '18+';

  @override
  String get manageGages => 'Gérer les gages';

  @override
  String get addGage => 'Ajouter un gage';

  @override
  String get editGage => 'Modifier le gage';

  @override
  String get gageHint => 'Décris le gage…';

  @override
  String get adultGage => 'Gage 18+';

  @override
  String get noGagesConfigured => 'Aucun gage — appuyez sur + pour en ajouter';

  @override
  String get spinInstruction => 'Glisse pour faire tourner';

  @override
  String get yourForfeit => 'Ton gage !';

  @override
  String get continueGame => 'C\'est parti !';

  @override
  String get accountSection => 'Compte';

  @override
  String get languageSection => 'Langue';

  @override
  String get appearanceSection => 'Apparence';

  @override
  String get signInWithGoogle => 'Se connecter avec Google';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get defaultUsername => 'Utilisateur';

  @override
  String get finishOnDouble => 'Finir sur un double';
}
