import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtil {
  // create a singleton class for shared preferences
  static SharedPrefUtil _instance;
  static SharedPreferences _sharedPrefrence;
  //static access to the one instance
  static SharedPrefUtil getInstance() {
    if (_instance == null) {
      _instance = SharedPrefUtil();
    }
    return _instance;
  }

  //init shared_preferences for only one time
  static init() async {
    if (_sharedPrefrence == null) {
      _sharedPrefrence = await SharedPreferences.getInstance();
    }
    return _sharedPrefrence;
  }

//helper method to get the data
  String getData(key) {
    return _sharedPrefrence.get(key) ?? '';
  }

//helper method to remove the data
  Future<bool> deleteDataByKey(key) {
    return _sharedPrefrence.remove(key);
  }

//helper method to save the data
  void saveData(String key, value) {
    _sharedPrefrence.setString(key, value);
  }
}
