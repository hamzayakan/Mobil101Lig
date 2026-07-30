import '../entities/game_entity.dart';
import '../entities/team_entity.dart';
import '../repositories/game_repository.dart';

/// Takım ataması doğrulama hatası.
class TeamAssignmentException implements Exception {
  TeamAssignmentException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Manuel takım atamasını doğrular ve kaydeder.
class AssignTeamsUseCase {
  AssignTeamsUseCase(this._repository);

  final GameRepository _repository;

  /// Takımları doğrular ve oyuna kaydeder.
  Future<GameEntity> execute({
    required GameEntity game,
    required List<TeamEntity> teams,
  }) async {
    _validateTeams(game: game, teams: teams);
    return _repository.assignTeams(teams);
  }

  void _validateTeams({
    required GameEntity game,
    required List<TeamEntity> teams,
  }) {
    if (teams.length < 2) {
      throw TeamAssignmentException('En az 2 takım olmalıdır.');
    }

    final playerIds = game.players.map((p) => p.id).toSet();
    final assignedIds = <String>{};

    for (final team in teams) {
      if (team.playerIds.isEmpty) {
        throw TeamAssignmentException('${team.name} boş olamaz.');
      }

      for (final playerId in team.playerIds) {
        if (!playerIds.contains(playerId)) {
          throw TeamAssignmentException('Geçersiz oyuncu: $playerId');
        }
        if (assignedIds.contains(playerId)) {
          throw TeamAssignmentException(
            'Her oyuncu yalnızca bir takımda olabilir.',
          );
        }
        assignedIds.add(playerId);
      }
    }

    if (assignedIds.length != playerIds.length) {
      throw TeamAssignmentException('Tüm oyuncular bir takıma atanmalıdır.');
    }

    final teamSizes = teams.map((t) => t.playerIds.length).toSet();
    if (teamSizes.length > 1) {
      throw TeamAssignmentException('Takımlar eşit oyuncu sayısına sahip olmalıdır.');
    }
  }
}
