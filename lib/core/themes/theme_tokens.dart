import 'package:flutter/material.dart';

enum AppThemeId { pub, bull, classic, min }

class BoardTokens {
  final Color rim;
  final Color miss;
  final Color wedgeA;
  final Color wedgeB;
  final Color scoreA;
  final Color scoreB;
  final Color outerBull;
  final Color bull;
  final Color wire;
  final double wireWidth;
  final Color numColor;
  final String numFont;
  final double numSize;
  final FontWeight numWeight;
  final double numTracking;
  final bool glow;

  const BoardTokens({
    required this.rim,
    required this.miss,
    required this.wedgeA,
    required this.wedgeB,
    required this.scoreA,
    required this.scoreB,
    required this.outerBull,
    required this.bull,
    required this.wire,
    required this.wireWidth,
    required this.numColor,
    required this.numFont,
    required this.numSize,
    required this.numWeight,
    required this.numTracking,
    this.glow = false,
  });
}

class ShapeTokens {
  final double cardRadius;
  final double smRadius;
  final double buttonRadius;
  final bool cornerTicks;
  final bool statusDot;
  final bool bracketCta;
  final String texture; // 'none' | 'diagonal' | 'grid'

  const ShapeTokens({
    required this.cardRadius,
    required this.smRadius,
    required this.buttonRadius,
    required this.cornerTicks,
    required this.statusDot,
    required this.bracketCta,
    required this.texture,
  });
}

class AppThemeTokens {
  final AppThemeId id;
  final String name;
  final String tag;
  final Color bg;
  final Color surface;
  final Color surfaceAlt;
  final Color surfaceBorder;
  final Color text;
  final Color textDim;
  final Color textOnDark;
  final Color textOnDarkDim;
  final Color accent;
  final Color accentSoft;
  final Color green;
  final Color gold;
  final Color onGold;
  final String displayFont;
  final String bodyFont;
  final String monoFont;
  final String scoreboardFont;
  final ShapeTokens shape;
  final BoardTokens board;

  const AppThemeTokens({
    required this.id,
    required this.name,
    required this.tag,
    required this.bg,
    required this.surface,
    required this.surfaceAlt,
    required this.surfaceBorder,
    required this.text,
    required this.textDim,
    required this.textOnDark,
    required this.textOnDarkDim,
    required this.accent,
    required this.accentSoft,
    required this.green,
    required this.gold,
    required this.onGold,
    required this.displayFont,
    required this.bodyFont,
    required this.monoFont,
    required this.scoreboardFont,
    required this.shape,
    required this.board,
  });
}

Color _c(String hex) => Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));
Color _ca(String hex, double opacity) => _c(hex).withValues(alpha: opacity);

final kThemePub = AppThemeTokens(
  id: AppThemeId.pub,
  name: 'Salle de pub',
  tag: 'classique · bois & feutre',
  bg: _c('#1d2e23'),
  surface: _c('#f3e9d2'),
  surfaceAlt: _c('#e8dcc1'),
  surfaceBorder: _c('#c9b386'),
  text: _c('#1a1612'),
  textDim: _c('#5b4d36'),
  textOnDark: _c('#f3e9d2'),
  textOnDarkDim: _ca('#f3e9d2', 0.55),
  accent: _c('#c1272d'),
  accentSoft: _c('#e8b04a'),
  green: _c('#2d6a3a'),
  gold: _c('#c9a55a'),
  onGold: _c('#1a1612'),
  displayFont: 'Oswald',
  bodyFont: 'Inter',
  monoFont: 'JetBrainsMono',
  scoreboardFont: 'PlayfairDisplay',
  shape: const ShapeTokens(
    cardRadius: 10,
    smRadius: 8,
    buttonRadius: 8,
    cornerTicks: false,
    statusDot: false,
    bracketCta: false,
    texture: 'diagonal',
  ),
  board: BoardTokens(
    rim: _c('#2a1d10'),
    miss: _c('#0e0a06'),
    wedgeA: _c('#0d0c0a'),
    wedgeB: _c('#ead8b6'),
    scoreA: _c('#c1272d'),
    scoreB: _c('#2d6a3a'),
    outerBull: _c('#2d6a3a'),
    bull: _c('#c1272d'),
    wire: _ca('#c9a55a', 0.5),
    wireWidth: 0.6,
    numColor: _c('#f3e9d2'),
    numFont: 'Oswald',
    numSize: 16,
    numWeight: FontWeight.w600,
    numTracking: 0.5,
  ),
);

