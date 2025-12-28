import 'package:shared_preferences/shared_preferences.dart';

abstract class XoLocalDatasource {
  Future<void> saveScore(String playerId, int score);
  Future<int> getScore(String playerId);
}

class XoLocalDatasourceImpl implements XoLocalDatasource {
  final SharedPreferences sharedPreferences;

  XoLocalDatasourceImpl({required this.sharedPreferences});

  @override
  Future<int> getScore(String playerId) async {
    return sharedPreferences.getInt('xo_score_$playerId') ?? 0;
  }

  @override
  Future<void> saveScore(String playerId, int score) async {
    await sharedPreferences.setInt('xo_score_$playerId', score);
  }
}
