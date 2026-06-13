// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Дартс';

  @override
  String get homeTitle => 'Таверна';

  @override
  String get homeSubtitle => 'Добро пожаловать';

  @override
  String get newGame => 'Новая игра';

  @override
  String get history => 'История';

  @override
  String get stats => 'Статистика';

  @override
  String get profile => 'Профиль';

  @override
  String get settings => 'Настройки';

  @override
  String get players => 'Игроки';

  @override
  String get addPlayer => 'Добавить игрока';

  @override
  String get searchPlayer => 'Поиск игрока…';

  @override
  String get createPlayer => 'Создать игрока';

  @override
  String get createNewPlayer => 'Создать нового игрока';

  @override
  String get create => 'Создать';

  @override
  String get playerName => 'Имя игрока';

  @override
  String get handLeft => 'Левая';

  @override
  String get handRight => 'Правая';

  @override
  String get startGame => 'Начать игру';

  @override
  String get round => 'Раунд';

  @override
  String roundLabel(int round) {
    return 'Раунд $round';
  }

  @override
  String get bust => 'ПЕРЕБОР!';

  @override
  String get win => 'ПОБЕДА!';

  @override
  String get validate => 'Подтвердить';

  @override
  String get undo => 'Отменить';

  @override
  String get miss => 'Промах';

  @override
  String get checkout => 'Финиш';

  @override
  String get score => 'Счёт';

  @override
  String get remaining => 'Осталось';

  @override
  String remainingPoints(int score) {
    return '$score осталось';
  }

  @override
  String get darts => 'Дротики';

  @override
  String get doubleOut => 'Двойной выход';

  @override
  String get mode301 => '301';

  @override
  String get mode501 => '501';

  @override
  String get modeCricket => 'Крикет';

  @override
  String get locked => 'Скоро';

  @override
  String get winnerIs => 'Победитель';

  @override
  String get finishedOn => 'Завершил на';

  @override
  String get rematch => 'Реванш';

  @override
  String get newGameBtn => 'Новая игра';

  @override
  String get homeBtn => 'Главная';

  @override
  String get viewResults => 'Посмотреть результаты';

  @override
  String get noCurrentGame => 'Нет активной игры';

  @override
  String get atLeastTwoPlayers => 'Добавьте минимум 2 игрока';

  @override
  String get gameDesc301 => 'Выберите режим игры';

  @override
  String get winRate => 'Процент побед';

  @override
  String get ppd => 'PPD';

  @override
  String get bestTurn => 'Лучший ход';

  @override
  String get avgFinish => 'Средний финиш';

  @override
  String get roundsPerGame => 'Раунды/игра';

  @override
  String get doubleRate => 'Двойной %';

  @override
  String get scores100plus => 'Очки 100+';

  @override
  String get tons180 => 'Тонны 180';

  @override
  String get currentStreak => 'Текущая серия';

  @override
  String get totalGames => 'Игры';

  @override
  String get totalWins => 'Победы';

  @override
  String get duration => 'Длительность';

  @override
  String get all => 'Все';

  @override
  String get today => 'Сегодня';

  @override
  String get yesterday => 'Вчера';

  @override
  String get thisWeek => 'На этой неделе';

  @override
  String get noGames => 'Нет сыгранных партий';

  @override
  String get noPlayers => 'Нет созданных игроков';

  @override
  String get themePub => 'Паб';

  @override
  String get themeBull => 'Bullseye';

  @override
  String get themeClassic => 'Классика';

  @override
  String get themeMin => 'Мишень';

  @override
  String get turn => 'Ход';

  @override
  String get seasonLeaderboard => 'Рейтинг сезона';

  @override
  String get lastGame => 'Последняя игра';

  @override
  String get rank => 'Место';

  @override
  String get name => 'Имя';

  @override
  String get victories => 'П';

  @override
  String get vs => 'vs';

  @override
  String get cancel => 'Отмена';

  @override
  String get save => 'Сохранить';

  @override
  String get delete => 'Удалить';

  @override
  String get confirmDelete => 'Удалить этого игрока?';

  @override
  String get irreversibleAction => 'Это действие необратимо.';

  @override
  String get colorPicker => 'Цвет';

  @override
  String get initials => 'Инициалы';

  @override
  String get hand => 'Рука';

  @override
  String get recentGames => 'Последние игры';

  @override
  String get winBadge => 'П';

  @override
  String get lossBadge => 'Пр';

  @override
  String get dartsThrown => 'Брошено дротиков';

  @override
  String get lastDart => 'Последний дротик';

  @override
  String get ppdTooltip => 'Очков за дротик';

  @override
  String get bestTurnTooltip => 'Максимальный счёт за ход';

  @override
  String get doubleRateTooltip => 'Двойных попаданий / попыток';

  @override
  String get totalWinsTooltip => 'Всего побед';

  @override
  String get totalGamesTooltip => 'Всего игр сыграно';

  @override
  String get scores100plusTooltip => 'Ходы со 100+ очков';

  @override
  String get tons180Tooltip => 'Идеальные счёты 180';

  @override
  String get currentStreakTooltip => 'Побед подряд';

  @override
  String get activeGamesTitle => 'Активные игры';

  @override
  String get notSignedInBroadcast => 'Не вошли — игры не будут транслироваться';

  @override
  String get joinByCode => 'Войти по коду';

  @override
  String get codeBtnLabel => 'Код';

  @override
  String codeNotFound(String code) {
    return 'Код не найден: $code';
  }

  @override
  String get join => 'Войти';

  @override
  String get connectionError => 'Ошибка подключения';

  @override
  String get startGameToAppear => 'Начни игру, чтобы она появилась здесь';

  @override
  String get signInToStream => 'Войдите и начните игру для трансляции';

  @override
  String byHost(String host) {
    return 'Игра $host';
  }

  @override
  String get rematchOrderTitle => 'Порядок игроков';

  @override
  String get dragToReorder => 'Перетащите для сортировки';

  @override
  String get gagesSection => 'Фанты';

  @override
  String get wheelEnabled => 'Колесо фантов';

  @override
  String get wheelMode => 'Режим';

  @override
  String get wheelModeFamily => 'Все возрасты';

  @override
  String get wheelModeAdult => '18+';

  @override
  String get manageGages => 'Управление фантами';

  @override
  String get addGage => 'Добавить фант';

  @override
  String get editGage => 'Изменить фант';

  @override
  String get gageHint => 'Опишите фант…';

  @override
  String get adultGage => 'Фант 18+';

  @override
  String get noGagesConfigured => 'Нет фантов — нажмите + чтобы добавить';

  @override
  String get spinInstruction => 'Проведите для вращения';

  @override
  String get yourForfeit => 'Твой фант!';

  @override
  String get continueGame => 'Вперёд!';

  @override
  String get accountSection => 'Аккаунт';

  @override
  String get languageSection => 'Язык';

  @override
  String get appearanceSection => 'Внешний вид';

  @override
  String get signInWithGoogle => 'Войти через Google';

  @override
  String get signOut => 'Выйти';

  @override
  String get defaultUsername => 'Пользователь';

  @override
  String get finishOnDouble => 'Финиш с дублем';
}
