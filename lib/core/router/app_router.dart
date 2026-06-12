import 'package:go_router/go_router.dart';
import '../../features/game/screens/game_screen.dart';
import '../../features/history/screens/history_detail_screen.dart';
import '../../features/history/screens/history_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/new_game/screens/new_game_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/result/screens/result_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/spectator/screens/active_games_screen.dart';
import '../../features/spectator/screens/spectator_screen.dart';
import '../../features/stats/screens/stats_screen.dart';
import '../../features/welcome/screens/welcome_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/welcome',
  routes: [
    GoRoute(path: '/welcome', builder: (_, __) => const WelcomeScreen()),
    GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/new-game', builder: (_, __) => const NewGameScreen()),
    GoRoute(path: '/game', builder: (_, __) => const GameScreen()),
    GoRoute(path: '/result', builder: (_, __) => const ResultScreen()),
    GoRoute(path: '/history', builder: (_, __) => const HistoryScreen()),
    GoRoute(
      path: '/history/:id',
      builder: (_, state) => HistoryDetailScreen(sessionId: state.pathParameters['id']!),
    ),
    GoRoute(path: '/stats', builder: (_, __) => const StatsScreen()),
    GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
    GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
    GoRoute(path: '/live', builder: (_, __) => const ActiveGamesScreen()),
    GoRoute(
      path: '/live/:id',
      builder: (_, state) => SpectatorScreen(gameId: state.pathParameters['id']!),
    ),
  ],
);
