import '../models/game_model.dart';
import '../models/round_model.dart';
import '../models/team_model.dart';

/// In-memory yerel oyun veri kaynağı.
class LocalGameDataSource {
  GameModel? _currentGame;
  final List<RoundModel> _rounds = [];

  GameModel? get currentGame => _currentGame;

  List<RoundModel> get rounds => List.unmodifiable(_rounds);

  void saveGame(GameModel game) {
    _currentGame = game;
  }

  void updateGame(GameModel game) {
    _currentGame = game;
  }

  void addRound(RoundModel round) {
    _rounds.add(round);
  }

  RoundModel updateRound(int roundNumber, Map<String, int> playerScores) {
    final index = _rounds.indexWhere((r) => r.roundNumber == roundNumber);
    if (index == -1) {
      throw StateError('El bulunamadı: $roundNumber');
    }
    final updated = RoundModel(
      roundNumber: roundNumber,
      playerScores: Map<String, int>.from(playerScores),
    );
    _rounds[index] = updated;
    return updated;
  }

  void deleteRound(int roundNumber) {
    _rounds.removeWhere((r) => r.roundNumber == roundNumber);
    for (var i = 0; i < _rounds.length; i++) {
      _rounds[i] = RoundModel(
        roundNumber: i + 1,
        playerScores: _rounds[i].playerScores,
      );
    }
  }

  void clear() {
    _currentGame = null;
    _rounds.clear();
  }

  GameModel assignTeams(List<TeamModel> teams) {
    if (_currentGame == null) {
      throw StateError('Aktif oyun bulunamadı.');
    }
    _currentGame = _currentGame!.copyWith(teams: teams);
    return _currentGame!;
  }
}
