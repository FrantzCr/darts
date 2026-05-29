// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Dardos';

  @override
  String get homeTitle => 'La Taberna';

  @override
  String get homeSubtitle => 'Bienvenido';

  @override
  String get newGame => 'Nueva partida';

  @override
  String get history => 'Historial';

  @override
  String get stats => 'Estadísticas';

  @override
  String get profile => 'Perfil';

  @override
  String get settings => 'Ajustes';

  @override
  String get players => 'Jugadores';

  @override
  String get addPlayer => 'Añadir jugador';

  @override
  String get searchPlayer => 'Buscar jugador…';

  @override
  String get createPlayer => 'Crear jugador';

  @override
  String get createNewPlayer => 'Crear un nuevo jugador';

  @override
  String get create => 'Crear';

  @override
  String get playerName => 'Nombre del jugador';

  @override
  String get handLeft => 'Izquierda';

  @override
  String get handRight => 'Derecha';

  @override
  String get startGame => 'Iniciar partida';

  @override
  String get round => 'Ronda';

  @override
  String roundLabel(int round) {
    return 'Ronda $round';
  }

  @override
  String get bust => '¡PASADO!';

  @override
  String get win => '¡VICTORIA!';

  @override
  String get validate => 'Validar';

  @override
  String get undo => 'Deshacer';

  @override
  String get miss => 'Fallo';

  @override
  String get checkout => 'Salida';

  @override
  String get score => 'Puntuación';

  @override
  String get remaining => 'Restante';

  @override
  String remainingPoints(int score) {
    return '$score restante';
  }

  @override
  String get darts => 'Dardos';

  @override
  String get doubleOut => 'Salida doble';

  @override
  String get mode301 => '301';

  @override
  String get mode501 => '501';

  @override
  String get modeCricket => 'Cricket';

  @override
  String get locked => 'Próximamente';

  @override
  String get winnerIs => 'Ganador';

  @override
  String get finishedOn => 'Terminó en';

  @override
  String get rematch => 'Revancha';

  @override
  String get newGameBtn => 'Nueva partida';

  @override
  String get homeBtn => 'Inicio';

  @override
  String get viewResults => 'Ver resultados';

  @override
  String get noCurrentGame => 'No hay partida en curso';

  @override
  String get atLeastTwoPlayers => 'Añade al menos 2 jugadores';

  @override
  String get gameDesc301 => 'Elige tu modo de juego';

  @override
  String get winRate => 'Tasa de victoria';

  @override
  String get ppd => 'PPD';

  @override
  String get bestTurn => 'Mejor turno';

  @override
  String get avgFinish => 'Salida media';

  @override
  String get roundsPerGame => 'Rondas/partida';

  @override
  String get doubleRate => 'Tasa dobles';

  @override
  String get scores100plus => 'Puntos 100+';

  @override
  String get tons180 => 'Tons 180';

  @override
  String get currentStreak => 'Racha actual';

  @override
  String get totalGames => 'Partidas';

  @override
  String get totalWins => 'Victorias';

  @override
  String get duration => 'Duración';

  @override
  String get all => 'Todo';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get thisWeek => 'Esta semana';

  @override
  String get noGames => 'Sin partidas jugadas';

  @override
  String get noPlayers => 'Sin jugadores creados';

  @override
  String get themePub => 'Sala de pub';

  @override
  String get themeBull => 'Bullseye';

  @override
  String get themeClassic => 'Clásico';

  @override
  String get themeMin => 'Diana';

  @override
  String get turn => 'Turno';

  @override
  String get seasonLeaderboard => 'Clasificación de la temporada';

  @override
  String get lastGame => 'Última partida';

  @override
  String get rank => 'Clasificación';

  @override
  String get name => 'Nombre';

  @override
  String get victories => 'V';

  @override
  String get vs => 'vs';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get confirmDelete => '¿Eliminar este jugador?';

  @override
  String get irreversibleAction => 'Esta acción es irreversible.';

  @override
  String get colorPicker => 'Color';

  @override
  String get hand => 'Mano';

  @override
  String get recentGames => 'Partidas recientes';

  @override
  String get winBadge => 'V';

  @override
  String get lossBadge => 'D';

  @override
  String get dartsThrown => 'Dardos lanzados';

  @override
  String get lastDart => 'Último dardo';

  @override
  String get ppdTooltip => 'Puntos por dardo';

  @override
  String get bestTurnTooltip => 'Puntuación más alta en un turno';

  @override
  String get doubleRateTooltip => 'Dobles acertados / intentados';

  @override
  String get totalWinsTooltip => 'Total victorias';

  @override
  String get totalGamesTooltip => 'Total partidas jugadas';

  @override
  String get scores100plusTooltip => 'Turnos con 100+ puntos';

  @override
  String get tons180Tooltip => 'Puntuaciones perfectas 180';

  @override
  String get currentStreakTooltip => 'Victorias consecutivas';
}
