import 'package:dohwaji/interface/storage_interface.dart';
import 'package:universal_html/html.dart';

class WebStorageUtil extends StorageInterface {
  @override
  void clearStorage() {
    window.localStorage.clear();
  }

  @override
  Future<String?> readData(String key) async {
    // var data = html.window.localStorage[key];
    var data = window.localStorage[key];
    return data;
  }

  @override
  void removeData(String key) {
    window.localStorage.remove(key);
  }

  @override
  void saveData(String key, String data) {
    window.localStorage.addAll({key: data});
  }

  @override
  bool contains(String key) {
    bool hasData = window.localStorage.containsKey(key);
    return hasData;
  }
}
