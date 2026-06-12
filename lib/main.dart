import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'firebase_options.dart';
import 'l10n/app_localizations.dart';

import 'core/models/game_session.dart';
import 'core/models/player.dart';
import 'core/router/app_router.dart';
import 'core/themes/app_theme.dart';
import 'core/themes/theme_provider.dart';
import 'features/settings/providers/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Process any pending redirect result (Google Sign-In redirect flow on web)
  if (kIsWeb) {
    try {
      await FirebaseAuth.instance.getRedirectResult();
    } catch (e) {
      debugPrint('Auth redirect error: $e');
    }
  }

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
    Future.microtask(() async {
      await ref.read(themeProvider.notifier).load();
      await ref.read(localeProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = ref.watch(activeThemeTokensProvider);
    final theme = buildMaterialTheme(tokens);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Fléchettes',
      debugShowCheckedModeBanner: false,
      theme: theme,
      routerConfig: appRouter,
      locale: locale,
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
