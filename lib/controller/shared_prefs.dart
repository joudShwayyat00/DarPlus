import 'package:shared_preferences/shared_preferences.dart';

class SharedPerfManager {
  static final SharedPerfManager _instance = SharedPerfManager._internal();
  factory SharedPerfManager() => _instance;
  SharedPerfManager._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    // deviceId = await PlatformDeviceId.getDeviceId ?? '';
    // debugPrint("deviceId : $deviceId ");
    // mytoken = await FirebaseMessaging.instance.getToken() ?? "";
    // debugPrint("mytoken : $mytoken ");
  }

  static late SharedPreferences _prefs;
  SharedPreferences get prefs => _prefs;

  static late String _languageCode;
  static late bool _isLoggedIn;

  String get languageCode {
    _languageCode = SharedPerHelper().getString(
      'languageCode',
      defaultValue: 'en',
    );
    return _languageCode;
  }

  set languageCode(String value) {
    _languageCode = SharedPerHelper().setString('languageCode', value);
  }

  bool get isLoggedIn {
    _isLoggedIn = SharedPerHelper().getBool('isLoggedIn');
    return _isLoggedIn;
  }

  set isLoggedIn(bool value) {
    _isLoggedIn = SharedPerHelper().setBool('isLoggedIn', value);
  }

  static late String _token;

  String get token {
    _token = SharedPerHelper().getString('token');
    return _token;
  }

  set token(String value) {
    _token = SharedPerHelper().setString('token', value);
  }

  void clear() {
    _prefs.clear();
  }

  void logOut() {
    isLoggedIn = false;
  }

  void remove(String key) {
    _prefs.remove(key);
  }
}

class SharedPerHelper {
  static final SharedPerHelper _instance = SharedPerHelper._internal();
  factory SharedPerHelper() => _instance;
  SharedPerHelper._internal();
  final SharedPreferences _prefs = SharedPerfManager().prefs;

  String getString(String key, {String defaultValue = ''}) {
    if (_prefs.containsKey(key)) {
      return _prefs.getString(key)!;
    } else {
      return defaultValue;
    }
  }

  String setString(String key, String value) {
    _prefs.setString(key, value);
    return value;
  }

  bool getBool(String key, {bool defaultValue = false}) {
    if (_prefs.containsKey(key)) {
      return _prefs.getBool(key)!;
    } else {
      return defaultValue;
    }
  }

  bool setBool(String key, bool value) {
    _prefs.setBool(key, value);
    return value;
  }

  int getInt(String key, {int defaultValue = 0}) {
    if (_prefs.containsKey(key)) {
      return _prefs.getInt(key)!;
    } else {
      return defaultValue;
    }
  }

  int setInt(String key, int value) {
    _prefs.setInt(key, value);
    return value;
  }

  double getDouble(String key, {double defaultValue = 0.0}) {
    if (_prefs.containsKey(key)) {
      return _prefs.getDouble(key)!;
    } else {
      return defaultValue;
    }
  }

  double setDouble(String key, double value) {
    _prefs.setDouble(key, value);
    return value;
  }
}
