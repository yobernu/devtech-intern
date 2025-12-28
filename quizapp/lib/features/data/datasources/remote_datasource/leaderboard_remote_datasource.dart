import 'package:quizapp/features/data/models/leaderboard_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class LeaderboardRemoteDataSource {
  Future<List<LeaderboardModel>> getLeaderboard(String period, int limit);
  Future<LeaderboardModel> getUserRank(String userId);
}

class LeaderboardRemoteDataSourceImpl implements LeaderboardRemoteDataSource {
  final SupabaseClient supabase;

  LeaderboardRemoteDataSourceImpl(this.supabase);

  @override
  Future<List<LeaderboardModel>> getLeaderboard(
    String period,
    int limit,
  ) async {
    final response = await supabase
        .from('profiles')
        .select('id, username, avatar_url, score')
        .order('score', ascending: false)
        .limit(limit);

    final List<dynamic> data = response as List<dynamic>;

    return data.asMap().entries.map((entry) {
      final int rank = entry.key + 1;
      return LeaderboardModel.fromJson(entry.value, rank);
    }).toList();
  }

  @override
  Future<LeaderboardModel> getUserRank(String userId) async {
    // Fetch user profile
    final userResponse = await supabase
        .from('profiles')
        .select('id, username, avatar_url, score')
        .eq('id', userId)
        .single();

    // To get the actual rank, we count how many users have a higher score
    final score = userResponse['score'] as int? ?? 0;

    final count = await supabase
        .from('profiles')
        .count(CountOption.exact)
        .gt('score', score);

    final rank = count + 1;

    return LeaderboardModel.fromJson(userResponse, rank);
  }
}
