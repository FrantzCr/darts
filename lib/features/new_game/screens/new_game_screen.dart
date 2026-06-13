import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/game_mode.dart';
import '../../../core/models/player.dart';
import '../../../core/themes/theme_provider.dart';
import '../../../core/themes/theme_tokens.dart';
import '../../../features/game/providers/game_provider.dart';
import '../../../features/profile/providers/player_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/pub_avatar.dart';
import '../../../shared/widgets/pub_back_button.dart';
import '../../../shared/widgets/pub_button.dart';
import '../../../shared/widgets/pub_screen.dart';
import '../../../shared/widgets/theme_toggle_fab.dart';

const _kColors = [
  '#c1272d', '#2d6a3a', '#c9a55a', '#4a6b8a',
  '#7b3f9e', '#c97b35', '#3a8fa8', '#888888',
];

class NewGameScreen extends ConsumerStatefulWidget {
  const NewGameScreen({super.key});

  @override
  ConsumerState<NewGameScreen> createState() => _NewGameScreenState();
}

class _NewGameScreenState extends ConsumerState<NewGameScreen> {
  final List<Player> _selected = [];
  String _search = '';
  bool _showCreate = false;
  final _nameCtrl = TextEditingController();
  String _pickedColor = _kColors[0];
  String _pickedHand = 'right';
  int _startScore = 301;
  GameMode _gameMode = GameMode.classic;
  bool _doubleOut = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  String _autoInitials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return trimmed.substring(0, trimmed.length.clamp(1, 2)).toUpperCase();
  }

  Future<void> _createAndAdd() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    final player = await ref.read(playerProvider.notifier).createPlayer(
      name: name,
      colorHex: _pickedColor,
      hand: _pickedHand,
    );
    setState(() {
      _selected.add(player);
      _showCreate = false;
      _nameCtrl.clear();
      _pickedColor = _kColors[0];
      _search = '';
    });
  }

  void _startGame() {
    if (_selected.length < 2) return;
    ref.read(gameProvider.notifier).startGame(_selected, startScore: _startScore, gameMode: _gameMode, doubleOut: _doubleOut);
    context.go('/game');
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(activeThemeTokensProvider);
    final l10n = AppLocalizations.of(context);
    final allPlayers = ref.watch(playerProvider);
    final filtered = allPlayers
        .where((p) => !_selected.any((s) => s.id == p.id))
        .where((p) => _search.isEmpty || p.name.toLowerCase().contains(_search.toLowerCase()))
        .toList();

    return PubScreen(
      theme: t,
      floatingActionButton: const ThemeToggleFab(),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TopBar(t: t),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _ModeSection(
                      t: t,
                      selectedScore: _startScore,
                      gameMode: _gameMode,
                      doubleOut: _doubleOut,
                      onSelectScore: (v) => setState(() { _startScore = v; _gameMode = GameMode.classic; }),
                      onSelectRtc: () => setState(() => _gameMode = GameMode.rtc),
                      onToggleDoubleOut: (v) => setState(() => _doubleOut = v),
                    ),
                    const SizedBox(height: 24),
                    _SelectedPlayers(selected: _selected, t: t, onRemove: (p) => setState(() => _selected.remove(p))),
                    const SizedBox(height: 16),
                    _SearchBar(t: t, value: _search, onChanged: (v) => setState(() => _search = v)),
                    const SizedBox(height: 8),
                    if (_showCreate)
                      _CreateForm(
                        t: t,
                        nameCtrl: _nameCtrl,
                        pickedColor: _pickedColor,
                        pickedHand: _pickedHand,
                        onColorPick: (c) => setState(() => _pickedColor = c),
                        onHandPick: (h) => setState(() => _pickedHand = h),
                        onCancel: () => setState(() => _showCreate = false),
                        onSave: _createAndAdd,
                        autoInitials: _autoInitials(_nameCtrl.text),
                      )
                    else
                      _PlayerList(
                        players: filtered,
                        t: t,
                        onSelect: (p) => setState(() {
                          if (_selected.length < 8) _selected.add(p);
                        }),
                        onShowCreate: () => setState(() => _showCreate = true),
                      ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: PubButton(
                label: l10n.startGame,
                theme: t,
                kind: PubButtonKind.gold,
                expanded: true,
                onPressed: _selected.length >= 2 ? _startGame : null,
                icon: Icons.sports_bar,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final AppThemeTokens t;
  const _TopBar({required this.t});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Row(
        children: [
          PubBackButton(t: t, onTap: () => context.go('/')),
          const SizedBox(width: 12),
          Text(l10n.newGame, style: TextStyle(color: t.textOnDark, fontSize: 20, fontWeight: FontWeight.w700, fontFamily: t.displayFont)),
        ],
      ),
    );
  }
}

class _ModeSection extends StatelessWidget {
  final AppThemeTokens t;
  final int selectedScore;
  final GameMode gameMode;
  final bool doubleOut;
  final ValueChanged<int> onSelectScore;
  final VoidCallback onSelectRtc;
  final ValueChanged<bool> onToggleDoubleOut;
  const _ModeSection({
    required this.t,
    required this.selectedScore,
    required this.gameMode,
    required this.doubleOut,
    required this.onSelectScore,
    required this.onSelectRtc,
    required this.onToggleDoubleOut,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isClassic = gameMode == GameMode.classic;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _ModeChip(label: l10n.mode301, active: isClassic && selectedScore == 301, t: t, onTap: () => onSelectScore(301)),
            _ModeChip(label: l10n.mode501, active: isClassic && selectedScore == 501, t: t, onTap: () => onSelectScore(501)),
            _ModeChip(label: 'Clock', active: gameMode == GameMode.rtc, t: t, onTap: onSelectRtc),
            _ModeChip(label: l10n.modeCricket, active: false, locked: true, t: t),
          ],
        ),
        if (isClassic) ...[
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () => onToggleDoubleOut(!doubleOut),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 40,
                  height: 22,
                  decoration: BoxDecoration(
                    color: doubleOut ? t.accent : t.surfaceBorder,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 200),
                    alignment: doubleOut ? Alignment.centerRight : Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Container(width: 16, height: 16, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text('Finir sur un double', style: TextStyle(color: t.textOnDark.withValues(alpha: 0.85), fontSize: 14)),
                const SizedBox(width: 6),
                Text('(double-out)', style: TextStyle(color: t.textDim, fontSize: 12)),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String label;
  final bool active;
  final bool locked;
  final AppThemeTokens t;
  final VoidCallback? onTap;
  const _ModeChip({required this.label, required this.active, this.locked = false, required this.t, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: locked ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? t.accent : t.surface.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: active ? t.accent : t.surfaceBorder.withValues(alpha: 0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: TextStyle(color: active ? t.textOnDark : t.textOnDark.withValues(alpha: 0.5), fontWeight: FontWeight.w600, fontSize: 13)),
            if (locked) ...[
              const SizedBox(width: 4),
              Icon(Icons.lock_outline, size: 11, color: t.textOnDark.withValues(alpha: 0.4)),
            ],
          ],
        ),
      ),
    );
  }
}

