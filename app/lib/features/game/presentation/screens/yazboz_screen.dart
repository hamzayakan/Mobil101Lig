import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/yazboz_notifier.dart';
import '../widgets/player_setup_section.dart';
import '../widgets/round_list_section.dart';
import '../widgets/score_summary_section.dart';
import '../widgets/team_setup_section.dart';

/// 101 yazboz ana ekranı.
class YazbozScreen extends ConsumerWidget {
  const YazbozScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(yazbozNotifierProvider);
    final notifier = ref.read(yazbozNotifierProvider.notifier);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('101 Yazboz'),
          actions: [
            if (state.game != null)
              IconButton(
                onPressed: notifier.reset,
                icon: const Icon(Icons.refresh),
                tooltip: 'Yeni Oyun',
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    child: ListTile(
                      leading: Icon(Icons.error_outline, color: Colors.red.shade700),
                      title: Text(state.errorMessage!),
                      trailing: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: notifier.clearError,
                      ),
                    ),
                  ),
                ),
              if (state.phase == YazbozPhase.setup) const PlayerSetupSection(),
              if (state.phase == YazbozPhase.teamSetup) const TeamSetupSection(),
              if (state.phase == YazbozPhase.playing) ...[
                const RoundListSection(),
                const SizedBox(height: 16),
                const ScoreSummarySection(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
