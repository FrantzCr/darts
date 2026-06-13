import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_da.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('da'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'Fléchettes'**
  String get appTitle;

  /// No description provided for @homeTitle.
  ///
  /// In fr, this message translates to:
  /// **'La Taverne'**
  String get homeTitle;

  /// No description provided for @homeSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue'**
  String get homeSubtitle;

  /// No description provided for @newGame.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle partie'**
  String get newGame;

  /// No description provided for @history.
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get history;

  /// No description provided for @stats.
  ///
  /// In fr, this message translates to:
  /// **'Statistiques'**
  String get stats;

  /// No description provided for @profile.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settings;

  /// No description provided for @players.
  ///
  /// In fr, this message translates to:
  /// **'Joueurs'**
  String get players;

  /// No description provided for @addPlayer.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un joueur'**
  String get addPlayer;

  /// No description provided for @searchPlayer.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un joueur…'**
  String get searchPlayer;

  /// No description provided for @createPlayer.
  ///
  /// In fr, this message translates to:
  /// **'Créer un joueur'**
  String get createPlayer;

  /// No description provided for @createNewPlayer.
  ///
  /// In fr, this message translates to:
  /// **'Créer un nouveau joueur'**
  String get createNewPlayer;

  /// No description provided for @create.
  ///
  /// In fr, this message translates to:
  /// **'Créer'**
  String get create;

  /// No description provided for @playerName.
  ///
  /// In fr, this message translates to:
  /// **'Nom du joueur'**
  String get playerName;

  /// No description provided for @handLeft.
  ///
  /// In fr, this message translates to:
  /// **'Gauche'**
  String get handLeft;

  /// No description provided for @handRight.
  ///
  /// In fr, this message translates to:
  /// **'Droite'**
  String get handRight;

  /// No description provided for @startGame.
  ///
  /// In fr, this message translates to:
  /// **'Lancer la partie'**
  String get startGame;

  /// No description provided for @round.
  ///
  /// In fr, this message translates to:
  /// **'Manche'**
  String get round;

  /// No description provided for @roundLabel.
  ///
  /// In fr, this message translates to:
  /// **'Manche {round}'**
  String roundLabel(int round);

  /// No description provided for @bust.
  ///
  /// In fr, this message translates to:
  /// **'RATÉ !'**
  String get bust;

  /// No description provided for @win.
  ///
  /// In fr, this message translates to:
  /// **'VICTOIRE !'**
  String get win;

  /// No description provided for @validate.
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get validate;

  /// No description provided for @undo.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get undo;

  /// No description provided for @miss.
  ///
  /// In fr, this message translates to:
  /// **'Manqué'**
  String get miss;

  /// No description provided for @checkout.
  ///
  /// In fr, this message translates to:
  /// **'Finition'**
  String get checkout;

  /// No description provided for @score.
  ///
  /// In fr, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @remaining.
  ///
  /// In fr, this message translates to:
  /// **'Restant'**
  String get remaining;

  /// No description provided for @remainingPoints.
  ///
  /// In fr, this message translates to:
  /// **'{score} restant'**
  String remainingPoints(int score);

  /// No description provided for @darts.
  ///
  /// In fr, this message translates to:
  /// **'Fléchettes'**
  String get darts;

  /// No description provided for @doubleOut.
  ///
  /// In fr, this message translates to:
  /// **'Double sortie'**
  String get doubleOut;

  /// No description provided for @mode301.
  ///
  /// In fr, this message translates to:
  /// **'301'**
  String get mode301;

  /// No description provided for @mode501.
  ///
  /// In fr, this message translates to:
  /// **'501'**
  String get mode501;

  /// No description provided for @modeCricket.
  ///
  /// In fr, this message translates to:
  /// **'Cricket'**
  String get modeCricket;

  /// No description provided for @locked.
  ///
  /// In fr, this message translates to:
  /// **'Bientôt'**
  String get locked;

  /// No description provided for @winnerIs.
  ///
  /// In fr, this message translates to:
  /// **'Vainqueur'**
  String get winnerIs;

  /// No description provided for @finishedOn.
  ///
  /// In fr, this message translates to:
  /// **'Finit sur'**
  String get finishedOn;

  /// No description provided for @rematch.
  ///
  /// In fr, this message translates to:
  /// **'Revanche'**
  String get rematch;

  /// No description provided for @newGameBtn.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle partie'**
  String get newGameBtn;

  /// No description provided for @homeBtn.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get homeBtn;

  /// No description provided for @viewResults.
  ///
  /// In fr, this message translates to:
  /// **'Voir les résultats'**
  String get viewResults;

  /// No description provided for @noCurrentGame.
  ///
  /// In fr, this message translates to:
  /// **'Aucune partie en cours'**
  String get noCurrentGame;

  /// No description provided for @atLeastTwoPlayers.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez au moins 2 joueurs'**
  String get atLeastTwoPlayers;

  /// No description provided for @gameDesc301.
  ///
  /// In fr, this message translates to:
  /// **'Choisir son mode de jeu'**
  String get gameDesc301;

  /// No description provided for @winRate.
  ///
  /// In fr, this message translates to:
  /// **'Taux de victoire'**
  String get winRate;

  /// No description provided for @ppd.
  ///
  /// In fr, this message translates to:
  /// **'PPD'**
  String get ppd;

  /// No description provided for @bestTurn.
  ///
  /// In fr, this message translates to:
  /// **'Meilleur tour'**
  String get bestTurn;

  /// No description provided for @avgFinish.
  ///
  /// In fr, this message translates to:
  /// **'Finition moy.'**
  String get avgFinish;

  /// No description provided for @roundsPerGame.
  ///
  /// In fr, this message translates to:
  /// **'Tours / partie'**
  String get roundsPerGame;

  /// No description provided for @doubleRate.
  ///
  /// In fr, this message translates to:
  /// **'Taux doubles'**
  String get doubleRate;

  /// No description provided for @scores100plus.
  ///
  /// In fr, this message translates to:
  /// **'Scores 100+'**
  String get scores100plus;

  /// No description provided for @tons180.
  ///
  /// In fr, this message translates to:
  /// **'Tons 180'**
  String get tons180;

  /// No description provided for @currentStreak.
  ///
  /// In fr, this message translates to:
  /// **'Série en cours'**
  String get currentStreak;

  /// No description provided for @totalGames.
  ///
  /// In fr, this message translates to:
  /// **'Parties'**
  String get totalGames;

  /// No description provided for @totalWins.
  ///
  /// In fr, this message translates to:
  /// **'Victoires'**
  String get totalWins;

  /// No description provided for @duration.
  ///
  /// In fr, this message translates to:
  /// **'Durée'**
  String get duration;

  /// No description provided for @all.
  ///
  /// In fr, this message translates to:
  /// **'Tout'**
  String get all;

  /// No description provided for @today.
  ///
  /// In fr, this message translates to:
  /// **'Aujourd\'hui'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In fr, this message translates to:
  /// **'Hier'**
  String get yesterday;

  /// No description provided for @thisWeek.
  ///
  /// In fr, this message translates to:
  /// **'Cette semaine'**
  String get thisWeek;

  /// No description provided for @noGames.
  ///
  /// In fr, this message translates to:
  /// **'Aucune partie jouée'**
  String get noGames;

  /// No description provided for @noPlayers.
  ///
  /// In fr, this message translates to:
  /// **'Aucun joueur créé'**
  String get noPlayers;

  /// No description provided for @themePub.
  ///
  /// In fr, this message translates to:
  /// **'Salle de pub'**
  String get themePub;

  /// No description provided for @themeBull.
  ///
  /// In fr, this message translates to:
  /// **'Bullseye'**
  String get themeBull;

  /// No description provided for @themeClassic.
  ///
  /// In fr, this message translates to:
  /// **'Classique'**
  String get themeClassic;

  /// No description provided for @themeMin.
  ///
  /// In fr, this message translates to:
  /// **'Cible'**
  String get themeMin;

  /// No description provided for @turn.
  ///
  /// In fr, this message translates to:
  /// **'Tour'**
  String get turn;

  /// No description provided for @seasonLeaderboard.
  ///
  /// In fr, this message translates to:
  /// **'Classement de la saison'**
  String get seasonLeaderboard;

  /// No description provided for @lastGame.
  ///
  /// In fr, this message translates to:
  /// **'Dernière partie'**
  String get lastGame;

  /// No description provided for @rank.
  ///
  /// In fr, this message translates to:
  /// **'Rang'**
  String get rank;

  /// No description provided for @name.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get name;

  /// No description provided for @victories.
  ///
  /// In fr, this message translates to:
  /// **'V'**
  String get victories;

  /// No description provided for @vs.
  ///
  /// In fr, this message translates to:
  /// **'vs'**
  String get vs;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get delete;

  /// No description provided for @confirmDelete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer ce joueur ?'**
  String get confirmDelete;

  /// No description provided for @irreversibleAction.
  ///
  /// In fr, this message translates to:
  /// **'Cette action est irréversible.'**
  String get irreversibleAction;

  /// No description provided for @colorPicker.
  ///
  /// In fr, this message translates to:
  /// **'Couleur'**
  String get colorPicker;

  /// No description provided for @initials.
  ///
  /// In fr, this message translates to:
  /// **'Initiales'**
  String get initials;

  /// No description provided for @hand.
  ///
  /// In fr, this message translates to:
  /// **'Main'**
  String get hand;

  /// No description provided for @recentGames.
  ///
  /// In fr, this message translates to:
  /// **'Parties récentes'**
  String get recentGames;

  /// No description provided for @winBadge.
  ///
  /// In fr, this message translates to:
  /// **'V'**
  String get winBadge;

  /// No description provided for @lossBadge.
  ///
  /// In fr, this message translates to:
  /// **'D'**
  String get lossBadge;

  /// No description provided for @dartsThrown.
  ///
  /// In fr, this message translates to:
  /// **'Fléchettes lancées'**
  String get dartsThrown;

  /// No description provided for @lastDart.
  ///
  /// In fr, this message translates to:
  /// **'Dernière fléchette'**
  String get lastDart;

  /// No description provided for @ppdTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Points par fléchette'**
  String get ppdTooltip;

  /// No description provided for @bestTurnTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Score le plus haut en un tour'**
  String get bestTurnTooltip;

  /// No description provided for @doubleRateTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Doubles réussis / tentés'**
  String get doubleRateTooltip;

  /// No description provided for @totalWinsTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Total victoires'**
  String get totalWinsTooltip;

  /// No description provided for @totalGamesTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Total parties jouées'**
  String get totalGamesTooltip;

  /// No description provided for @scores100plusTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Tours avec 100+ points'**
  String get scores100plusTooltip;

  /// No description provided for @tons180Tooltip.
  ///
  /// In fr, this message translates to:
  /// **'Scores parfaits 180'**
  String get tons180Tooltip;

  /// No description provided for @currentStreakTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Victoires consécutives'**
  String get currentStreakTooltip;

  /// No description provided for @activeGamesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Parties en cours'**
  String get activeGamesTitle;

  /// No description provided for @notSignedInBroadcast.
  ///
  /// In fr, this message translates to:
  /// **'Non connecté — les parties ne seront pas diffusées'**
  String get notSignedInBroadcast;

  /// No description provided for @joinByCode.
  ///
  /// In fr, this message translates to:
  /// **'Rejoindre avec un code'**
  String get joinByCode;

  /// No description provided for @codeBtnLabel.
  ///
  /// In fr, this message translates to:
  /// **'Code'**
  String get codeBtnLabel;

  /// No description provided for @codeNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Code introuvable : {code}'**
  String codeNotFound(String code);

  /// No description provided for @join.
  ///
  /// In fr, this message translates to:
  /// **'Rejoindre'**
  String get join;

  /// No description provided for @connectionError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur de connexion'**
  String get connectionError;

  /// No description provided for @startGameToAppear.
  ///
  /// In fr, this message translates to:
  /// **'Lance une partie pour qu\'elle apparaisse ici'**
  String get startGameToAppear;

  /// No description provided for @signInToStream.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous et lancez une partie pour la diffuser'**
  String get signInToStream;

  /// No description provided for @byHost.
  ///
  /// In fr, this message translates to:
  /// **'Par {host}'**
  String byHost(String host);

  /// No description provided for @rematchOrderTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ordre de jeu'**
  String get rematchOrderTitle;

  /// No description provided for @dragToReorder.
  ///
  /// In fr, this message translates to:
  /// **'Faites glisser pour réorganiser'**
  String get dragToReorder;

  /// No description provided for @gagesSection.
  ///
  /// In fr, this message translates to:
  /// **'Gages'**
  String get gagesSection;

  /// No description provided for @wheelEnabled.
  ///
  /// In fr, this message translates to:
  /// **'Roue des gages'**
  String get wheelEnabled;

  /// No description provided for @wheelMode.
  ///
  /// In fr, this message translates to:
  /// **'Mode'**
  String get wheelMode;

  /// No description provided for @wheelModeFamily.
  ///
  /// In fr, this message translates to:
  /// **'Tout public'**
  String get wheelModeFamily;

  /// No description provided for @wheelModeAdult.
  ///
  /// In fr, this message translates to:
  /// **'18+'**
  String get wheelModeAdult;

  /// No description provided for @manageGages.
  ///
  /// In fr, this message translates to:
  /// **'Gérer les gages'**
  String get manageGages;

  /// No description provided for @addGage.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un gage'**
  String get addGage;

  /// No description provided for @editGage.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le gage'**
  String get editGage;

  /// No description provided for @gageHint.
  ///
  /// In fr, this message translates to:
  /// **'Décris le gage…'**
  String get gageHint;

  /// No description provided for @adultGage.
  ///
  /// In fr, this message translates to:
  /// **'Gage 18+'**
  String get adultGage;

  /// No description provided for @noGagesConfigured.
  ///
  /// In fr, this message translates to:
  /// **'Aucun gage — appuyez sur + pour en ajouter'**
  String get noGagesConfigured;

  /// No description provided for @spinInstruction.
  ///
  /// In fr, this message translates to:
  /// **'Glisse pour faire tourner'**
  String get spinInstruction;

  /// No description provided for @yourForfeit.
  ///
  /// In fr, this message translates to:
  /// **'Ton gage !'**
  String get yourForfeit;

  /// No description provided for @continueGame.
  ///
  /// In fr, this message translates to:
  /// **'C\'est parti !'**
  String get continueGame;

  /// No description provided for @accountSection.
  ///
  /// In fr, this message translates to:
  /// **'Compte'**
  String get accountSection;

  /// No description provided for @languageSection.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get languageSection;

  /// No description provided for @appearanceSection.
  ///
  /// In fr, this message translates to:
  /// **'Apparence'**
  String get appearanceSection;

  /// No description provided for @signInWithGoogle.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter avec Google'**
  String get signInWithGoogle;

  /// No description provided for @signOut.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get signOut;

  /// No description provided for @defaultUsername.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateur'**
  String get defaultUsername;

  /// No description provided for @finishOnDouble.
  ///
  /// In fr, this message translates to:
  /// **'Finir sur un double'**
  String get finishOnDouble;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['da', 'en', 'es', 'fr', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'da':
      return AppLocalizationsDa();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
