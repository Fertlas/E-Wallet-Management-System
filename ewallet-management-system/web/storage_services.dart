import 'dart:html';

class StorageService {
  static void saveTransaction<T>(String key, List<T> value) {
    window.localStorage[key] = value.toString();
  }
}
