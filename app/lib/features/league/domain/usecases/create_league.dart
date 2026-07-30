import '../entities/league_entity.dart';
import '../repositories/league_repository.dart';

/// Lig oluşturma use case'i.
class CreateLeagueUseCase {
  CreateLeagueUseCase(this._repository);

  final LeagueRepository _repository;

  Future<LeagueEntity> execute({
    required String name,
    required String ownerId,
    required String ownerDisplayName,
  }) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Lig adı boş olamaz.');
    }
    return _repository.createLeague(
      name: trimmed,
      ownerId: ownerId,
      ownerDisplayName: ownerDisplayName,
    );
  }
}