class _SelectedPlayers extends StatelessWidget {
  final List<Player> selected;
  final AppThemeTokens t;
  final ValueChanged<Player> onRemove;
  const _SelectedPlayers({required this.selected, required this.t, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (selected.isEmpty) {
      return Text(l10n.atLeastTwoPlayers, style: TextStyle(color: t.textOnDark.withValues(alpha: 0.5), fontSize: 13));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: selected.map((p) => GestureDetector(
            onTap: () => onRemove(p),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: t.surface.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: t.surfaceBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PubAvatar(initials: p.initials, color: p.color, theme: t, size: 24),
                  const SizedBox(width: 6),
                  Text(p.name, style: TextStyle(color: t.textOnDark, fontSize: 13)),
                  const SizedBox(width: 6),
                  Icon(Icons.close, color: t.textOnDark.withValues(alpha: 0.6), size: 14),
                ],
              ),
            ),
          )).toList(),
        ),
        if (selected.length < 2) ...[
          const SizedBox(height: 6),
          Text(l10n.atLeastTwoPlayers, style: TextStyle(color: t.textOnDark.withValues(alpha: 0.5), fontSize: 13)),
        ],
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  final AppThemeTokens t;
  final String value;
  final ValueChanged<String> onChanged;
  const _SearchBar({required this.t, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TextField(
      onChanged: onChanged,
      style: TextStyle(color: t.text),
      decoration: InputDecoration(
        hintText: l10n.searchPlayer,
        hintStyle: TextStyle(color: t.textDim),
        prefixIcon: Icon(Icons.search, color: t.textDim, size: 18),
        filled: true,
        fillColor: t.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(t.shape.smRadius),
          borderSide: BorderSide(color: t.surfaceBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(t.shape.smRadius),
          borderSide: BorderSide(color: t.surfaceBorder),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }
}

class _PlayerList extends StatelessWidget {
  final List<Player> players;
  final AppThemeTokens t;
  final ValueChanged<Player> onSelect;
  final VoidCallback onShowCreate;
  const _PlayerList({required this.players, required this.t, required this.onSelect, required this.onShowCreate});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        ...players.map((p) => GestureDetector(
          onTap: () => onSelect(p),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: t.surface.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(t.shape.smRadius),
              border: Border.all(color: t.surfaceBorder.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                PubAvatar(initials: p.initials, color: p.color, theme: t, size: 36),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.name, style: TextStyle(color: t.textOnDark, fontSize: 15, fontWeight: FontWeight.w600)),
                      Text(
                        '${p.totalGames} ${l10n.totalGames.toLowerCase()} · ${(p.winRate * 100).round()}% ${l10n.totalWins.toLowerCase()}',
                        style: TextStyle(color: t.textOnDark.withValues(alpha: 0.55), fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.add_circle_outline, color: t.accent, size: 22),
              ],
            ),
          ),
        )),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: onShowCreate,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(t.shape.smRadius),
              border: Border.all(color: t.surfaceBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_add_outlined, color: t.textOnDark.withValues(alpha: 0.7), size: 18),
                const SizedBox(width: 8),
                Text(l10n.createNewPlayer, style: TextStyle(color: t.textOnDark.withValues(alpha: 0.7), fontSize: 14)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CreateForm extends StatefulWidget {
  final AppThemeTokens t;
  final TextEditingController nameCtrl;
  final String pickedColor;
  final String pickedHand;
  final ValueChanged<String> onColorPick;
  final ValueChanged<String> onHandPick;
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final String autoInitials;
  const _CreateForm({
    required this.t,
    required this.nameCtrl,
    required this.pickedColor,
    required this.pickedHand,
    required this.onColorPick,
    required this.onHandPick,
    required this.onCancel,
    required this.onSave,
    required this.autoInitials,
  });

  @override
  State<_CreateForm> createState() => _CreateFormState();
}

class _CreateFormState extends State<_CreateForm> {
  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    final l10n = AppLocalizations.of(context);
    final initials = widget.autoInitials.isEmpty ? '?' : widget.autoInitials;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(t.shape.cardRadius),
        border: Border.all(color: t.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Color(int.parse('FF${widget.pickedColor.replaceAll('#', '')}', radix: 16)),
                  shape: BoxShape.circle,
                ),
                child: Center(child: Text(initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18))),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: widget.nameCtrl,
                  onChanged: (_) => setState(() {}),
                  style: TextStyle(color: t.text),
                  decoration: InputDecoration(
                    hintText: l10n.playerName,
                    hintStyle: TextStyle(color: t.textDim),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(t.shape.smRadius), borderSide: BorderSide(color: t.surfaceBorder)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(t.shape.smRadius), borderSide: BorderSide(color: t.surfaceBorder)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(l10n.colorPicker, style: TextStyle(color: t.textDim, fontSize: 12, letterSpacing: 1)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _kColors.map((hex) {
              final selected = hex == widget.pickedColor;
              return GestureDetector(
                onTap: () => widget.onColorPick(hex),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16)),
                    shape: BoxShape.circle,
                    border: selected ? Border.all(color: Colors.white, width: 2.5) : null,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text(l10n.hand, style: TextStyle(color: t.textDim, fontSize: 12, letterSpacing: 1)),
          const SizedBox(height: 8),
          Row(
            children: [
              _HandChip(label: l10n.handLeft, value: 'left', selected: widget.pickedHand == 'left', t: t, onTap: () => widget.onHandPick('left')),
              const SizedBox(width: 8),
              _HandChip(label: l10n.handRight, value: 'right', selected: widget.pickedHand == 'right', t: t, onTap: () => widget.onHandPick('right')),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: PubButton(label: l10n.cancel, theme: t, kind: PubButtonKind.text, onPressed: widget.onCancel)),
              const SizedBox(width: 12),
              Expanded(child: PubButton(label: l10n.create, theme: t, kind: PubButtonKind.primary, onPressed: widget.onSave)),
            ],
          ),
        ],
      ),
    );
  }
}

class _HandChip extends StatelessWidget {
  final String label;
  final String value;
  final bool selected;
  final AppThemeTokens t;
  final VoidCallback onTap;
  const _HandChip({required this.label, required this.value, required this.selected, required this.t, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? t.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? t.accent : t.surfaceBorder),
        ),
        child: Text(label, style: TextStyle(color: selected ? t.textOnDark : t.text, fontSize: 13, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
