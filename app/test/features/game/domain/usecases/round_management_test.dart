import 'package:app/features/game/data/datasources/local_game_datasource.dart';
import 'package:app/features/game/data/repositories/game_repository_impl.dart';
import 'package:app/features/game/domain/entities/game_type.dart';
import 'package:app/features/game/domain/entities/player_entity.dart';
import 'package:app/features/game/domain/usecases/delete_round.dart';
import 'package:app/features/game/domain/usecases/update_round.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GameRepositoryImpl repository;
  late UpdateRoundUseCase updateRoundUseCase;
  late DeleteRoundUseCase deleteRoundUseCase;

  setUp(() async {
    repository = GameRepositoryImpl(LocalGameDataSource());
    updateRoundUseCase = UpdateRoundUseCase(repository);
    deleteRoundUseCase = DeleteRoundUseCase(repository);

    await repository.createGame(
      players: const [
        PlayerEntity(id: 'p1', name: 'Ali'),
        PlayerEntity(id: 'p2', name: 'Veli'),
      ],
      gameType: GameType.single,
    );
    await repository.addRound({'p1': 10, 'p2': 20});
    await repository.addRound({'p1': 5, 'p2': -3});
  });

  test('el güncelleme toplam skoru yeniden hesaplar', () async {
    await updateRoundUseCase.execute(
      roundNumber: 1,
      playerScores: {'p1': 100, 'p2': 0},
    );

    final rounds = await repository.getRounds();
    expect(rounds.first.playerScores['p1'], 100);
    expect(rounds.length, 2);
  });

  test('el silme kalan elleri yeniden numaralandırır', () async {
    await deleteRoundUseCase.execute(1);

    final rounds = await repository.getRounds();
    expect(rounds.length, 1);
    expect(rounds.first.roundNumber, 1);
    expect(rounds.first.playerScores, {'p1': 5, 'p2': -3});
  });
}
