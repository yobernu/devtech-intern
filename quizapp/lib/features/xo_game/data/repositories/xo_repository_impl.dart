import '../../domain/repositories/xo_repository.dart';
import '../datasources/xo_local_datasource.dart';

class XoRepositoryImpl implements XoRepository {
  final XoLocalDatasource localDatasource;

  XoRepositoryImpl({required this.localDatasource});

  @override
  Future<int> getScore(String playerId) {
    return localDatasource.getScore(playerId);
  }

  @override
  Future<void> saveScore(String playerId, int score) {
    return localDatasource.saveScore(playerId, score);
  }
}
