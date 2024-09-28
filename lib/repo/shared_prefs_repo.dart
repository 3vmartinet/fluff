import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsRepo {
  static final SharedPrefsRepo _instance = SharedPrefsRepo._init();

  SharedPrefsRepo._init();

  factory SharedPrefsRepo() => _instance;

  Future<SharedPreferences> _get() => SharedPreferences.getInstance();

  void set<T>({required String name, required T value}) {
    _get().then(
      (prefs) {
        switch (value) {
          case int _:
            prefs.setInt(name, value);
          case double _:
            prefs.setDouble(name, value);
          case String _:
            prefs.setString(name, value);
          case bool _:
            prefs.setBool(name, value);
          case List<String> _:
            prefs.setStringList(name, value);
        }
      },
    );
  }

  Future<T?>? get<T extends Object>(String pref) async {
    final prefs = await _get();

    switch (T) {
      case const (int):
        return prefs.getInt(pref) as T?;
      case const (double):
        return prefs.getDouble(pref) as T?;
      case const (String):
        return prefs.getString(pref) as T?;
      case const (bool):
        return prefs.getBool(pref) as T?;
      case List<String> _:
        return prefs.getStringList(pref) as T?;
    }
    return null;
  }
}
