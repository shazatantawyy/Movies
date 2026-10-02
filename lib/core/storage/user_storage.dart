import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/movies_model.dart';

class UserStorage extends ChangeNotifier {
  UserStorage._();

  static final UserStorage instance = UserStorage._();

  static const String _nameKey = 'name';
  static const String _phoneKey = 'phone';
  static const String _avatarKey = 'avatar_index';
  static const String _watchListKey = 'watch_list';
  static const String _historyKey = 'history';

  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }


  String get name => _prefs.getString(_nameKey) ?? 'John Safwat';
  String get phone => _prefs.getString(_phoneKey) ?? '';
  int get avatarIndex => _prefs.getInt(_avatarKey) ?? 0;

  Future<void> updateProfile({
    required String name,
    required String phone,
    required int avatarIndex,
  }) async {
    await _prefs.setString(_nameKey, name);
    await _prefs.setString(_phoneKey, phone);
    await _prefs.setInt(_avatarKey, avatarIndex);
    notifyListeners();
  }

  Future<void> clearAll() async {
    await _prefs.clear();
    notifyListeners();
  }


  List<Movies> get watchList => _read(_watchListKey);
  List<Movies> get history => _read(_historyKey);

  bool isInWatchList(int? id) => watchList.any((m) => m.id == id);

  Future<void> toggleWatchList(Movies movie) async {
    final list = watchList;
    final index = list.indexWhere((m) => m.id == movie.id);

    if (index >= 0) {
      list.removeAt(index);
    } else {
      list.insert(0, movie);
    }

    await _write(_watchListKey, list);
    notifyListeners();
  }

  Future<void> addToHistory(Movies movie) async {
    final list = history..removeWhere((m) => m.id == movie.id);
    list.insert(0, movie);

    await _write(_historyKey, list);
    notifyListeners();
  }
  List<Movies> _read(String key) {
    final raw = _prefs.getStringList(key) ?? [];

    return raw.map((item) {
      final map = jsonDecode(item) as Map<String, dynamic>;
      return Movies(
        id: map['id'],
        mediumCoverImage: map['cover'],
        rating: (map['rating'] as num?)?.toDouble(),
      );
    }).toList();
  }

  Future<void> _write(String key, List<Movies> movies) {
    final encoded = movies
        .map(
          (m) => jsonEncode({
        'id': m.id,
        'cover': m.mediumCoverImage,
        'rating': m.rating,
      }),
    )
        .toList();

    return _prefs.setStringList(key, encoded);
  }
}