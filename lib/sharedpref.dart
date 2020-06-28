import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtil {
  static SharedPrefUtil _instance;
  static SharedPreferences _sharedPrefrence;

  static SharedPrefUtil getInstance() {
    if (_instance == null) {
      _instance = SharedPrefUtil();
    }
    return _instance;
  }

  static init() async {
    if (_sharedPrefrence == null) {
      _sharedPrefrence = await SharedPreferences.getInstance();
    }
    return _sharedPrefrence;
  }

  String getData(key) {
    return _sharedPrefrence.get(key) ?? '';
  }

  Future<bool> deleteDataByKey(key) {
    return _sharedPrefrence.remove(key);
  }

  void saveData(String key, value) {
    _sharedPrefrence.setString(key, value);
  }
}