final kThemeBull = AppThemeTokens(
  id: AppThemeId.bull,
  name: 'Bullseye',
  tag: 'tactique · cockpit',
  bg: _c('#08090b'),
  surface: _c('#11141a'),
  surfaceAlt: _c('#1a1f27'),
  surfaceBorder: _ca('#ffb450', 0.18),
  text: _c('#e8ebef'),
  textDim: _ca('#e8ebef', 0.45),
  textOnDark: _c('#e8ebef'),
  textOnDarkDim: _ca('#e8ebef', 0.5),
  accent: _c('#ff9d3b'),
  accentSoft: _c('#ffd185'),
  green: _c('#4cd6a3'),
  gold: _c('#ff9d3b'),
  onGold: _c('#08090b'),
  displayFont: 'IBMPlexMono',
  bodyFont: 'IBMPlexSans',
  monoFont: 'IBMPlexMono',
  scoreboardFont: 'IBMPlexMono',
  shape: const ShapeTokens(
    cardRadius: 2,
    smRadius: 2,
    buttonRadius: 2,
    cornerTicks: true,
    statusDot: true,
    bracketCta: true,
    texture: 'grid',
  ),
  board: BoardTokens(
    rim: _c('#1a1f27'),
    miss: _c('#06070a'),
    wedgeA: _c('#0d1014'),
    wedgeB: _c('#1d2229'),
    scoreA: _c('#ff9d3b'),
    scoreB: _c('#4cd6a3'),
    outerBull: _c('#4cd6a3'),
    bull: _c('#ff9d3b'),
    wire: _ca('#ff9d3b', 0.35),
    wireWidth: 0.6,
    numColor: _ca('#ff9d3b', 0.85),
    numFont: 'IBMPlexMono',
    numSize: 13,
    numWeight: FontWeight.w500,
    numTracking: 0.5,
    glow: true,
  ),
);

final kThemeClassic = AppThemeTokens(
  id: AppThemeId.classic,
  name: 'Classique',
  tag: 'sobre · sans chichi',
  bg: _c('#f4f4f6'),
  surface: _c('#ffffff'),
  surfaceAlt: _c('#fafafa'),
  surfaceBorder: _ca('#0f1115', 0.1),
  text: _c('#0f1115'),
  textDim: _ca('#0f1115', 0.55),
  textOnDark: _c('#0f1115'),
  textOnDarkDim: _ca('#0f1115', 0.55),
  accent: _c('#1f4d7c'),
  accentSoft: _c('#cfd8e2'),
  green: _c('#2d8659'),
  gold: _c('#1f4d7c'),
  onGold: _c('#ffffff'),
  displayFont: 'Inter',
  bodyFont: 'Inter',
  monoFont: 'JetBrainsMono',
  scoreboardFont: 'Inter',
  shape: const ShapeTokens(
    cardRadius: 8,
    smRadius: 6,
    buttonRadius: 8,
    cornerTicks: false,
    statusDot: false,
    bracketCta: false,
    texture: 'none',
  ),
  board: BoardTokens(
    rim: _c('#2a1d10'),
    miss: _c('#0e0a06'),
    wedgeA: _c('#0d0c0a'),
    wedgeB: _c('#ead8b6'),
    scoreA: _c('#c1272d'),
    scoreB: _c('#2d6a3a'),
    outerBull: _c('#2d6a3a'),
    bull: _c('#c1272d'),
    wire: _ca('#ffffff', 0.5),
    wireWidth: 0.5,
    numColor: _c('#ffffff'),
    numFont: 'Inter',
    numSize: 14,
    numWeight: FontWeight.w600,
    numTracking: 0,
  ),
);

final kThemeMin = AppThemeTokens(
  id: AppThemeId.min,
  name: 'Cible',
  tag: 'minimal · papier & encre',
  bg: _c('#f5f1e9'),
  surface: _c('#ffffff'),
  surfaceAlt: _c('#faf7f0'),
  surfaceBorder: _ca('#1a1612', 0.08),
  text: _c('#1a1612'),
  textDim: _ca('#1a1612', 0.55),
  textOnDark: _c('#1a1612'),
  textOnDarkDim: _ca('#1a1612', 0.55),
  accent: _c('#b34a3a'),
  accentSoft: _c('#e8d4b8'),
  green: _c('#5a7a52'),
  gold: _c('#b89968'),
  onGold: _c('#1a1612'),
  displayFont: 'PlayfairDisplay',
  bodyFont: 'Inter',
  monoFont: 'JetBrainsMono',
  scoreboardFont: 'PlayfairDisplay',
  shape: const ShapeTokens(
    cardRadius: 12,
    smRadius: 10,
    buttonRadius: 10,
    cornerTicks: false,
    statusDot: false,
    bracketCta: false,
    texture: 'none',
  ),
  board: BoardTokens(
    rim: _c('#1a1612'),
    miss: _c('#1a1612'),
    wedgeA: _c('#1a1612'),
    wedgeB: _c('#f5efe3'),
    scoreA: _c('#b34a3a'),
    scoreB: _c('#5a7a52'),
    outerBull: _c('#5a7a52'),
    bull: _c('#b34a3a'),
    wire: _ca('#fffaf0', 0.4),
    wireWidth: 0.5,
    numColor: _c('#f5efe3'),
    numFont: 'Inter',
    numSize: 14,
    numWeight: FontWeight.w500,
    numTracking: 0,
  ),
);

const Map<AppThemeId, AppThemeTokens> kThemes = {};

AppThemeTokens themeById(AppThemeId id) => switch (id) {
  AppThemeId.pub => kThemePub,
  AppThemeId.bull => kThemeBull,
  AppThemeId.classic => kThemeClassic,
  AppThemeId.min => kThemeMin,
};
