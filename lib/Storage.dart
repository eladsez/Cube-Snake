import 'package:shared_preferences/shared_preferences.dart';

class Storage{

  static SharedPreferences? _storage;

  static Future init() async =>
      _storage = await SharedPreferences.getInstance();

  static Future updateBestScore(int best) async=>
      await _storage?.setInt("BEST_SCORE", best);

  static int? getBestScore() => _storage?.getInt("BEST_SCORE");
}