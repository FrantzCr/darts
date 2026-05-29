import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'l10n/app_localizations.dart';

import 'core/models/game_session.dart';
import 'core/models/player.dart';
import 'core/router/app_router.dart';
import 'core/themes/app_theme.dart';
import 'core/themes/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(PlayerAdapter());
  Hive.registerAdapter(GameSessionAdapter());
  Hive.registerAdapter(TurnRecordAdapter());
  await Hive.openBox<Player>('players');
  await Hive.openBox<GameSession>('game_sessions');

  GoogleFonts.config.allowRuntimeFetching = true;

  runApp(const ProviderScope(child: DartsApp()));
}

class DartsApp extends ConsumerStatefulWidget {
  const DartsApp({super.key});

  @override
  ConsumerState<DartsApp> createState() => _DartsAppState();
}

class _DartsAppState extends ConsumerState<DartsApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(themeProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final tokens = ref.watch(activeThemeTokensProvider);
    final theme = buildMaterialTheme(tokens);

    return MaterialApp.router(
      title: 'Fléchettes',
      debugShowCheckedModeBanner: false,
      theme: theme,
      routerConfig: appRouter,
      locale: const Locale('fr'),
      supportedLocales: const [
        Locale('fr'),
        Locale('en'),
        Locale('es'),
        Locale('da'),
        Locale('ru'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
