import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;

  init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  String get userId => _sharedPrefs!.getString("userId") ?? "";
  String get token => _sharedPrefs!.getString("token") ?? "";

  set userId(String value) {
    _sharedPrefs!.setString('userId', value);
  }

  set token(String value) {
    _sharedPrefs!.setString('token', value);
  }

  void remove(String value) {
    _sharedPrefs!.remove(value);
  }
}

final sharedPrefs = SharedPrefs();
