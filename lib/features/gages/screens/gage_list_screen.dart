import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/gage.dart';
import '../../../core/themes/theme_provider.dart';
import '../../../core/themes/theme_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/pub_back_button.dart';
import '../../../shared/widgets/pub_screen.dart';
import '../providers/gage_provider.dart';

class GageListScreen extends ConsumerWidget {
  const GageListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(activeThemeTokensProvider);
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(gageProvider);
    final notifier = ref.read(gageProvider.notifier);

    final familyGages = settings.gages.where((g) => !g.isAdult).toList();
    final adultGages = settings.gages.where((g) => g.isAdult).toList();

    return PubScreen(
      theme: t,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  PubBackButton(t: t, onTap: () => context.canPop() ? context.pop() : context.go('/settings')),
                  const SizedBox(width: 12),
                  Text(
                    l10n.manageGages,
                    style: TextStyle(
                      color: t.textOnDark,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontFamily: t.displayFont,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                children: [
                  _SectionHeader(label: l10n.wheelModeFamily, t: t),
                  const SizedBox(height: 8),
                  if (familyGages.isEmpty)
                    _EmptyHint(t: t, label: l10n.noGagesConfigured)
                  else
                    for (final g in familyGages)
                      _GageTile(gage: g, t: t, l10n: l10n, notifier: notifier),
                  const SizedBox(height: 24),
                  _SectionHeader(label: l10n.wheelModeAdult, t: t),
                  const SizedBox(height: 8),
                  if (adultGages.isEmpty)
                    _EmptyHint(t: t, label: l10n.noGagesConfigured)
                  else
                    for (final g in adultGages)
                      _GageTile(gage: g, t: t, l10n: l10n, notifier: notifier),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: t.accent,
        onPressed: () => _showAddSheet(context, t, l10n, notifier),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddSheet(BuildContext context, AppThemeTokens t, AppLocalizations l10n, GageNotifier notifier) {
    _showGageSheet(context, t, l10n, notifier, null);
  }

  static void _showGageSheet(
    BuildContext context,
    AppThemeTokens t,
    AppLocalizations l10n,
    GageNotifier notifier,
    Gage? existing,
  ) {
    final controller = TextEditingController(text: existing?.text ?? '');
    bool isAdult = existing?.isAdult ?? false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(
              color: t.bg,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: t.surfaceBorder, borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  existing == null ? l10n.addGage : l10n.editGage,
                  style: TextStyle(color: t.textOnDark, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: t.displayFont),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  autofocus: true,
                  style: TextStyle(color: t.textOnDark, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: l10n.gageHint,
                    hintStyle: TextStyle(color: t.textDim),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: t.surfaceBorder)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: t.accent, width: 2)),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => setSheet(() => isAdult = !isAdult),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 44,
                        height: 26,
                        decoration: BoxDecoration(
                          color: isAdult ? Colors.red.withValues(alpha: 0.8) : t.surfaceBorder,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: AnimatedAlign(
                          duration: const Duration(milliseconds: 200),
                          alignment: isAdult ? Alignment.centerRight : Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: Container(width: 20, height: 20, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(l10n.adultGage, style: TextStyle(color: t.text, fontSize: 15)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: t.accent, padding: const EdgeInsets.symmetric(vertical: 14)),
                    onPressed: () {
                      final text = controller.text.trim();
                      if (text.isEmpty) return;
                      Navigator.of(ctx).pop();
                      if (existing == null) {
                        notifier.addGage(text, isAdult);
                      } else {
                        notifier.updateGage(existing.copyWith(text: text, isAdult: isAdult));
                      }
                    },
                    child: Text(
                      l10n.save,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final AppThemeTokens t;
  const _SectionHeader({required this.label, required this.t});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        color: t.textOnDark.withValues(alpha: 0.5),
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.4,
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  final AppThemeTokens t;
  final String label;
  const _EmptyHint({required this.t, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(label, style: TextStyle(color: t.textDim, fontSize: 14, fontStyle: FontStyle.italic)),
    );
  }
}

class _GageTile extends StatelessWidget {
  final Gage gage;
  final AppThemeTokens t;
  final AppLocalizations l10n;
  final GageNotifier notifier;
  const _GageTile({required this.gage, required this.t, required this.l10n, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(gage.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(t.shape.smRadius),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.red),
      ),
      onDismissed: (_) => notifier.removeGage(gage.id),
      child: GestureDetector(
        onTap: () => GageListScreen._showGageSheet(context, t, l10n, notifier, gage),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: t.surface.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(t.shape.smRadius),
            border: Border.all(color: t.surfaceBorder.withValues(alpha: 0.4)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(gage.text, style: TextStyle(color: t.textOnDark, fontSize: 15)),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right_rounded, color: t.textDim, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
