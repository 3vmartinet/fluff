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

  Future<T?> get<T>(String pref) {
    return _get().then((prefs) => prefs.get(pref) as T?);
  }
}
