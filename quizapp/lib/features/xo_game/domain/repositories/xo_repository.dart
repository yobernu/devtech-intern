abstract class XoRepository {
  Future<void> saveScore(String playerId, int score);
  Future<int> getScore(String playerId);
}
