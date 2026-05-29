import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/player.dart';
import '../../../core/themes/theme_provider.dart';
import '../../../core/themes/theme_tokens.dart';
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

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _showCreate = false;
  final _nameCtrl = TextEditingController();
  String _pickedColor = _kColors[0];
  String _pickedHand = 'right';

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _createPlayer() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    await ref.read(playerProvider.notifier).createPlayer(
      name: name,
      colorHex: _pickedColor,
      hand: _pickedHand,
    );
    setState(() {
      _showCreate = false;
      _nameCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(activeThemeTokensProvider);
    final players = ref.watch(playerProvider);
    final l10n = AppLocalizations.of(context);

    return PubScreen(
      theme: t,
      floatingActionButton: const ThemeToggleFab(),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TopBar(t: t, onAdd: () => setState(() => _showCreate = !_showCreate)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    if (_showCreate) ...[
                      const SizedBox(height: 12),
                      _CreateForm(
                        t: t,
                        nameCtrl: _nameCtrl,
                        pickedColor: _pickedColor,
                        pickedHand: _pickedHand,
                        onColorPick: (c) => setState(() => _pickedColor = c),
                        onHandPick: (h) => setState(() => _pickedHand = h),
                        onCancel: () => setState(() => _showCreate = false),
                        onSave: _createPlayer,
                      ),
                    ],
                    const SizedBox(height: 12),
                    if (players.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 60),
                        child: Text(l10n.noPlayers, style: TextStyle(color: t.textOnDark.withValues(alpha: 0.5))),
                      )
                    else
                      ...players.map((p) => _PlayerRow(player: p, t: t, onDelete: () => _confirmDelete(context, p, t))),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Player player, AppThemeTokens t) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: t.surface,
        title: Text('${l10n.delete} ${player.name} ?', style: TextStyle(color: t.text)),
        content: Text(l10n.irreversibleAction, style: TextStyle(color: t.textDim)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel, style: TextStyle(color: t.textDim)),
          ),
          TextButton(
            onPressed: () {
              ref.read(playerProvider.notifier).deletePlayer(player.id);
              Navigator.pop(context);
            },
            child: Text(l10n.delete, style: TextStyle(color: t.accent)),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final AppThemeTokens t;
  final VoidCallback onAdd;
  const _TopBar({required this.t, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        children: [
          PubBackButton(t: t, onTap: () => context.go('/')),
          const SizedBox(width: 12),
          Text(l10n.players, style: TextStyle(color: t.textOnDark, fontSize: 20, fontWeight: FontWeight.w700, fontFamily: t.displayFont)),
          const Spacer(),
          GestureDetector(
            onTap: onAdd,
            child: Icon(Icons.person_add_outlined, color: t.accent, size: 24),
          ),
        ],
      ),
    );
  }
}

class _PlayerRow extends StatelessWidget {
  final Player player;
  final AppThemeTokens t;
  final VoidCallback onDelete;
  const _PlayerRow({required this.player, required this.t, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: t.surface.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(t.shape.cardRadius),
        border: Border.all(color: t.surfaceBorder.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          PubAvatar(initials: player.initials, color: player.color, theme: t, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(player.name, style: TextStyle(color: t.textOnDark, fontSize: 15, fontWeight: FontWeight.w600)),
                Text(
                  '${player.totalGames} ${l10n.totalGames.toLowerCase()} · ${player.totalWins} ${l10n.totalWins.toLowerCase()} · ${l10n.ppd} ${player.ppd.toStringAsFixed(1)}',
                  style: TextStyle(color: t.textOnDark.withValues(alpha: 0.5), fontSize: 11),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onDelete,
            child: Icon(Icons.delete_outline, color: t.textDim, size: 20),
          ),
        ],
      ),
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
  const _CreateForm({
    required this.t,
    required this.nameCtrl,
    required this.pickedColor,
    required this.pickedHand,
    required this.onColorPick,
    required this.onHandPick,
    required this.onCancel,
    required this.onSave,
  });

  @override
  State<_CreateForm> createState() => _CreateFormState();
}

class _CreateFormState extends State<_CreateForm> {
  String _initials() {
    final name = widget.nameCtrl.text.trim();
    if (name.isEmpty) return '?';
    final parts = name.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.substring(0, name.length.clamp(1, 2)).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    final l10n = AppLocalizations.of(context);
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
                child: Center(child: Text(_initials(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18))),
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
              Expanded(child: PubButton(label: l10n.cancel, theme: t, kind: PubButtonKind.ghost, onPressed: widget.onCancel)),
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
