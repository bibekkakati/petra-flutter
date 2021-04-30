import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage {
  static LocalStorage _localStorage;
  static FlutterSecureStorage _flutterSecureStorage;

  LocalStorage._createInstance();

  factory LocalStorage() {
    if (_localStorage == null) {
      _localStorage = LocalStorage._createInstance();
    }
    return _localStorage;
  }

  FlutterSecureStorage get _storage {
    if (_flutterSecureStorage == null) {
      _flutterSecureStorage = new FlutterSecureStorage();
    }
    return _flutterSecureStorage;
  }

  Future<String> get(String key) async {
    String value = await _storage.read(key: key);
    return value;
  }

  Future<bool> set(String key, String value) async {
    await _storage.write(key: key, value: value);
    return true;
  }

  Future<bool> del(String key) async {
    await _storage.delete(key: key);
    return true;
  }
}
